import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irisense/app/app_viewmodel.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/models/message_model.dart';
import 'package:irisense/core/services/messaging_service.dart';
import 'package:irisense/core/services/tracking_service.dart';
import 'package:irisense/core/services/user_data_manager.dart';
import 'package:irisense/features/textentry/view_models/keyboard_viewmodel.dart';
import 'package:irisense/features/textentry/view_models/mic_viewmodel.dart';
import 'package:irisense/features/textentry/view_models/text_state_viewmodel.dart';
import 'package:irisense/features/textentry/view_models/textentry_viewmodel.dart';
import 'package:irisense/features/textentry/view_models/word_filter_viewmodel.dart';
import 'package:irisense/features/textentry/widgets/keypad_button.dart';
import 'package:irisense/features/textentry/widgets/top_button.dart';
import 'package:irisense/l10n/app_localizations.dart';

class GazeChatPage extends StatefulWidget {
  final String conversationId;
  final String otherUid;
  final String otherName;
  final String myUid;
  final String myName;

  const GazeChatPage({
    super.key,
    required this.conversationId,
    required this.otherUid,
    required this.otherName,
    required this.myUid,
    required this.myName,
  });

  @override
  State<GazeChatPage> createState() => _GazeChatPageState();
}

class _GazeChatPageState extends State<GazeChatPage> {
  late TextEntryViewModel _textViewModel;
  late Stream<List<MessageModel>> _messagesStream;
  bool _sending = false;
  bool _sendHovered = false;
  bool _backHovered = false;
  final ScrollController _scrollController = ScrollController();
  String? _lastLanguage;
  TrackingService? _trackingService;

  @override
  void initState() {
    super.initState();
    final appViewModel = context.read<AppViewModel>();
    final userDataManager = context.read<UserDataManager>();
    final messaging = context.read<MessagingService>();

    _textViewModel = TextEntryViewModel(
      soundService: appViewModel.soundService,
      userDataManager: userDataManager,
    );

    _messagesStream = messaging.messagesStream(widget.conversationId);
    messaging.markAsRead(widget.conversationId, widget.myUid);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _trackingService = context.read<TrackingService>();
      _trackingService!.setHandlesDown(3, true);
      _trackingService!.setHandlesUp(3, true);
      _trackingService!.setActionForPage(3, _onGaze);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userDataManager = context.read<UserDataManager>();
    if (_lastLanguage != userDataManager.language) {
      _lastLanguage = userDataManager.language;
      _textViewModel.initVM();
    }
  }

