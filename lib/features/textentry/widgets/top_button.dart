import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Core
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/l10n/app_localizations.dart';
// Text Entry
import '../view_models/keyboard_viewmodel.dart';

class TopButton extends StatelessWidget {
  final bool isSwitch;
  final VoidCallback onTap;
  final bool fullWidth;

  const TopButton({
    super.key,
    required this.isSwitch,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final keyboard = context.watch<KeyboardViewModel>();

    final bool isHovered = isSwitch
        ? keyboard.hoveredButton == 5
        : keyboard.hoveredButton == 4;

    final String label = keyboard.wordMode && !isSwitch
        ? AppLocalizations.of(context)!.speakAction
        : !keyboard.wordMode && !isSwitch
            ? AppLocalizations.of(context)!.deleteAction
            : AppLocalizations.of(context)!.switchAction;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.expand(
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSwitch ? GazeIcons.down : GazeIcons.closed,
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isHovered ? AppColors.yellowAccent : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
