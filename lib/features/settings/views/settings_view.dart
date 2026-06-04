import 'package:flutter/material.dart';
import 'package:irisense/features/settings/view_models/llm_download_viewmodel.dart';
import 'package:irisense/features/settings/views/llm_download_dialog.dart';
import 'package:provider/provider.dart';
// Core
import 'package:irisense/core/services/tracking_service.dart';
import 'package:irisense/core/services/user_data_manager.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/l10n/app_localizations.dart';
// Profile
import 'package:irisense/features/profile/views/profile_view.dart';
// Messaging
import 'package:irisense/features/messaging/views/conversation_list_view.dart';
// Settings
import '../view_models/settings_viewmodel.dart';
import '../models/options.dart';
import '../widgets/frame_panel.dart';
import '../widgets/input_log.dart';
import '../widgets/option_box.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab>
    with AutomaticKeepAliveClientMixin {
  late SettingsViewModel viewmodel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final trackingService = Provider.of<TrackingService>(
      context,
      listen: false,
    );
    viewmodel = SettingsViewModel(trackingService: trackingService);
  }

  @override
  void dispose() {
    viewmodel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userData = Provider.of<UserDataManager>(context);
    final l10n = AppLocalizations.of(context)!;

    final dwellMap = Options.getDwellMap(context);
    final genModelMap = Options.getGenModelMap(context);
    final debugMap = Options.getDebugMap(context);
    final langMap = Options.getLanguageMap();

    final trackingService = Provider.of<TrackingService>(context);
    trackingService.setActionForPage(0, (gazeType) {
      viewmodel.actionTriggered(gazeType);
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FramePanel(viewmodel: viewmodel),
                ),
                const SizedBox(width: 10.0),
                GazeInputLog(viewmodel: viewmodel),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: OptionBox(
                    title: l10n.slcTime,
                    options: dwellMap.values.toList(),
                    currentValue:
                        dwellMap[userData.dwellTime] ?? dwellMap["Standard"]!,
                    onChanged: (val) {
                      final key = dwellMap.entries
                          .firstWhere((e) => e.value == val)
                          .key;
                      userData.setDwellTime(key);
                      viewmodel.dwellTime_changed(key);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OptionBox(
                    title: l10n.language,
                    options: langMap.values.toList(),
                    currentValue: langMap[userData.language] ?? "English",
                    onChanged: (val) {
                      final code = langMap.entries
                          .firstWhere((e) => e.value == val)
                          .key;
                      userData.setLanguage(code);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: OptionBox(
                    title: l10n.genModel,
                    options: genModelMap.values.toList(),
                    currentValue:
                        genModelMap[userData.generationModel] ?? genModelMap["None"]!,
                    onChanged: (val) async {
                      final key = genModelMap.entries
                          .firstWhere((e) => e.value == val)
                          .key;
                      if (key == 'LocalLLM') {
                        final isInstalled =
                            await LlmDownloadViewModel.isModelInstalled();
                        if (!isInstalled && context.mounted) {
                          final downloaded = await LlmDownloadDialog.show(context);
                          if (!downloaded) return;
                        }
                      }
                      userData.setGenerationModel(key);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OptionBox(
                    title: l10n.debugMode,
                    options: debugMap.values.toList(),
                    currentValue:
                        debugMap[userData.debugMode] ?? debugMap["Disabled"]!,
                    onChanged: (val) {
                      final key = debugMap.entries
                          .firstWhere((e) => e.value == val)
                          .key;
                      userData.setDebugMode(key);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _ProfileButton(),

            _ChatButton(),
          ],

        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final l10n = AppLocalizations.of(context)!;
    final isLoggedIn = auth.isLoggedIn;

    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isLoggedIn
              ? AppColors.limeAccent.withValues(alpha: 0.12)
              : AppColors.darkElevated,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isLoggedIn
                ? AppColors.limeAccent.withValues(alpha: 0.5)
                : AppColors.accentGray.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isLoggedIn ? Icons.person : Icons.person_outline,
              color: isLoggedIn ? AppColors.limeAccent : Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileTitle,
                    style: AppTextStyles.interBold18.copyWith(
                      color: isLoggedIn ? AppColors.limeAccent : Colors.white,
                    ),
                  ),
                  if (isLoggedIn)
                    Text(
                      auth.currentUser!.fullName,
                      style: AppTextStyles.interMedium14.copyWith(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      l10n.profileGuestSubtitle,
                      style: AppTextStyles.interMedium14.copyWith(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isLoggedIn ? AppColors.limeAccent : Colors.white38,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final l10n = AppLocalizations.of(context)!;

    if (!auth.isLoggedIn || auth.currentUser!.role != 'user') {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ConversationListPage()),
            );
          },
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: AppColors.limeAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.limeAccent.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline,
                    color: AppColors.limeAccent, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.messages,
                    style: AppTextStyles.interBold18
                        .copyWith(color: AppColors.limeAccent),
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: AppColors.limeAccent, size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
