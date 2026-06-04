import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:irisense/core/models/conversation_model.dart';
import 'package:irisense/core/models/message_model.dart';
import 'package:irisense/core/models/user_model.dart';

class MessagingService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot>? _convSub;
  int _totalUnread = 0;
  final Map<String, int> _prevUnread = {};

  int get totalUnread => _totalUnread;

  Future<void> init(String currentUid) async {
    stopListening();
    _convSub = _firestore
        .collection('conversations')
        .where('participants', arrayContains: currentUid)
        .snapshots()
        .listen((snapshot) {
          int total = 0;
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final unreadRaw =
                (data['unread'] as Map?)?.cast<String, dynamic>() ?? {};
            final myUnread = (unreadRaw[currentUid] as num?)?.toInt() ?? 0;
            total += myUnread;
            _prevUnread[doc.id] = myUnread;
          }
          _totalUnread = total;
          notifyListeners();
        });
  }

  void stopListening() {
    _convSub?.cancel();
    _convSub = null;
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  static String conversationId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return sorted.join('_');
  }

  Future<void> sendMessage({
    required String fromUid,
    required String fromName,
    required String toUid,
    required String toName,
    required String text,
  }) async {
    final convId = conversationId(fromUid, toUid);
    final convRef = _firestore.collection('conversations').doc(convId);
    final messagesRef = convRef.collection('messages').doc();

    final batch = _firestore.batch();

    batch.set(convRef, {
      'participants': [fromUid, toUid],
      'participantNames': {fromUid: fromName, toUid: toName},
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSenderId': fromUid,
      'unread.$toUid': FieldValue.increment(1),
      'unread.$fromUid': 0,
    }, SetOptions(merge: true));

    batch.set(messagesRef, {
      'senderId': fromUid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Stream<List<ConversationModel>> conversationsStream(String uid) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((doc) => ConversationModel.fromMap(doc.id, doc.data()))
              .toList();
          list.sort((a, b) {
            final aTime = a.lastMessageAt;
            final bTime = b.lastMessageAt;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });
          return list;
        });
  }

  Stream<List<MessageModel>> messagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> markAsRead(String conversationId, String uid) async {
    await _firestore.collection('conversations').doc(conversationId).set({
      'unread.$uid': 0,
    }, SetOptions(merge: true));
  }

  Future<List<UserModel>> searchUsersByUsername(
    String query, {
    String excludeUid = '',
  }) async {
    if (query.trim().isEmpty) return [];
    final queryLower = query.trim().toLowerCase();
    final snapshot = await _firestore.collection('Users').get();
    final results = <UserModel>[];
    for (final doc in snapshot.docs) {
      if (doc.id == excludeUid) continue;
      final data = doc.data();
      final username = (data['username'] as String? ?? '').toLowerCase();
      if (username.contains(queryLower)) {
        results.add(UserModel.fromMap(doc.id, data));
      }
    }
    return results;
  }

  // ── Contact Slots ────────────────────────────────────────────────────────

  static const String _slotsField = 'contactSlots';

  Future<Map<int, Map<String, String>>> getContactSlots(String uid) async {
    final doc = await _firestore.collection('Users').doc(uid).get();
    final raw = (doc.data()?[_slotsField] as Map?)?.cast<String, dynamic>() ?? {};
    return raw.map((k, v) => MapEntry(int.parse(k), Map<String, String>.from(v as Map)));
  }

  Future<void> setContactSlot(
    String uid,
    int slot,
    String contactUid,
    String contactName,
  ) async {
    await _firestore.collection('Users').doc(uid).set({
      _slotsField: {
        '$slot': {'uid': contactUid, 'name': contactName}
      }
    }, SetOptions(merge: true));
  }

  Future<void> clearContactSlot(String uid, int slot) async {
    await _firestore.collection('Users').doc(uid).update({
      '$_slotsField.$slot': FieldValue.delete(),
    });
  }

  // ─────────────────────────────────────────────────────────────────────────

  Future<UserModel?> findUserByPhone(String rawPhone) async {
    final digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;

    // Normalize: +90.../90... → 05..., 5X(10) → 05X
    String normalized;
    if (digits.length == 12 && digits.startsWith('90')) {
      normalized = '0${digits.substring(2)}';
    } else if (digits.length == 11 && digits.startsWith('0')) {
      normalized = digits;
    } else if (digits.length == 10 && digits.startsWith('5')) {
      normalized = '0$digits';
    } else {
      return null;
    }

    // Kullanıcılar phone alanına normalize edilmiş 05XX formatında kaydedilir
    final snap = await _firestore
        .collection('Users')
        .where('phone', isEqualTo: normalized)
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) {
      return UserModel.fromMap(snap.docs.first.id, snap.docs.first.data());
    }
    return null;
  }
}
