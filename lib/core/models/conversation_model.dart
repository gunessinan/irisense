import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final String lastSenderId;
  final Map<String, int> unread;

  const ConversationModel({
    required this.id,
    required this.participants,
    required this.participantNames,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastSenderId,
    required this.unread,
  });

  int unreadFor(String uid) => unread[uid] ?? 0;

  String otherUid(String myUid) =>
      participants.firstWhere((p) => p != myUid, orElse: () => '');

  String otherName(String myUid) =>
      participantNames[otherUid(myUid)] ?? '';

  factory ConversationModel.fromMap(String id, Map<String, dynamic> map) {
    final participants = (map['participants'] as List?)?.cast<String>() ?? [];
    final participantNames =
        (map['participantNames'] as Map?)?.cast<String, String>() ?? {};
    final unreadRaw =
        (map['unread'] as Map?)?.cast<String, dynamic>() ?? {};
    final unread =
        unreadRaw.map((k, v) => MapEntry(k, (v as num?)?.toInt() ?? 0));
    return ConversationModel(
      id: id,
      participants: participants,
      participantNames: participantNames,
      lastMessage: map['lastMessage'] as String? ?? '',
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate(),
      lastSenderId: map['lastSenderId'] as String? ?? '',
      unread: unread,
    );
  }
}