  @override
  void dispose() {
    _trackingService?.setHandlesDown(3, false);
    _trackingService?.setHandlesUp(3, false);
    _trackingService?.setActionForPage(3, (_) {});
    _textViewModel.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onGaze(String gazeType) {
    if (gazeType == 'Up') {
      if (_textViewModel.keyboard.wordMode) {
        setState(() => _sendHovered = true);
        _sendMessage();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _sendHovered = false);
        });
      } else {
        setState(() => _backHovered = true);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            setState(() => _backHovered = false);
            Navigator.of(context).pop();
          }
        });
      }
      return;
    }
    _textViewModel.actionTriggered(gazeType);
  }

  Future<void> _sendMessage() async {
    if (_sending) return;
    // Önce AI metnini, yoksa yazılan metni gönder
    final llm = _textViewModel.textState.llmText.trim();
    final raw = _textViewModel.textState.textBox.trim();
    final text = llm.isNotEmpty ? llm : raw;
    if (text.isEmpty) return;

    setState(() => _sending = true);
    final messaging = context.read<MessagingService>();
    await messaging.sendMessage(
      fromUid: widget.myUid,
      fromName: widget.myName,
      toUid: widget.otherUid,
      toName: widget.otherName,
      text: text,
    );
    _textViewModel.textState.clear();
    if (mounted) {
      setState(() => _sending = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1)
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<KeyboardViewModel>.value(
          value: _textViewModel.keyboard,
        ),
        ChangeNotifierProvider<TextStateViewModel>.value(
          value: _textViewModel.textState,
        ),
        ChangeNotifierProvider<MicViewModel>.value(value: _textViewModel.mic),
        ChangeNotifierProvider<WordFilterViewModel>.value(
          value: _textViewModel.wordFilter,
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────────
              _buildHeader(),
              const SizedBox(height: 8),
              // ── 3 sütun: Sol | Orta | Sağ ───────────────────────────────────
              Expanded(
                child: Row(
                  children: [
                    // Sol: TextCard (büyük üst) + Keypad 0 + 2
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(flex: 2, child: _buildTextCard()),
                          const SizedBox(height: 8),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Expanded(child: KeypadButton(num: 0, onTap: () => _textViewModel.keypadButton_onTap(0))),
                                const SizedBox(height: 8),
                                Expanded(child: KeypadButton(num: 2, onTap: () => _textViewModel.keypadButton_onTap(2))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Orta: Mesajlar + Delete/Switch alt
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Expanded(child: _buildMessages()),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Row(
                              children: [
                                Expanded(child: _buildDeleteOrSend()),
                                const SizedBox(width: 8),
                                Expanded(child: TopButton(isSwitch: true, onTap: () => _textViewModel.topButton_onTap(true))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Sağ: LLMCard (büyük üst) + Keypad 1 + 3
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(flex: 2, child: _buildLLMCard()),
                          const SizedBox(height: 8),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Expanded(child: KeypadButton(num: 1, onTap: () => _textViewModel.keypadButton_onTap(1))),
                                const SizedBox(height: 8),
                                Expanded(child: KeypadButton(num: 3, onTap: () => _textViewModel.keypadButton_onTap(3))),
                              ],
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
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      height: 52,
      color: AppColors.darkSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.limeAccent,
            child: Text(
              _initials(widget.otherName),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.otherName,
              style: AppTextStyles.interBold18.copyWith(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Gaze back indicator (Right Down gaze → go back)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _backHovered
                    ? AppColors.limeAccent
                    : AppColors.accentGray.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 20, height: 20, child: GazeIcons.up),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.backAction,
                    style: TextStyle(
                      color: _backHovered
                          ? AppColors.darkBackground
                          : Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mesajlar ────────────────────────────────────────────────────────────────

  Widget _buildMessages() {
    return StreamBuilder<List<MessageModel>>(
      stream: _messagesStream,
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.limeAccent),
          );
        }
        final messages = snap.data!;
        if (messages.isEmpty) {
          return Center(
            child: Text(
              widget.otherName,
              style: const TextStyle(color: Colors.white24, fontSize: 18),
            ),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: messages.length,
          itemBuilder: (_, i) => _buildBubble(messages[i]),
        );
      },
    );
  }

  Widget _buildBubble(MessageModel msg) {
    final isMe = msg.senderId == widget.myUid;
    final time =
        '${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.55,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? AppColors.limeAccent : AppColors.darkSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMe ? 14 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 14),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                msg.text,
                style: TextStyle(
                  color: isMe ? AppColors.darkBackground : Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              time,
              style: TextStyle(
                color: isMe
                    ? AppColors.darkBackground.withValues(alpha: 0.6)
                    : Colors.white38,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Text kartı ─────────────────────────────────────────────────────────────

  Widget _buildTextCard() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<TextStateViewModel>(
      builder: (_, textState, _) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            border: Border.all(
              color: AppColors.accentGray.withValues(alpha: 0.35),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.accentGray.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                child: Text(
                  l10n.textEntry,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    l10n.text(textState.textBox),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── LLM kartı ──────────────────────────────────────────────────────────────

  Widget _buildLLMCard() {
    final l10n = AppLocalizations.of(context)!;
    final userData = context.watch<UserDataManager>();
    final isModelNone = userData.generationModel == "None";

    return Consumer<TextStateViewModel>(
      builder: (_, textState, _) {
        final isLoading = textState.llmText == '...';
        final hasLLM = textState.llmText.isNotEmpty && !isLoading;
        final String displayText = isModelNone
            ? l10n.defaultLLM
            : (textState.llmText.isEmpty ? l10n.defaultText : textState.llmText);

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            border: Border.all(
              color: AppColors.limeAccent.withValues(alpha: 0.25),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.accentGray.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                child: Text(
                  'LLM Box',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.limeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: isLoading
                      ? Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                color: AppColors.limeAccent,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.aiThinking,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          displayText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                            color: hasLLM ? Colors.white : Colors.white30,
                            fontWeight: hasLLM ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Delete / Send butonu ────────────────────────────────────────────────────

  Widget _buildDeleteOrSend() {
    return Consumer<KeyboardViewModel>(
      builder: (_, keyboard, _) {
        final isSendMode = keyboard.wordMode;
        return GestureDetector(
          onTap: isSendMode
              ? _sendMessage
              : () => _textViewModel.topButton_onTap(false),
          child: SizedBox.expand(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isSendMode
                    ? (_sendHovered
                          ? AppColors.limeAccent
                          : AppColors.limeAccent.withValues(alpha: 0.85))
                    : AppColors.darkSurface,
                border: Border.all(
                  color: isSendMode
                      ? AppColors.limeAccent.withValues(alpha: 0.6)
                      : AppColors.accentGray.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: _sending && isSendMode
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GazeIcons.closed,
                          const SizedBox(width: 12),
                          Text(
                            isSendMode
                                ? AppLocalizations.of(context)!.sendAction
                                : AppLocalizations.of(context)!.deleteAction,
                            style: TextStyle(
                              color: isSendMode
                                  ? AppColors.darkBackground
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
