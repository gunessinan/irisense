import 'package:flutter/foundation.dart';

class KeyboardViewModel extends ChangeNotifier {
  bool wordMode = false;
  int hoveredButton = -1;
  int wordPage = 0;

  final Map<String, List<String>> _letterGroupsByLang = {
    "en-US": ["ABCDEF", "GHIJKLM", "NOPQRST", "UVWXYZ"],
    "tr-TR": ["ABCÇDEFG", "ĞHİIJKL", "MNOÖPRS", "ŞTUÜVYZ"],
    "es-ES": ["ABCDEF", "GHIJKLM", "NÑOPQRS", "TUVWXYZ"],
    "pt-PT": ["ABCDEF", "GHIJKLM", "NÑOPQRS", "TUVWXYZ"],
    "ru-RU": ["АБВГДЕЁЖЗ", "ИЙКЛМНОПР", "СТУФХЦЧШЩ", "ЪЫЬЭЮЯ"],
    "de-DE": ["ABCDEF", "GHIJKLM", "NOPQRSTÜ", "VWXYZÄÖß"],
    "fr-FR": ["ABCDEÉ", "FGHIJKLM", "NOPQRST", "UVWXYZ"],
  };

  List<String> letterGroups = ["ABCDEF", "GHIJKLM", "NOPQRST", "UVWXYZ"];

  void setLanguage(String langCode) {
    letterGroups = _letterGroupsByLang[langCode] ?? 
        ["ABCDEF", "GHIJKLM", "NOPQRST", "UVWXYZ"];
    notifyListeners();
  }

  void toggleWordMode() {
    wordMode = !wordMode;
    wordPage = 0;
    notifyListeners();
  }

  void nextWordPage() {
    wordPage = (wordPage >= 3) ? 0 : wordPage + 1;
    notifyListeners();
  }

  void setHovered(int index) {
    hoveredButton = index;
    notifyListeners();
  }

  String groupToCombination(String group) {
    return "${group[0]}-${group[group.length - 1]}";
  }

  List<String> combinationToGroup(String textBox) {
    List<String> items = textBox.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (items.isEmpty) return [];

    int lastNonDashIndex = items.lastIndexWhere((item) => !item.contains('-'));
    List<String> result = items.sublist(lastNonDashIndex + 1);

    return result.map((combo) {
      final parts = combo.split('-');
      if (parts.length == 2) {
        for (String group in letterGroups) {
          if (group.contains(parts[0]) && group.contains(parts[1])) {
            return group;
          }
        }
      }
      return combo;
    }).toList();
  }
}