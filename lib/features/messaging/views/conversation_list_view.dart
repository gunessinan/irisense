import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/models/conversation_model.dart';
import 'package:irisense/core/models/user_model.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/core/services/messaging_service.dart';
import 'package:irisense/l10n/app_localizations.dart';
import 'chat_view.dart';
import 'contact_picker_page.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({super.key});

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  bool _searchingUsers = false;
  Stream<List<ConversationModel>>? _conversationsStream;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthService>();
    final messaging = context.read<MessagingService>();
    if (auth.isLoggedIn && auth.currentUser != null) {
      _conversationsStream = messaging.conversationsStream(auth.currentUser!.uid);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query, MessagingService messaging, String myUid) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _searchingUsers = true);
    final results = await messaging.searchUsersByUsername(query, excludeUid: myUid);
    if (mounted) {
      setState(() {
        _searchResults = results;
        _searchingUsers = false;
      });
    }
  }

  void _openChatWithConversation(ConversationModel conv, String myUid) {
    final otherUid = conv.otherUid(myUid);
    final otherName = conv.otherName(myUid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          conversationId: conv.id,
          otherUid: otherUid,
          otherName: otherName,
        ),
      ),
    );
  }

  void _openChatWithUser(UserModel user, String myUid, String myName) {
    final convId = MessagingService.conversationId(myUid, user.uid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          conversationId: convId,
          otherUid: user.uid,
          otherName: user.fullName,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Dün';
    } else {
      return '${dt.day}/${dt.month}';
    }
  }

  Widget _buildConvTile(ConversationModel conv, String myUid) {
    final otherName = conv.otherName(myUid);
    final unread = conv.unreadFor(myUid);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.limeAccent,
        child: Text(
          _initials(otherName),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      title: Text(
        otherName,
        style: AppTextStyles.interBold18.copyWith(fontSize: 15),
      ),
      subtitle: Text(
        conv.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.errorColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                unread > 99 ? '99+' : '$unread',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            _formatTime(conv.lastMessageAt),
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
      onTap: () => _openChatWithConversation(conv, myUid),
    );
  }


  Future<void> _pickFromContacts(
      AuthService auth, MessagingService messaging) async {
    final selectedUser = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (_) => const ContactPickerPage()),
    );

    if (selectedUser != null && mounted) {
      _openChatWithUser(
        selectedUser,
        auth.currentUser!.uid,
        auth.currentUser!.fullName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context);
    final messaging = Provider.of<MessagingService>(context);

    if (!auth.isLoggedIn) {
      return Container(
        color: AppColors.darkBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message_outlined,
                  color: AppColors.limeAccent, size: 56),
              const SizedBox(height: 16),
              Text(
                l10n.messages,
                style: AppTextStyles.interBold18,
              ),
            ],
          ),
        ),
      );
    }

    final myUid = auth.currentUser!.uid;
    final myName = auth.currentUser!.fullName;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.limeAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _pickFromContacts(auth, messaging),
      ),
      body: Column(
        children: [
          // Header
          Container(
            height: 64,
            color: AppColors.darkSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _searching
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: l10n.searchUsers,
                            hintStyle: const TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                          onChanged: (q) => _runSearch(q, messaging, myUid),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () {
                          setState(() {
                            _searching = false;
                            _searchController.clear();
                            _searchResults = [];
                          });
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.message, color: AppColors.limeAccent, size: 24),
                      const SizedBox(width: 12),
                      Text(l10n.messages, style: AppTextStyles.interBold18),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white54),
                        onPressed: () => setState(() => _searching = true),
                      ),
                    ],
                  ),
          ),

          // Search results or conversation list
          Expanded(
            child: _searching
                ? (_searchingUsers
                    ? Center(
                        child: CircularProgressIndicator(
                            color: AppColors.limeAccent))
                    : _searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (_, i) {
                              final user = _searchResults[i];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.limeAccent,
                                  child: Text(
                                    _initials(user.fullName),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  user.fullName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  user.username,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                                onTap: () => _openChatWithUser(user, myUid, myName),
                              );
                            },
                          )
                        : _searchController.text.isNotEmpty
                            ? Center(
                                child: Text(
                                  l10n.noUsersFound,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              )
                            : const SizedBox.shrink())
                : StreamBuilder<List<ConversationModel>>(
                    stream: _conversationsStream,
                    builder: (ctx, snap) {
                      if (!snap.hasData &&
                          snap.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: AppColors.limeAccent),
                        );
                      }
                      final conversations = snap.data ?? [];
                      if (conversations.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.chat_bubble_outline,
                                  color: Colors.white24, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noConversations,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: conversations.length,
                        separatorBuilder: (ctx2, idx) => const Divider(
                          height: 1,
                          color: Colors.white10,
                        ),
                        itemBuilder: (_, i) =>
                            _buildConvTile(conversations[i], myUid),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Rehber / Kullanıcı Adı Seçici ───────────────────────────────────────────

class _ContactPickerSheet extends StatefulWidget {
  final MessagingService messaging;
  final AppLocalizations l10n;
  final String myUid;

  const _ContactPickerSheet({
    required this.messaging,
    required this.l10n,
    required this.myUid,
  });

  @override
  State<_ContactPickerSheet> createState() => _ContactPickerSheetState();
}

class _ContactPickerSheetState extends State<_ContactPickerSheet> {
  int _tab = 0; // 0 = contacts, 1 = username

  // ── Contacts tab ──
  List<Contact>? _all;
  List<Contact> _filtered = [];
  final TextEditingController _contactSearch = TextEditingController();
  bool _loadingContacts = true;
  bool _contactPermissionDenied = false;
  String? _checkingId;
  String? _contactError;

  // ── Username tab ──
  final TextEditingController _usernameSearch = TextEditingController();
  List<UserModel> _usernameResults = [];
  bool _searchingUsername = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _contactSearch.dispose();
    _usernameSearch.dispose();
    super.dispose();
  }

  // ── Contacts logic ──

  Future<void> _loadContacts() async {
    final granted = await FlutterContacts.requestPermission(readonly: true);
    if (!mounted) return;
    if (!granted) {
      setState(() { _loadingContacts = false; _contactPermissionDenied = true; });
      return;
    }
    final contacts = await FlutterContacts.getContacts(withProperties: true);
    final withPhone = contacts.where((c) => c.phones.isNotEmpty).toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
    if (mounted) {
      setState(() {
        _all = withPhone;
        _filtered = withPhone;
        _loadingContacts = false;
      });
    }
  }

  void _filterContacts(String q) {
    if (_all == null) return;
    final lower = q.toLowerCase();
    setState(() {
      _contactError = null;
      _filtered = q.isEmpty
          ? _all!
          : _all!.where((c) => c.displayName.toLowerCase().contains(lower)).toList();
    });
  }

  Future<void> _selectContact(Contact contact) async {
    setState(() { _checkingId = contact.id; _contactError = null; });
    for (final phone in contact.phones) {
      final user = await widget.messaging.findUserByPhone(phone.number);
      if (user != null) {
        if (mounted) Navigator.pop(context, user);
        return;
      }
    }
    if (mounted) {
      setState(() { _checkingId = null; _contactError = widget.l10n.userNotRegistered; });
    }
  }

  // ── Username logic ──

  Future<void> _searchByUsername(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _usernameResults = []);
      return;
    }
    setState(() => _searchingUsername = true);
    final results = await widget.messaging.searchUsersByUsername(q, excludeUid: widget.myUid);
    if (mounted) setState(() { _usernameResults = results; _searchingUsername = false; });
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          // Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(widget.l10n.newMessage, style: AppTextStyles.interBold18),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Sekme seçici
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab(widget.l10n.tabContacts, 0),
                const SizedBox(width: 8),
                _buildTab(widget.l10n.tabUsername, 1),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // İçerik
          Expanded(child: _tab == 0 ? _buildContactsTab() : _buildUsernameTab()),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.limeAccent : AppColors.darkBackground,
            borderRadius: BorderRadius.circular(WidgetDetails.borderRadius),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white54,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsTab() {
    return Column(
      children: [
        if (_contactError != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.warningColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_contactError!,
                      style: TextStyle(color: AppColors.warningColor, fontSize: 13)),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: _contactSearch,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: widget.l10n.searchUsers,
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: AppColors.darkBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(WidgetDetails.borderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: _filterContacts,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: _loadingContacts
              ? Center(child: CircularProgressIndicator(color: AppColors.limeAccent))
              : _contactPermissionDenied
                  ? Center(
                      child: Text(widget.l10n.noUsersFound,
                          style: const TextStyle(color: Colors.white54)))
                  : _filtered.isEmpty
                      ? Center(
                          child: Text(widget.l10n.noUsersFound,
                              style: const TextStyle(color: Colors.white54)))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final c = _filtered[i];
                            final isChecking = _checkingId == c.id;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.accentGray,
                                child: Text(
                                  c.displayName.isNotEmpty ? c.displayName[0].toUpperCase() : '?',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(c.displayName,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(c.phones.first.number,
                                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              trailing: isChecking
                                  ? SizedBox(
                                      width: 20, height: 20,
                                      child: CircularProgressIndicator(
                                          color: AppColors.limeAccent, strokeWidth: 2))
                                  : null,
                              onTap: isChecking ? null : () => _selectContact(c),
                            );
                          },
                        ),
        ),
      ],
    );
  }

  Widget _buildUsernameTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: _usernameSearch,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: widget.l10n.profileUsername,
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.alternate_email, color: Colors.white54),
              filled: true,
              fillColor: AppColors.darkBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(WidgetDetails.borderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: _searchByUsername,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: _searchingUsername
              ? Center(child: CircularProgressIndicator(color: AppColors.limeAccent))
              : _usernameResults.isEmpty
                  ? Center(
                      child: Text(
                        _usernameSearch.text.isEmpty ? '' : widget.l10n.noUsersFound,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _usernameResults.length,
                      itemBuilder: (_, i) {
                        final user = _usernameResults[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.limeAccent,
                            child: Text(
                              user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(user.fullName,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text('@${user.username}',
                              style: const TextStyle(color: Colors.white54, fontSize: 13)),
                          onTap: () => Navigator.pop(context, user),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
