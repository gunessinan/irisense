import 'package:flutter/foundation.dart';
import 'package:irisense/core/services/AI/ai_manager.dart';
import 'package:irisense/core/services/sound_service.dart';
import 'package:irisense/core/services/user_data_manager.dart';
import 'keyboard_viewmodel.dart';
import 'word_filter_viewmodel.dart';
import 'text_state_viewmodel.dart';
import 'mic_viewmodel.dart';

class TextEntryViewModel extends ChangeNotifier {
  final KeyboardViewModel keyboard;
  final WordFilterViewModel wordFilter;
  final TextStateViewModel textState;
  final MicViewModel mic;
  final SoundService soundService;
  final UserDataManager userDataManager;

  TextEntryViewModel({
    required this.soundService,
    required this.userDataManager,
  })  : keyboard = KeyboardViewModel(),
        wordFilter = WordFilterViewModel(),
        textState = TextStateViewModel(),
        mic = MicViewModel(soundService: soundService) {
    initVM();
  }

  Future<void> initVM() async {
  keyboard.setLanguage(userDataManager.language);
  await wordFilter.loadWords(userDataManager.language);
  AIManager.Settings.updateLanguage(userDataManager.language);
  AIManager.Settings.updateModel(userDataManager.generationModel);
}

  // --- Gaze Action Entry Point ---
  void actionTriggered(String gazeType) {
    const buttonMap = ["Left Up", "Right Up", "Left", "Right", "Blink", "Down"];
    final index = buttonMap.indexOf(gazeType);
    if (index == -1) { keyboard.setHovered(-1); return; }

    keyboard.setHovered(index);

    if (index == 4) _onUp();
    else if (index == 5) _onBlink();
    else keypadButton_onTap(index);
  }

  void keypadButton_onTap(int num) {
    if (num > 3) return;
    soundService.playBeep();
    keyboard.setHovered(num);

    if (num == 3 && keyboard.wordMode) {
      keyboard.nextWordPage();
      return;
    }

    if (!keyboard.wordMode) {
      final combo = keyboard.groupToCombination(keyboard.letterGroups[num]);
      textState.appendCombination(combo);
      wordFilter.filterWords(keyboard.combinationToGroup(textState.textBox));
    } else {
      final index = num + keyboard.wordPage * 3;
      final selected = wordFilter.wordList[index];
      if (selected.isNotEmpty) {
        textState.selectWord(selected);
        textState.fetchAISuggestion();
        wordFilter.reset();
      }
    }
  }

  void _onBlink() {
    // Switch mode
    soundService.playBeep();
    keyboard.toggleWordMode();
  }

  void _onUp() {
    // Speak or Delete
    soundService.playBeep();
    if (keyboard.wordMode) {
      final toSpeak = userDataManager.generationModel == "None"
          ? textState.textBox
          : textState.llmText;
      soundService.speak(toSpeak);
    } else {
      textState.deleteLast();
      wordFilter.filterWords(keyboard.combinationToGroup(textState.textBox));
    }
  }

  void topButton_onTap(bool isSwitch) => isSwitch ? _onBlink() : _onUp();

  void micButton_onTap() => mic.startListening(
    onResult: (text) => textState.updateContext(text),
  );
}