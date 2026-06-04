import 'package:flutter/material.dart';
// Core
import 'package:irisense/core/constants/classic_theme.dart';
// Quick Chat
import '../models/quicktexts.dart';
import '../view_models/quickchat_viewmodel.dart';

class QuickButton extends StatelessWidget {
  final QuickChatViewModel viewModel;
  final int num;

  const QuickButton({
    super.key,
    required this.viewModel,
    required this.num,
  });

  static final List<Widget> _icons = [
    GazeIcons.leftup,
    GazeIcons.up,
    GazeIcons.rightup,
    GazeIcons.left,
    GazeIcons.closed,
    GazeIcons.right,
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth  = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final quickChatTexts      = getQuickChatTexts(context);
    final bool isHovered      = viewModel.hoveredButton == num;
    final bool isBottom       = {3, 4, 5}.contains(num);

    return GestureDetector(
      onTap: () => viewModel.button_OnTap(
        num,
        quickChatTexts[num][viewModel.currentPage],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: screenWidth * 0.31,
        height: screenHeight * 0.40,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.limeAccent.withValues(alpha: 0.07)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isHovered
                ? AppColors.limeAccent.withValues(alpha: 0.55)
                : AppColors.accentGray.withValues(alpha: 0.22),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: isBottom
              ? VerticalDirection.up
              : VerticalDirection.down,
          children: [
            _icons[num],
            const SizedBox(height: 10),
            Text(
              quickChatTexts[num][viewModel.currentPage],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isHovered ? AppColors.limeAccent : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
