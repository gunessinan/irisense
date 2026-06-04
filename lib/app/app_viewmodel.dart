import 'package:flutter/material.dart';
import 'package:irisense/core/services/sound_service.dart';

class AppViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  final SoundService soundService = SoundService();
  /*
  String language;

  AppViewModel({required this.language})
  {
    soundService.updateLanguage(language);
  }
  */

  int currentIndex = 0;
  bool _navbar_isOpen = false;

  // Getter
  bool get navbar_isOpen => _navbar_isOpen;

  // Setter
  set navbar_isOpen(bool value) {
    if (_navbar_isOpen != value) {
      _navbar_isOpen = value;
      notifyListeners();
    }
  }

  final List<String> pageTitles = ["Settings", "Text Entry", "Quick"];

  void goToPage(int index) {
    currentIndex = index;
    //pageController.jumpToPage(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
