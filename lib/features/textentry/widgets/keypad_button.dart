import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Core
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/l10n/app_localizations.dart';
// Text Entry
import '../view_models/keyboard_viewmodel.dart';
import '../view_models/word_filter_viewmodel.dart';

class KeypadButton extends StatelessWidget {
  final int num;
  final VoidCallback onTap;

  const KeypadButton({
    super.key,
    required this.num,
    required this.onTap,
  });

  static final List<Widget> _gazeIcons = [
    GazeIcons.leftup,
    GazeIcons.rightup,
    GazeIcons.left,
    GazeIcons.right,
  ];

  @override
  Widget build(BuildContext context) {
    final keyboard   = context.watch<KeyboardViewModel>();
    final wordFilter = context.watch<WordFilterViewModel>();
    final noMatch    = AppLocalizations.of(context)!.noMatch;
    final bool isHovered = keyboard.hoveredButton == num;
    final String rawCenter = !keyboard.wordMode
        ? keyboard.letterGroups[num]
        : num == 3
            ? AppLocalizations.of(context)!.nextPage
            : wordFilter.wordList[num + keyboard.wordPage * 3];
    final String centerText = rawCenter.isEmpty ? noMatch : rawCenter;

    final String rawHint = keyboard.wordMode
        ? keyboard.letterGroups[num]
        : wordFilter.wordList[num];
    final String hintText = rawHint.isEmpty ? noMatch : rawHint;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.limeAccent.withValues(alpha: 0.10)
              : AppColors.darkSurface,
          border: Border.all(
            color: isHovered
                ? AppColors.yellowAccent
                : AppColors.accentGray.withValues(alpha: 0.35),
            width: isHovered ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            // Gaze ikonu — yön köşesinde
            Positioned(
              left:  (num == 0 || num == 2) ? 12 : null,
              right: (num == 1 || num == 3) ? 12 : null,
              top:   (num == 0 || num == 1) ? 12 : null,
              bottom:(num == 2 || num == 3) ? 12 : null,
              child: _gazeIcons[num],
            ),
            // Merkez içerik
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hintText,
                    style: TextStyle(
                      color: AppColors.limeAccent.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    centerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isHovered ? AppColors.yellowAccent : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
