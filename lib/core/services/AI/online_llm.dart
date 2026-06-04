import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:irisense/core/services/AI/ai_manager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OnlineLLM
{
  static Future<String> ask_gemini(String keywords, String context) async {
    if (AIManager.Settings.Gemini.apiKey == null || AIManager.Settings.Gemini.apiKey == "") {
      return "ERROR: API Key cant be found. Please check the .env file.";
    }

    try {
      final model = GenerativeModel(
        model: AIManager.Settings.Gemini.model, // Model
        apiKey: AIManager.Settings.Gemini.apiKey!, // API Key
        systemInstruction: Content.text(AIManager.Settings.Instruction), // Instruction
      );

      final content = [Content.text('Keywords: $keywords, Context: $context')];

      final response = await model.generateContent(content);

      // Verify If Its Valid
      if (response.text != null) {
        return response.text!;
      } else {
        return "GEMINI_API_ERROR: Empty answer returned.";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<String> ask_claude(String keywords, String context) async {
    if (AIManager.Settings.Claude.apiKey == null || AIManager.Settings.Claude.apiKey == "") {
      return "ERROR: API Key cant be found. Please check the .env file.";
    }

    final response = await http.post(
      Uri.parse(AIManager.Settings.Claude.url), // API URL
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': AIManager.Settings.Claude.apiKey!, // API Key
        'anthropic-version': AIManager.Settings.Claude.anthropicVersion,
      },
      body: jsonEncode({
        'model': AIManager.Settings.Claude.model, // Model
        'max_tokens': AIManager.Settings.MaxTokens, // Max Tokens
        'system': AIManager.Settings.Instruction, // Instruction
        'messages': [
          {'role': 'user', 'content': "Keywords: $keywords, Context: $context"}
        ],
      }),
    );

    // Verify If Its Valid
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'][0]['text'];
    } else {
      throw Exception('ERROR: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<String> ask_chatgpt(String keywords, String context) async {
    if (AIManager.Settings.ChatGPT.apiKey == null || AIManager.Settings.ChatGPT.apiKey == "") {
      return "ERROR: API Key cant be found. Please check the .env file.";
    }

    try {
      final response = await http.post(
        Uri.parse(AIManager.Settings.ChatGPT.url), // API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AIManager.Settings.ChatGPT.apiKey!}', // API Key
        },
        body: jsonEncode({
          'model': AIManager.Settings.ChatGPT.model, // Model
          'max_tokens': AIManager.Settings.MaxTokens, // Max Tokens
          'messages': [
            {'role': 'system', 'content': AIManager.Settings.Instruction},
            {'role': 'user', 'content': "Keywords: $keywords, Context: $context"}
          ],
        }),
      );

      // Verify If Its Valid
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "CHATGPT_API_ERROR: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<String> ask_groq(String keywords, String context) async {
    if (AIManager.Settings.Groq.apiKey == null || AIManager.Settings.Groq.apiKey == "") {
      return "ERROR: API Key cant be found. Please check the .env file.";
    }

    try {
      final response = await http.post(
        Uri.parse(AIManager.Settings.Groq.url), // API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AIManager.Settings.Groq.apiKey!}', // API Key
        },
        body: jsonEncode({
          'model': AIManager.Settings.Groq.model, // Model
          'max_tokens': AIManager.Settings.MaxTokens, // Max Tokens
          'messages': [
            {'role': 'system', 'content': AIManager.Settings.Instruction},
            {'role': 'user', 'content': "Keywords: $keywords, Context: $context"}
          ],
        }),
      );

      // Verify If Its Valid
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "GROQ_API_ERROR: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}