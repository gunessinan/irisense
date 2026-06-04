import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/l10n/app_localizations.dart';
import '../view_models/text_state_viewmodel.dart';

class CombinationBox extends StatelessWidget {
  const CombinationBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textState = context.watch<TextStateViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border.all(
          color: AppColors.accentGray.withValues(alpha: 0.35),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Başlık
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.accentGray.withValues(alpha: 0.25),
                ),
              ),
            ),
            child: Text(
              l10n.textEntry,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          // İçerik
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                l10n.text(textState.textBox),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
