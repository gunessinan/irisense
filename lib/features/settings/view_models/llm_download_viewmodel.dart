import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/llm_download_state.dart';

class LlmDownloadViewModel extends ChangeNotifier {
  LlmDownloadState _state = const LlmDownloadState();
  LlmDownloadState get state => _state;

  CancelToken? _cancelToken;

  static const String modelFileName = 'gemma3-1b-it-int4.task';
  static const String modelUrl =
      'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task?download=true';

  static Future<bool> isModelInstalled() async {
    final path = await _getModelPath();
    return File(path).exists();
  }

  static Future<String> _getModelPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$modelFileName';
  }

  Future<void> startDownload() async {
    if (!_state.canDownload) return;

    _cancelToken = CancelToken();
    _setState(_state.copyWith(
      status: LlmDownloadStatus.downloading,
      progress: 0.0,
      errorMessage: null,
    ));

    try {
      final savePath = await _getModelPath();
      final dio = Dio();

      // .env'den token oku
      final token = dotenv.env['HFACE_API_KEY'] ?? '';
      if (token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      await dio.download(
        modelUrl,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _setState(_state.copyWith(
              status: LlmDownloadStatus.downloading,
              progress: received / total,
            ));
          }
        },
      );

      _setState(_state.copyWith(
        status: LlmDownloadStatus.completed,
        progress: 1.0,
      ));
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        await _deletePartialFile();
        _setState(const LlmDownloadState());
      } else {
        _setState(_state.copyWith(
          status: LlmDownloadStatus.error,
          errorMessage: e.message ?? 'Bilinmeyen bir hata oluştu.',
        ));
      }
    } catch (e) {
      _setState(_state.copyWith(
        status: LlmDownloadStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void cancelDownload() {
    _cancelToken?.cancel('Kullanıcı tarafından iptal edildi.');
  }

  Future<void> _deletePartialFile() async {
    try {
      final path = await _getModelPath();
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  void _setState(LlmDownloadState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}