import 'package:flutter/material.dart';
import 'package:irisense/l10n/app_localizations.dart';

List<List<String>> getQuickChatTexts(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return [
    [
      l10n.qc0,              // Basic Needs
      l10n.qc0opt0,          // I want to eat something.
      l10n.qc1opt0,          // Yes 
      l10n.qc2opt0,          // I am happy.
      l10n.qc3opt0,          // I feel hot.
      l10n.qc4opt0,          // I want to go outside.
      l10n.qc5opt0           // I feel some pain.
    ],
    [ 
      l10n.qc1,              // Frequently Used
      l10n.qc0opt1,          // I want to sleep.
      l10n.qc1opt1,          // I dont know
      l10n.qc2opt1,          // I am sad.
      l10n.qc3opt1,          // I feel cold.
      l10n.qc4opt1,          // I want to read the newspaper.
      l10n.qc5opt1           // I feel extreme pain.
    ],
    [
      l10n.qc2,              // Emotions
      l10n.qc0opt2,          // I want to go to the bathroom.
      l10n.qc1opt2,          // No
      l10n.qc2opt2,          // I am angry.
      l10n.qc3opt2,          // It is too noisy.
      l10n.qc4opt2,          // I want to listen to music.
      l10n.qc5opt2           // I need to eat my pills.
    ],
    [
      l10n.qc3,              // Environment Control
      l10n.qc0opt3,          // I want to drink water.
      l10n.qc1opt3,          // Thank You
      l10n.qc2opt3,          // I am scared.
      l10n.qc3opt3,          // It is too bright.
      l10n.qc4opt3,          // I want to watch television.
      l10n.qc5opt3           // I need to go to the hospital.
    ],
    [
      l10n.qc4,              // Social Activities and Recreation
      l10n.qc0opt4,          // I want to rest.
      l10n.qc1opt4,          // Hello
      l10n.qc2opt4,          // I am confused.
      l10n.qc3opt4,          // It is too dark.
      l10n.qc4opt4,          // I want to listen to the radio.
      l10n.qc5opt4           // I feel fine.
    ],
    [
      l10n.qc5,              // Medical Needs
      l10n.qc0opt5,          // I need help with basic care.
      l10n.qc1opt5,          // My apologies
      l10n.qc2opt5,          // I feel nervous.
      l10n.qc3opt5,          // The air feels stuffy.
      l10n.qc4opt5,          // I want to play a game.
      l10n.qc5opt5           // I need to see a doctor.
    ]
  ];
}