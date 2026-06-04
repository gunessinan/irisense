import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/models/user_model.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/core/services/messaging_service.dart';
import 'package:irisense/core/services/tracking_service.dart';
import 'package:irisense/l10n/app_localizations.dart';
import '../view_models/gaze_messaging_viewmodel.dart';
import 'contact_picker_page.dart';
import 'gaze_chat_page.dart';

const List<String> _gazeTypes = [
  'Left Up', 'Blink', 'Right Up', 'Left', 'Down', 'Right',
];

final List<Widget> _slotIcons = [
  GazeIcons.leftup,
  GazeIcons.closed,
  GazeIcons.rightup,
  GazeIcons.left,
  GazeIcons.down,
  GazeIcons.right,
];

class GazeMessagingPage extends StatefulWidget {
  const GazeMessagingPage({super.key});

  @override
  State<GazeMessagingPage> createState() => _GazeMessagingPageState();
}

class _GazeMessagingPageState extends State<GazeMessagingPage>
    with AutomaticKeepAliveClientMixin {
  late GazeMessagingViewModel _viewmodel;

  @override
  bool get wantKeepAlive => true;

  bool _isNavigating = false;
  bool _gazeActive   = true;

  @override
  void initState() {
    super.initState();
    _viewmodel = GazeMessagingViewModel();
    final auth      = context.read<AuthService>();
    final messaging = context.read<MessagingService>();
    if (auth.isLoggedIn && auth.currentUser != null) {
      _viewmodel.loadSlots(auth.currentUser!.uid, messaging);
    }
  }

  @override
  void dispose() {
    _viewmodel.dispose();
    super.dispose();
  }

  void _onGazeTriggered(String gazeType, AuthService auth, MessagingService messaging) {
    final index = _gazeTypes.indexOf(gazeType);
    if (index == -1) return;
    if (_viewmodel.hasContact(index)) {
      _openChat(index, auth);
    } else {
      _pickContactForSlot(index, auth, messaging);
    }
  }

  Future<void> _openChat(int slot, AuthService auth) async {
    if (_isNavigating) return;
    _isNavigating = true;
    setState(() => _gazeActive = false);
    final contact   = _viewmodel.getContact(slot)!;
    final myUid     = auth.currentUser!.uid;
    final myName    = auth.currentUser!.fullName;
    final convId    = MessagingService.conversationId(myUid, contact['uid']!);
    final tracking  = context.read<TrackingService>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TrackingService>.value(
          value: tracking,
          child: GazeChatPage(
            conversationId: convId,
            otherUid:  contact['uid']!,
            otherName: contact['name']!,
            myUid:  myUid,
            myName: myName,
          ),
        ),
      ),
    );
    _isNavigating = false;
    if (mounted) setState(() => _gazeActive = true);
  }

  Future<void> _pickContactForSlot(int slot, AuthService auth, MessagingService messaging) async {
    if (_isNavigating) return;
    _isNavigating = true;
    setState(() => _gazeActive = false);
    final selectedUser = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (_) => const ContactPickerPage()),
    );
    if (selectedUser != null && mounted) {
      await _viewmodel.setSlot(
        slot,
        auth.currentUser!.uid,
        selectedUser.uid,
        selectedUser.fullName,
        messaging,
      );
    }
    _isNavigating = false;
    if (mounted) setState(() => _gazeActive = true);
  }

  Future<void> _confirmRemoveSlot(int slot, AuthService auth, MessagingService messaging) async {
    final l10n      = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title:   Text(l10n.slotRemoveConfirmTitle,
            style: const TextStyle(color: Colors.white)),
        content: Text(l10n.slotRemoveConfirmBody,
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.slotRemoveConfirmNo,
                style: TextStyle(color: AppColors.limeAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.slotRemoveConfirmYes,
                style: TextStyle(color: AppColors.errorColor)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _viewmodel.clearSlot(slot, auth.currentUser!.uid, messaging);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final auth      = context.watch<AuthService>();
    final messaging = context.watch<MessagingService>();
    final tracking  = context.watch<TrackingService>();

    if (_gazeActive) {
      tracking.setActionForPage(3, (g) => _onGazeTriggered(g, auth, messaging));
      tracking.setHandlesUp(3, true);
      tracking.setHandlesDown(3, true);
    }

    return AnimatedBuilder(
      animation: _viewmodel,
      builder: (context, _) {
        final divider = AppColors.accentGray.withValues(alpha: 0.18);

        return Column(
          children: [
            // --- Üst sıra: 0 · 1 · 2 ---
            Expanded(
              child: Row(
                children: [
                  _ContactSlot(
                    slot: 0, vm: _viewmodel,
                    onTap:    () => _viewmodel.hasContact(0)
                        ? _openChat(0, auth)
                        : _pickContactForSlot(0, auth, messaging),
                    onRemove: _viewmodel.hasContact(0)
                        ? () => _confirmRemoveSlot(0, auth, messaging) : null,
                  ),
                  _VDivider(color: divider),
                  _ContactSlot(
                    slot: 1, vm: _viewmodel,
                    onTap:    () => _viewmodel.hasContact(1)
                        ? _openChat(1, auth)
                        : _pickContactForSlot(1, auth, messaging),
                    onRemove: _viewmodel.hasContact(1)
                        ? () => _confirmRemoveSlot(1, auth, messaging) : null,
                  ),
                  _VDivider(color: divider),
                  _ContactSlot(
                    slot: 2, vm: _viewmodel,
                    onTap:    () => _viewmodel.hasContact(2)
                        ? _openChat(2, auth)
                        : _pickContactForSlot(2, auth, messaging),
                    onRemove: _viewmodel.hasContact(2)
                        ? () => _confirmRemoveSlot(2, auth, messaging) : null,
                  ),
                ],
              ),
            ),
            _HDivider(color: divider),
            // --- Alt sıra: 3 · 4 · 5 ---
            Expanded(
              child: Row(
                children: [
                  _ContactSlot(
                    slot: 3, vm: _viewmodel,
                    onTap:    () => _viewmodel.hasContact(3)
                        ? _openChat(3, auth)
                        : _pickContactForSlot(3, auth, messaging),
                    onRemove: _viewmodel.hasContact(3)
                        ? () => _confirmRemoveSlot(3, auth, messaging) : null,
                  ),
                  _VDivider(color: divider),
                  _ContactSlot(
                    slot: 4, vm: _viewmodel,
                    onTap:    () => _viewmodel.hasContact(4)
                        ? _openChat(4, auth)
                        : _pickContactForSlot(4, auth, messaging),
                    onRemove: _viewmodel.hasContact(4)
                        ? () => _confirmRemoveSlot(4, auth, messaging) : null,
                  ),
                  _VDivider(color: divider),
                  _ContactSlot(
                    slot: 5, vm: _viewmodel,
                    onTap:    () => _viewmodel.hasContact(5)
                        ? _openChat(5, auth)
                        : _pickContactForSlot(5, auth, messaging),
                    onRemove: _viewmodel.hasContact(5)
                        ? () => _confirmRemoveSlot(5, auth, messaging) : null,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Slot widget ──────────────────────────────────────────────────────────────

class _ContactSlot extends StatelessWidget {
  final int slot;
  final GazeMessagingViewModel vm;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _ContactSlot({
    required this.slot,
    required this.vm,
    required this.onTap,
    this.onRemove,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final contact    = vm.getContact(slot);
    final hasContact = contact != null;
    final bool isBottom = const {3, 4, 5}.contains(slot);
    final bool isLeft   = const {0, 3}.contains(slot);
    final bool isRight  = const {2, 5}.contains(slot);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Gaze ikonu — gaze yönüyle uyumlu köşe
              Positioned(
                top:    isBottom ? null : 32,
                bottom: isBottom ? 14   : null,
                left:   isLeft  ? 14   : (isRight ? null : 0),
                right:  isRight ? 14   : (isLeft  ? null : 0),
                child: isLeft || isRight
                    ? _slotIcons[slot]
                    : Center(child: _slotIcons[slot]),
              ),

              // Merkez içerik
              Center(
                child: hasContact
                    ? _buildContact(contact)
                    : _buildEmpty(),
              ),

              // Sil butonu — kişi varsa sağ üstte
              if (hasContact && onRemove != null)
                Positioned(
                  top: 10, right: 10,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.errorColor.withValues(alpha: 0.45),
                          width: 1,
                        ),
                      ),
                      child: Icon(Icons.close,
                          color: AppColors.errorColor, size: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContact(Map<String, String> contact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.limeAccent,
          child: Text(
            _initials(contact['name']!),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            contact['name']!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Icon(
      Icons.add_circle_outline,
      color: AppColors.textDisabled,
      size: 38,
    );
  }
}

// ─── Ayraç widget'ları ────────────────────────────────────────────────────────

class _VDivider extends StatelessWidget {
  final Color color;
  const _VDivider({required this.color});
  @override
  Widget build(BuildContext context) => Container(width: 1, color: color);
}

class _HDivider extends StatelessWidget {
  final Color color;
  const _HDivider({required this.color});
  @override
  Widget build(BuildContext context) => Container(height: 1, color: color);
}
