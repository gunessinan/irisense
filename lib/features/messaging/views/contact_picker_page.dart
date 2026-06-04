import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/models/user_model.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/core/services/messaging_service.dart';
import 'package:irisense/l10n/app_localizations.dart';

class ContactPickerPage extends StatefulWidget {
  const ContactPickerPage({super.key});

  @override
  State<ContactPickerPage> createState() => _ContactPickerPageState();
}

class _ContactPickerPageState extends State<ContactPickerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    _tabController = TabController(length: 2, vsync: this);
    _loadContacts();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      setState(() { _all = withPhone; _filtered = withPhone; _loadingContacts = false; });
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
    final messaging = context.read<MessagingService>();
    final l10n = AppLocalizations.of(context)!;
    for (final phone in contact.phones) {
      final user = await messaging.findUserByPhone(phone.number);
      if (user != null) {
        if (mounted) Navigator.pop(context, user);
        return;
      }
    }
    if (mounted) {
      setState(() { _checkingId = null; _contactError = l10n.userNotRegistered; });
    }
  }

  // ── Username logic ──

  Future<void> _searchByUsername(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _usernameResults = []);
      return;
    }
    setState(() => _searchingUsername = true);
    final messaging = context.read<MessagingService>();
    final myUid = context.read<AuthService>().currentUser?.uid ?? '';
    final results = await messaging.searchUsersByUsername(q, excludeUid: myUid);
    if (mounted) setState(() { _usernameResults = results; _searchingUsername = false; });
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        title: Text(l10n.newMessage, style: AppTextStyles.interBold18),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.limeAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(text: l10n.tabContacts),
            Tab(text: l10n.tabUsername),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
            _ContactsTab(
              all: _all,
              filtered: _filtered,
              loading: _loadingContacts,
              permissionDenied: _contactPermissionDenied,
              checkingId: _checkingId,
              errorMessage: _contactError,
              controller: _contactSearch,
              onSearch: _filterContacts,
              onSelect: _selectContact,
              isLandscape: isLandscape,
              l10n: l10n,
            ),
            _UsernameTab(
              results: _usernameResults,
              searching: _searchingUsername,
              controller: _usernameSearch,
              onSearch: _searchByUsername,
              onSelect: (user) => Navigator.pop(context, user),
              isLandscape: isLandscape,
              l10n: l10n,
            ),
          ],
        ),
    );
  }
}

// ── Contacts Tab ──────────────────────────────────────────────────────────────

class _ContactsTab extends StatelessWidget {
  final List<Contact>? all;
  final List<Contact> filtered;
  final bool loading;
  final bool permissionDenied;
  final String? checkingId;
  final String? errorMessage;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final Future<void> Function(Contact) onSelect;
  final bool isLandscape;
  final AppLocalizations l10n;

  const _ContactsTab({
    required this.all,
    required this.filtered,
    required this.loading,
    required this.permissionDenied,
    required this.checkingId,
    required this.errorMessage,
    required this.controller,
    required this.onSearch,
    required this.onSelect,
    required this.isLandscape,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchField(
          controller: controller,
          hint: l10n.searchUsers,
          icon: Icons.search,
          onChanged: onSearch,
          isLandscape: isLandscape,
        ),
        if (errorMessage != null)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isLandscape ? 24 : 16, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: AppColors.warningColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(errorMessage!,
                      style: TextStyle(
                          color: AppColors.warningColor, fontSize: 13)),
                ),
              ],
            ),
          ),
        Expanded(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.limeAccent))
              : (permissionDenied || filtered.isEmpty)
                  ? Center(
                      child: Text(l10n.noUsersFound,
                          style: const TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: isLandscape ? 8 : 0,
                        right: isLandscape ? 8 : 0,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final isChecking = checkingId == c.id;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accentGray,
                            child: Text(
                              c.displayName.isNotEmpty
                                  ? c.displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(c.displayName,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            c.phones.isNotEmpty ? c.phones.first.number : '',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                          trailing: isChecking
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.limeAccent))
                              : null,
                          onTap: isChecking ? null : () => onSelect(c),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

// ── Username Tab ──────────────────────────────────────────────────────────────

class _UsernameTab extends StatelessWidget {
  final List<UserModel> results;
  final bool searching;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final ValueChanged<UserModel> onSelect;
  final bool isLandscape;
  final AppLocalizations l10n;

  const _UsernameTab({
    required this.results,
    required this.searching,
    required this.controller,
    required this.onSearch,
    required this.onSelect,
    required this.isLandscape,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchField(
          controller: controller,
          hint: l10n.profileUsername,
          icon: Icons.alternate_email,
          onChanged: onSearch,
          isLandscape: isLandscape,
        ),
        Expanded(
          child: searching
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.limeAccent))
              : results.isEmpty
                  ? Center(
                      child: Text(
                        controller.text.isEmpty ? '' : l10n.noUsersFound,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: isLandscape ? 8 : 0,
                        right: isLandscape ? 8 : 0,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      itemCount: results.length,
                      itemBuilder: (_, i) {
                        final user = results[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.limeAccent,
                            child: Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(user.fullName,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text('@${user.username}',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 13)),
                          onTap: () => onSelect(user),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

// ── Shared Search Field ───────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool isLandscape;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onChanged,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          isLandscape ? 24 : 16, 12, isLandscape ? 24 : 16, 6),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white54),
          filled: true,
          fillColor: AppColors.darkSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WidgetDetails.borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
