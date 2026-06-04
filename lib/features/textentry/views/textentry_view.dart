import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// App
import 'package:irisense/app/app_viewmodel.dart';
// Core
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/services/tracking_service.dart';
import 'package:irisense/core/services/user_data_manager.dart';
// Text Entry
import '../view_models/word_filter_viewmodel.dart';
import '../view_models/textentry_viewmodel.dart';
import '../view_models/keyboard_viewmodel.dart';
import '../view_models/text_state_viewmodel.dart';
import '../view_models/mic_viewmodel.dart';
import '../widgets/keypad_button.dart';
import '../widgets/top_button.dart';
import '../widgets/combination_box.dart';
import '../widgets/llm_box.dart';
import '../widgets/context_box.dart';

class TextEntryPage extends StatefulWidget {
  const TextEntryPage({super.key});

  @override
  State<TextEntryPage> createState() => _TextEntryPageState();
}

class _TextEntryPageState extends State<TextEntryPage>
    with AutomaticKeepAliveClientMixin {
  late TextEntryViewModel _viewModel;
  String? _lastLanguage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final appViewModel = Provider.of<AppViewModel>(context, listen: false);
    final userDataManager = Provider.of<UserDataManager>(
      context,
      listen: false,
    );
    _viewModel = TextEntryViewModel(
      soundService: appViewModel.soundService,
      userDataManager: userDataManager,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userDataManager = Provider.of<UserDataManager>(context);
    if (_lastLanguage != userDataManager.language) {
      _lastLanguage = userDataManager.language;
      _viewModel.initVM();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tracking = Provider.of<TrackingService>(context, listen: false);
    tracking.setActionForPage(1, _viewModel.actionTriggered);
    tracking.setHandlesDown(1, true);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<KeyboardViewModel>.value(
          value: _viewModel.keyboard,
        ),
        ChangeNotifierProvider<TextStateViewModel>.value(
          value: _viewModel.textState,
        ),
        ChangeNotifierProvider<MicViewModel>.value(value: _viewModel.mic),
        ChangeNotifierProvider<WordFilterViewModel>.value(
          value: _viewModel.wordFilter,
        ),
      ],
      child: _TextEntryLayout(viewModel: _viewModel),
    );
  }
}

class _TextEntryLayout extends StatefulWidget {
  final TextEntryViewModel viewModel;

  const _TextEntryLayout({required this.viewModel});

  @override
  State<_TextEntryLayout> createState() => _TextEntryLayoutState();
}

class _TextEntryLayoutState extends State<_TextEntryLayout> {
  bool _showContext = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Üst: Text Box + LLM/Context
          Expanded(
            flex: 40,
            child: Row(
              children: [
                const Expanded(child: CombinationBox()),
                const SizedBox(width: 10),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _showContext
                              ? ContextBox(
                                  key: const ValueKey('ctx'),
                                  onMicTap: widget.viewModel.micButton_onTap,
                                )
                              : const LLMBox(key: ValueKey('llm')),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _showContext = !_showContext),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _showContext
                                  ? AppColors.limeAccent.withValues(alpha: 0.25)
                                  : AppColors.darkElevated,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _showContext
                                    ? AppColors.limeAccent.withValues(
                                        alpha: 0.7,
                                      )
                                    : AppColors.accentGray.withValues(
                                        alpha: 0.5,
                                      ),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              _showContext
                                  ? Icons.psychology_outlined
                                  : Icons.sync,
                              color: _showContext
                                  ? AppColors.limeAccent
                                  : AppColors.textMuted,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Alt: Keypad + Aksiyon butonları
          Expanded(
            flex: 60,
            child: Row(
              children: [
                // Sol keypad
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: KeypadButton(
                          num: 0,
                          onTap: () => widget.viewModel.keypadButton_onTap(0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: KeypadButton(
                          num: 2,
                          onTap: () => widget.viewModel.keypadButton_onTap(2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Orta: Delete + Switch
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TopButton(
                          isSwitch: false,
                          onTap: () => widget.viewModel.topButton_onTap(false),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TopButton(
                          isSwitch: true,
                          onTap: () => widget.viewModel.topButton_onTap(true),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Sağ keypad
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: KeypadButton(
                          num: 1,
                          onTap: () => widget.viewModel.keypadButton_onTap(1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: KeypadButton(
                          num: 3,
                          onTap: () => widget.viewModel.keypadButton_onTap(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
