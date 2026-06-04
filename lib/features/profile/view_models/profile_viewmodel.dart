import 'package:flutter/material.dart';
import 'package:irisense/core/services/auth_service.dart';
import 'package:irisense/l10n/app_localizations.dart';

enum ProfileFormMode { login, register }

class ProfileViewModel extends ChangeNotifier {
  final AuthService authService;

  ProfileViewModel({required this.authService});

  ProfileFormMode _mode = ProfileFormMode.login;
  ProfileFormMode get mode => _mode;

  void toggleMode() {
    _mode = _mode == ProfileFormMode.login
        ? ProfileFormMode.register
        : ProfileFormMode.login;
    authService.clearError();
    notifyListeners();
  }

  // ─── Validation helpers ─────────────────────────────────────────────────────

  bool isNameValid(String? value) =>
      value != null && value.trim().length >= 2;

  /// Kullanıcı adı: sadece harf, rakam ve alt çizgi, en az 3 karakter
  bool isUsernameFormatValid(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9_]{3,}$').hasMatch(value.trim());
  }

  /// Opsiyonel telefon: boş ise geçerli, doluysa Türkiye formatı
  bool isPhoneValid(String? value) {
    if (value == null || value.trim().isEmpty) return true; // opsiyonel
    final cleaned = value.trim().replaceAll(' ', '').replaceAll('-', '');
    return RegExp(r'^(\+90|0)5\d{9}$').hasMatch(cleaned);
  }

  bool isPasswordValid(String? value) =>
      value != null && value.length >= 6;

  // ─── Auth error translation ─────────────────────────────────────────────────

  String? translateAuthError(String? code, AppLocalizations l10n) {
    if (code == null) return null;
    switch (code) {
      case 'username-taken':
        return l10n.authErrorUsernameTaken;
      case 'user-not-found':
        return l10n.authErrorUserNotFound;
      case 'wrong-password':
        return l10n.authErrorWrongPassword;
      case 'network-request-failed':
        return l10n.authErrorNetworkFailed;
      default:
        return l10n.authErrorUnknown;
    }
  }

  // ─── Actions ────────────────────────────────────────────────────────────────

  Future<bool> login(String username, String password) =>
      authService.login(username: username, password: password);

  Future<bool> register(
    String firstName,
    String lastName,
    String username,
    String phone,
    String password,
    String role,
  ) =>
      authService.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        phone: phone,
        password: password,
        role: role,
      );

  Future<bool> updateProfile(
    String firstName,
    String lastName,
    String phone,
    String? newPassword,
  ) =>
      authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        newPassword: newPassword,
      );

  Future<void> logout() => authService.logout();
}
