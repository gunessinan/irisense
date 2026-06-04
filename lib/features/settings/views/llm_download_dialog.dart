import 'package:flutter/material.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:provider/provider.dart';
import '../models/llm_download_state.dart';
import '../view_models/llm_download_viewmodel.dart';

class LlmDownloadDialog extends StatelessWidget {
  const LlmDownloadDialog._();

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => LlmDownloadViewModel(),
        child: const LlmDownloadDialog._(),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LlmDownloadViewModel>(
      builder: (context, vm, _) {
        final state = vm.state;

        return PopScope(
          canPop: !state.isDownloading,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && state.isDownloading) vm.cancelDownload();
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: _buildTitle(state),
            // ✅ scrollable: true → taşma sorunu çözülür
            scrollable: true,
            content: _LlmDownloadContent(vm: vm, state: state),
            actions: _buildActions(context, vm, state),
          ),
        );
      },
    );
  }

  Widget _buildTitle(LlmDownloadState state) {
    final (icon, color) = switch (state.status) {
      LlmDownloadStatus.completed => (Icons.check_circle, AppColors.successColor),
      LlmDownloadStatus.error     => (Icons.error_outline, AppColors.errorColor),
      _                           => (Icons.download_rounded, AppColors.infoColor),
    };

    final title = switch (state.status) {
      LlmDownloadStatus.completed   => 'Model Hazır!',
      LlmDownloadStatus.error       => 'İndirme Başarısız',
      LlmDownloadStatus.downloading => 'İndiriliyor...',
      LlmDownloadStatus.idle        => 'Local LLM Kurulumu',
    };

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
      ],
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    LlmDownloadViewModel vm,
    LlmDownloadState state,
  ) {
    return switch (state.status) {
      LlmDownloadStatus.idle || LlmDownloadStatus.error => [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Vazgeç'),
        ),
        FilledButton.icon(
          onPressed: () => vm.startDownload(),
          icon: const Icon(Icons.download),
          label: Text(state.hasError ? 'Tekrar Dene' : 'İndir (~600MB)'),
        ),
      ],
      LlmDownloadStatus.downloading => [
        TextButton(
          onPressed: vm.cancelDownload,
          style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
          child: const Text('İptal Et'),
        ),
      ],
      LlmDownloadStatus.completed => [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Tamam'),
        ),
      ],
    };
  }
}

// Content ayrı StatefulWidget — token TextField için
class _LlmDownloadContent extends StatelessWidget {
  final LlmDownloadViewModel vm;
  final LlmDownloadState state;

  const _LlmDownloadContent({required this.vm, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusMessage(state: state),
          const SizedBox(height: 16),

          // Progress bar
          if (state.isDownloading || state.isCompleted) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: state.isDownloading ? state.progress : 1.0,
                minHeight: 10,
                backgroundColor: AppColors.darkElevated,
                valueColor: AlwaysStoppedAnimation(
                  state.isCompleted ? AppColors.successColor : AppColors.infoColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                state.isCompleted ? 'Tamamlandı' : state.progressPercent,
                style: TextStyle(
                  fontSize: 13,
                  color: state.isCompleted ? AppColors.successColor : AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          // Hata kutusu
          if (state.hasError && state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 120),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.4)),
              ),
              child: SingleChildScrollView(
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: AppColors.errorColor, fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final LlmDownloadState state;
  const _StatusMessage({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      LlmDownloadStatus.idle => const Text(
          'Local LLM modeli cihazınızda bulunamadı.\n\n'
          'İndirme yaklaşık 600MB veri kullanır, WiFi bağlantısı önerilir.',
        ),
      LlmDownloadStatus.downloading => const Text(
          'Model indiriliyor, lütfen bekleyin...\n'
          'Bu işlem internet hızınıza bağlı olarak birkaç dakika sürebilir.',
        ),
      LlmDownloadStatus.completed => const Text(
          'Model başarıyla indirildi! '
          'Artık Local LLM özelliğini çevrimdışı kullanabilirsiniz.',
        ),
      LlmDownloadStatus.error => const Text(
          'İndirme sırasında bir hata oluştu. '
          'İnternet bağlantınızı kontrol edip tekrar deneyin.',
        ),
    };
  }
}