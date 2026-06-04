import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Core
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/l10n/app_localizations.dart';
// Text Entry
import '../view_models/text_state_viewmodel.dart';
import '../view_models/mic_viewmodel.dart';

class ContextBox extends StatelessWidget {
  final VoidCallback onMicTap;

  const ContextBox({super.key, required this.onMicTap});

  static const double _micBtnSize = 38.0;

  @override
  Widget build(BuildContext context) {
    final textState = context.watch<TextStateViewModel>();
    final mic       = context.watch<MicViewModel>();
    final l10n      = AppLocalizations.of(context)!;

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
      child: Stack(
        children: [
          // İçerik
          GestureDetector(
            onTap: () {
              textState.updateContext("");
              mic.stopListening();
            },
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
                  child: const Text(
                    'Context',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      textState.contextText.isEmpty
                          ? l10n.addContext
                          : l10n.context(textState.contextText),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Mikrofon butonu
          if (textState.contextText.isEmpty)
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: onMicTap,
                child: Container(
                  width: _micBtnSize,
                  height: _micBtnSize,
                  decoration: BoxDecoration(
                    color: mic.isRecording ? AppColors.errorColor : AppColors.yellowAccent,
                    borderRadius: BorderRadius.circular(WidgetDetails.borderRadius - 2),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/microphone.png',
                      width: _micBtnSize - 22,
                      height: _micBtnSize - 22,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
