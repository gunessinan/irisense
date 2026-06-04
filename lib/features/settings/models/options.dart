import 'package:flutter/material.dart';
import 'package:irisense/l10n/app_localizations.dart';

class Options {
  // Seçim Süresi Eşlemesi
  static Map<String, String> getDwellMap(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return {
      "Fast": l10n.slcTimeOpt0,
      "Standard": l10n.slcTimeOpt1,
      "Slow": l10n.slcTimeOpt2,
      "VerySlow": l10n.slcTimeOpt3,
    };
  }

  // Üretim Modeli Eşlemesi
  static Map<String, String> getGenModelMap(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return {
      "None": l10n.genModelOpt0,
      "LocalLLM": l10n.genModelOpt1,
      "Gemini": "Gemini",
      "ChatGPT": "ChatGPT",
      "Claude": "Claude",
      "Copilot": "Copilot",
    };
  }

  // Debug Modu Eşlemesi
  static Map<String, String> getDebugMap(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return {
      "Disabled": l10n.debugModeOpt0,
      "Enabled": l10n.debugModeOpt1,
    };
  }

  // Dil Eşlemesi
  static Map<String, String> getLanguageMap() {
    return {
      'en-US': 'English',
      'tr-TR': 'Türkçe',
      'es-ES': 'Español',
      'pt-PT': 'Português',
      'zh-CN': '中文',
      'hi-IN': 'हिंदी',
      'ru-RU': 'Русский',
      'de-DE': 'Deutsch',
      'fr-FR': 'Français',
      'it-IT': 'Italiano',
    };
  }
}