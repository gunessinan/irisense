import 'package:flutter/material.dart';
import 'package:irisense/core/services/AI/ai_settings.dart';
import 'package:irisense/core/services/AI/local_llm.dart';
import 'package:irisense/core/services/AI/online_llm.dart';

class AIManager {
  static final AISettings Settings = AISettings();

  static Future<String> sendMessage(String keywords, String context) async {
    debugPrint("Model: ${Settings.Model}");
    switch (Settings.Model) {
      case 'None':
        return "LLM model is not selected.";
      case 'LocalLLM':
        return LocalLLM.ask(keywords, context);
      case 'Gemini':
        return OnlineLLM.ask_gemini(keywords, context);
      case 'ChatGPT':
        return OnlineLLM.ask_chatgpt(keywords, context);
      case 'Claude':
        return OnlineLLM.ask_claude(keywords, context);
      case 'Copilot':
      // return OnlineLLM.ask_copilot(keywords, context);
      default:
        return "";
    }
  }
}
