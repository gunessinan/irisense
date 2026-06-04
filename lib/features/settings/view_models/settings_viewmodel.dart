import 'package:flutter/material.dart';
import 'dart:async';
// Core
import 'package:irisense/core/services/tracking_service.dart';

class SettingsViewModel extends ChangeNotifier
{
  TrackingService trackingService;
  
  SettingsViewModel({
    required this.trackingService
  });

  final List<String> inputLog_items = [];
  final StreamController<int> _insertItemController = StreamController<int>.broadcast();
  Stream<int> get insertItemStream => _insertItemController.stream;
  void addLogItem(String text) {
    inputLog_items.insert(0, text);
    _insertItemController.sink.add(0);
    notifyListeners();
  }

  @override
  void dispose() {
    _insertItemController.close();
    super.dispose();
  }

  void dwellTime_changed(String mode)
  {
    int ms = 1400;
    switch (mode)
    {
      case 'Fast':
        ms = 600;
      case 'Standard':
        ms = 800;
      case 'Slow':
        ms = 1000;
      case 'VerySlow':
        ms = 1400;
      default:
        ms = 1400;
    }
    trackingService.setDwellTime(ms);
  }

  void calibrateBtn_onTap()
  {
    if (trackingService.calibrationStep == 3)
    {
      trackingService.saveCalibration();
      trackingService.calibrationStep = 0;
    }
    else
    {
      if (trackingService.calibrationStep == 0)
        trackingService.resetCalibration();
      if (trackingService.calibrationStep == 1 || trackingService.calibrationStep == 2)
        trackingService.saveCalibration();
      trackingService.calibrationStep++;
      notifyListeners();
    }
  }

  void actionTriggered(String gazeType)
  {
    addLogItem(gazeType);
  }
}