import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/services/user_data_manager.dart';
import 'package:irisense/l10n/app_localizations.dart';
import '../view_models/text_state_viewmodel.dart';

class LLMBox extends StatefulWidget {
  const LLMBox({super.key});

  @override
  State<LLMBox> createState() => _LLMBoxState();
}

class _LLMBoxState extends State<LLMBox> {
  bool _isInitialState = true;

  @override
  Widget build(BuildContext context) {
    final textState = context.watch<TextStateViewModel>();
    final userData  = Provider.of<UserDataManager>(context);
    final l10n      = AppLocalizations.of(context)!;

    if (textState.llmText.isNotEmpty && _isInitialState) {
      _isInitialState = false;
    }

    final String displayText = userData.generationModel == "None"
        ? "LLM: ${l10n.defaultLLM}"
        : "LLM: ${_isInitialState && textState.llmText.isEmpty
            ? l10n.defaultText
            : textState.llmText}";

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border.all(
          color: AppColors.limeAccent.withValues(alpha: 0.25),
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
              'LLM Box',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.limeAccent,
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
                displayText,
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
