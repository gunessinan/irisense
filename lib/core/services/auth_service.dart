import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:irisense/core/models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferences? _prefs;

  static const String _keyUserId = 'auth_user_id';

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final userId = _prefs?.getString(_keyUserId);
    if (userId != null) {
      await _loadUserFromFirestore(userId);
    }
    notifyListeners();
  }

  Future<void> _loadUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('Users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        _currentUser = UserModel.fromMap(uid, doc.data()!);
      }
    } catch (e) {
      debugPrint('Kullanıcı yükleme hatası: $e');
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Kullanıcı adını normalleştirir: küçük harf + trim
  String _normalizeUsername(String username) => username.trim().toLowerCase();

  /// Telefonu normalleştirir: tüm rakamlar, +90/90 → 0, 5X → 05X
  String _normalizePhone(String phone) {
    if (phone.trim().isEmpty) return '';
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return '';
    if (digits.length == 12 && digits.startsWith('90')) {
      return '0${digits.substring(2)}';
    }
    if (digits.length == 10 && digits.startsWith('5')) {
      return '0$digits';
    }
    return digits;
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final normalizedUsername = _normalizeUsername(username);

      // Kullanıcı adı dolu mu?
      final existing = await _firestore
          .collection('Users')
          .where('username', isEqualTo: normalizedUsername)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        _error = 'username-taken';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final docRef = _firestore.collection('Users').doc();
      final user = UserModel(
        uid: docRef.id,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        username: normalizedUsername,
        phone: _normalizePhone(phone),
        role: role,
        createdAt: DateTime.now(),
      );

      final data = user.toMap();
      data['password'] = _hashPassword(password);
      await docRef.set(data);

      _currentUser = user;
      await _prefs?.setString(_keyUserId, docRef.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'network-request-failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final normalizedUsername = _normalizeUsername(username);

      final query = await _firestore
          .collection('Users')
          .where('username', isEqualTo: normalizedUsername)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _error = 'user-not-found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final doc = query.docs.first;
      final storedHash = doc.data()['password'] as String?;
      if (storedHash != _hashPassword(password)) {
        _error = 'wrong-password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = UserModel.fromMap(doc.id, doc.data());
      await _prefs?.setString(_keyUserId, doc.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'network-request-failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? newPassword,
  }) async {
    if (_currentUser == null) return false;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updates = <String, dynamic>{
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
      };
      if (phone != null) {
        updates['phone'] = _normalizePhone(phone);
      }
      if (newPassword != null && newPassword.isNotEmpty) {
        updates['password'] = _hashPassword(newPassword);
      }

      await _firestore
          .collection('Users')
          .doc(_currentUser!.uid)
          .update(updates);

      _currentUser = UserModel(
        uid: _currentUser!.uid,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        username: _currentUser!.username,
        phone: phone != null ? _normalizePhone(phone) : _currentUser!.phone,
        role: _currentUser!.role,
        createdAt: _currentUser!.createdAt,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'network-request-failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs?.remove(_keyUserId);
    notifyListeners();
  }
}
