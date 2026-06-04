import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:irisense/core/services/AI/ai_manager.dart';
import 'package:path_provider/path_provider.dart';

class LocalLLM {
  static InferenceModel? _model;
  static bool _isInitialized = false;

  static const String _modelFileName = 'gemma3-1b-it-int4.task';

  static final String _systemPrompt = AIManager.Settings.Instruction;

  static Future<bool> isModelInstalled() async {
    final path = await _getModelPath();
    return File(path).exists();
  }

  static Future<String> _getModelPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$_modelFileName';
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;
    if (!await isModelInstalled()) return;

    try {
      final modelPath = await _getModelPath();

      await FlutterGemma.installModel(
        modelType: ModelType.gemmaIt,
      ).fromFile(modelPath).install();

      _model = await FlutterGemma.getActiveModel(
        maxTokens: 1024,
        preferredBackend: PreferredBackend.cpu,
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint('LocalLLM initialize error: $e');
    }
  }

  static Future<String> ask(String keywords, String context) async {
    if (!_isInitialized || _model == null) return '';

    try {
      final session = await _model!.createSession(
        temperature: 0.2,
        topK: 10,
      );

      final effectiveContext = context.trim().isEmpty 
        ? 'Express this as a natural sentence' 
        : context.trim();

      final fullPrompt = '$_systemPrompt\n\nKeywords: $keywords, Context: $effectiveContext';

      await session.addQueryChunk(
        Message(text: fullPrompt, isUser: true),
      );

      final response = await session.getResponse();
      await session.close();
      
      return _cleanResponse(response?.trim() ?? '');
    } catch (e) {
      debugPrint('LocalLLM ask error: $e');
      return '';
    }
  }

  static String _cleanResponse(String raw) {
    // "Output: ..." veya "Çıktı: ..." gibi prefix'leri kaldır
    String cleaned = raw
        .replaceAll(RegExp(r'^(Output|Çıktı|Cümle|Answer|Response)\s*:\s*', caseSensitive: false), '')
        .replaceAll(RegExp(r"^'|'$"), '')
        .replaceAll(RegExp(r'^"|"$'), '')
        .trim();

    final sentences = cleaned.split(RegExp(r'(?<=[.!?])\s+'));
    if (sentences.length > 1) {
      cleaned = sentences.first.trim();
    }

    return cleaned;
  }

  static Future<void> dispose() async {
    await _model?.close();
    _model = null;
    _isInitialized = false;
  }
}