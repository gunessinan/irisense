import 'package:flutter/foundation.dart';
import 'package:irisense/core/services/AI/ai_manager.dart';

class TextStateViewModel extends ChangeNotifier {
  String textBox = "";
  String llmText = "";
  String contextText = "";

  void appendCombination(String combination) {
    textBox += "$combination ";
    notifyListeners();
  }

  void selectWord(String word) {
    List<String> parts = textBox.split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    parts.removeWhere((p) => p.contains('-'));
    parts.add(word);
    textBox = "${parts.join(' ')} ";
    notifyListeners();
  }

  void deleteLast() {
    final parts = textBox.split(" ").where((p) => p.isNotEmpty).toList();
    if (parts.isNotEmpty) parts.removeLast();
    textBox = parts.join(" ");
    notifyListeners();
  }

  void updateContext(String text) {
    contextText = text;
    notifyListeners();
  }

  Future<void> fetchAISuggestion() async {
    llmText = "...";
    notifyListeners();
    llmText = await AIManager.sendMessage(textBox, contextText);
    notifyListeners();
  }

  void clear() {
    textBox = "";
    llmText = "";
    notifyListeners();
  }
}