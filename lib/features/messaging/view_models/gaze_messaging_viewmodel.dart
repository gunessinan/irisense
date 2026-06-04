import 'package:flutter/material.dart';
import 'package:irisense/core/services/messaging_service.dart';

class GazeMessagingViewModel extends ChangeNotifier {
  final Map<int, Map<String, String>> _slots = {};
  bool isLoading = false;

  Map<int, Map<String, String>> get slots => Map.unmodifiable(_slots);

  bool hasContact(int slot) => _slots.containsKey(slot);

  Map<String, String>? getContact(int slot) => _slots[slot];

  Future<void> loadSlots(String uid, MessagingService messaging) async {
    isLoading = true;
    notifyListeners();
    try {
      final loaded = await messaging.getContactSlots(uid);
      _slots
        ..clear()
        ..addAll(loaded);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setSlot(
    int slot,
    String myUid,
    String contactUid,
    String contactName,
    MessagingService messaging,
  ) async {
    await messaging.setContactSlot(myUid, slot, contactUid, contactName);
    _slots[slot] = {'uid': contactUid, 'name': contactName};
    notifyListeners();
  }

  Future<void> clearSlot(
    int slot,
    String myUid,
    MessagingService messaging,
  ) async {
    await messaging.clearContactSlot(myUid, slot);
    _slots.remove(slot);
    notifyListeners();
  }
}
