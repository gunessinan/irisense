enum LlmDownloadStatus {
  idle,
  downloading,
  completed,
  error,
}

class LlmDownloadState {
  final LlmDownloadStatus status;
  final double progress;       // 0.0 - 1.0
  final String? errorMessage;

  const LlmDownloadState({
    this.status = LlmDownloadStatus.idle,
    this.progress = 0.0,
    this.errorMessage,
  });

  bool get isDownloading => status == LlmDownloadStatus.downloading;
  bool get isCompleted => status == LlmDownloadStatus.completed;
  bool get hasError => status == LlmDownloadStatus.error;
  bool get canDownload => status == LlmDownloadStatus.idle || status == LlmDownloadStatus.error;

  String get progressPercent => '${(progress * 100).toStringAsFixed(0)}%';

  LlmDownloadState copyWith({
    LlmDownloadStatus? status,
    double? progress,
    String? errorMessage,
  }) {
    return LlmDownloadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}