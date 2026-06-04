import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  /// Kullanıcı adı (ör: mehmet123) — kayıt sırasında seçilen benzersiz ad
  final String username;
  /// Opsiyonel telefon numarası (rehberden eşleşme için)
  final String phone;
  final String role; // 'user' veya 'patient'
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.phone = '',
    required this.role,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'phone': phone,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    final username = map['username'] as String? ??
        map['email'] as String? ??
        '';
    return UserModel(
      uid: uid,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      username: username,
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now()),
    );
  }
}
