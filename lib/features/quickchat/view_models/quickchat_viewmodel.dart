import 'package:flutter/material.dart';
// Core - Services
import 'package:irisense/core/services/sound_service.dart';

class QuickChatViewModel extends ChangeNotifier
{
  int currentPage = 0;
  int hoveredButton = -1;
  SoundService soundService;

  QuickChatViewModel({
    required this.soundService
  });

  void button_OnTap(int num, String text)
  {    
    if (currentPage == 0)
    {
      soundService.playBeep();
      currentPage = num + 1;
      notifyListeners();
    }
    else
    {
      // Voice Service
      soundService.speak(text);

      // Back to Quick Chat Main Screen
      currentPage = 0;
      notifyListeners();
      return;
    }
  }

  void actionTriggered(String gazeType, List<List<String>> quickChatTexts)
  {
    // Maps Gaze Actions to Button IDs
    // 0: Left Up, 1: Up, 2: Right Up, 3: Left, 4: Blink, 5: Right
    List<String> buttonID = ["Left Up", "Blink", "Right Up", "Left", "Down", "Right"];
    print("ACTION TRIGGERED IN QUICKCHAT $gazeType");
    
    if (buttonID.contains(gazeType))
    {
      hoveredButton = buttonID.indexOf(gazeType);
      button_OnTap(hoveredButton, quickChatTexts[hoveredButton][currentPage]);
    }
    else 
    {
      hoveredButton = -1;
    }
    notifyListeners();
  }
}