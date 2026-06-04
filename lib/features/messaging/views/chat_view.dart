import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/models/message_model.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/core/services/messaging_service.dart';
import 'package:irisense/l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String otherUid;
  final String otherName;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.otherUid,
    required this.otherName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _sending = false;
  late final Stream<List<MessageModel>> _messagesStream;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthService>();
    final messaging = context.read<MessagingService>();
    // Stream'i bir kez oluştur — rebuild'de yeniden bağlanmasın
    _messagesStream = messaging.messagesStream(widget.conversationId);
    if (auth.currentUser != null) {
      messaging.markAsRead(widget.conversationId, auth.currentUser!.uid);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage(
      String myUid, String myName, MessagingService messaging) async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    _messageController.clear();

    await messaging.sendMessage(
      fromUid: myUid,
      fromName: myName,
      toUid: widget.otherUid,
      toName: widget.otherName,
      text: text,
    );

    _scrollToBottom();
    if (mounted) setState(() => _sending = false);
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Widget _buildMessageBubble(MessageModel msg, String myUid) {
    final isMe = msg.senderId == myUid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.limeAccent.withAlpha(51)
              : AppColors.darkSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: Border.all(
            color: isMe
                ? AppColors.limeAccent.withAlpha(77)
                : Colors.white10,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg.createdAt),
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context, listen: false);
    final messaging = Provider.of<MessagingService>(context, listen: false);
    final myUid = auth.currentUser?.uid ?? '';
    final myName = auth.currentUser?.fullName ?? '';
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              height: 64,
              color: AppColors.darkSurface,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.limeAccent,
                    child: Text(
                      _initials(widget.otherName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.otherName,
                      style: AppTextStyles.interBold18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Messages
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: StreamBuilder<List<MessageModel>>(
                stream: _messagesStream,
                builder: (ctx, snap) {
                  // Sadece ilk açılışta (henüz data yok) loading göster
                  if (!snap.hasData &&
                      snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: AppColors.limeAccent),
                    );
                  }
                  final messages = snap.data ?? [];
                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        widget.otherName,
                        style: const TextStyle(
                            color: Colors.white24, fontSize: 14),
                      ),
                    );
                  }
                  _scrollToBottom();
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (_, i) =>
                        _buildMessageBubble(messages[i], myUid),
                  );
                },
              ),
            ),
          ),

          // Input area — klavye yüksekliğini manuel hesapla
          AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Container(
              color: AppColors.darkSurface,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white),
                      minLines: 1,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: l10n.typeMessage,
                        hintStyle:
                            const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: AppColors.darkBackground,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              WidgetDetails.borderRadius),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _sending
                      ? SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                              color: AppColors.limeAccent,
                              strokeWidth: 2),
                        )
                      : IconButton(
                          icon:
                              Icon(Icons.send, color: AppColors.limeAccent),
                          onPressed: () =>
                              _sendMessage(myUid, myName, messaging),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
