import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class WordFilterViewModel extends ChangeNotifier {
  static const int wordListSize = 12;

  List<String> wordList = List.filled(12, "");
  List<String> _allWords = [];

  Future<void> loadWords(String langCode) async {
    try {
      final raw = await rootBundle.loadString("assets/words/${langCode}Words.txt");
      _allWords = raw.split('\n').map((w) => w.trim()).where((w) => w.isNotEmpty).toList();
      wordList = List.filled(wordListSize, "");
      notifyListeners();
    } catch (e) {
      debugPrint("WordFilterViewModel: Error loading words: $e");
    }
  }

  void filterWords(List<String> groups) {
    if (groups.isEmpty) {
      wordList = List.filled(wordListSize, "");
      notifyListeners();
      return;
    }

    List<String> filtered = _allWords;
    for (int i = 0; i < groups.length; i++) {
      final group = groups[i];
      filtered = filtered.where((word) {
        if (word.length <= i) return false;
        return group.contains(word[i].toUpperCase());
      }).toList();
    }

    filtered.sort((a, b) => a.length.compareTo(b.length));

    if (filtered.isEmpty) {
      wordList = List.filled(wordListSize, "");
    } else {
      final taken = filtered.take(wordListSize).toList();
      final remaining = wordListSize - taken.length;
      wordList = [...taken, ...List.filled(remaining, "")];
    }

    notifyListeners();
  }

  void reset() {
    wordList = List.filled(wordListSize, "");
    notifyListeners();
  }
}