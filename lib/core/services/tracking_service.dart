import 'package:flutter/material.dart';
import 'dart:typed_data';
// App
import 'package:irisense/app/app_viewmodel.dart';
// Core
import 'package:irisense/core/models/gaze_data.dart';
import 'package:irisense/core/services/native_service.dart';

class TrackingService extends ChangeNotifier {
  // State
  GazeData gazeData = GazeData(gazeType: "Straight", corX: 0.0, corY: 0.0, image: null);
  
  // Logic Variables (Dwell Time & Trigger)
  final Stopwatch _dwellStopwatch = Stopwatch(); // Süre tutucu
  int _dwellThresholdMs = 1400; // 1.4 Saniye bekleme süresi
  
  String? _lastLookedGaze; // Kullanıcının en son (şu an) baktığı ham yön
  bool _hasTriggeredForCurrentGaze = false; // Şu anki bakış için işlem yapıldı mı?

  final Map<int, void Function(String)> pageActions = {};
  final Set<int> _pagesHandleDown = {};
  final Set<int> _pagesHandleUp = {};
  
  // Dependencies
  final NativeService nativeService;
  final AppViewModel appViewModel;
  final Size screenSize;

  TrackingService({
    required this.nativeService,
    required this.appViewModel,
    required this.screenSize,
  }) {
    nativeService.addListener(_onNativeUpdate);
  }

  @override
  void dispose() {
    nativeService.removeListener(_onNativeUpdate);
    super.dispose();
  }

  // --- Main Loop ---
  void _onNativeUpdate() {
    // 0. Native Verileri Al
    double normX = nativeService.normalX;
    double normY = nativeService.normalY;
    Uint8List? image = nativeService.userImage;

    // 1. Koordinat Hesapla
    double pixelX = normX * screenSize.width;
    double pixelY = normY * screenSize.height;

    // 2. Yönü Hesapla
    String currentGaze = _calculateGazeDirection(normX, normY);

    // 3. GazeData güncelle
    gazeData = GazeData(
      gazeType: currentGaze,
      corX: pixelX,
      corY: pixelY,
      image: image,
    );

    // 4. Dwell Time (Bekleme) ve Aksiyon Mantığı
    _handleDwellLogic(currentGaze);
    
    notifyListeners();
  }

  // --- Logic 1: Yön Hesabı (Java Port) ---
  String _calculateGazeDirection(double normX, double normY) {
    if (normX == -1.0 && normY == -1.0)
    {
      return "Blink";
    } 
    int colIdx = 1;
    if (normX < 0.3) colIdx = 0;
    else if (normX > 0.74) colIdx = 2;

    String regionName = "";

    if (colIdx == 0 || colIdx == 2) {
      String prefix = (colIdx == 0) ? "Left" : "Right";
      if (normY < 0.44) {
        regionName = "$prefix Up";
      } else if (colIdx == 2 && normY >= 0.72) {
        regionName = "Right Down";
      } else {
        regionName = prefix;
      }
    } else {
      if (normY < 0.15) regionName = "Up";
      else if (normY > 0.85) regionName = "Down";
      else regionName = "Straight";
    }
    return regionName;
  }

  // --- Logic 2: Dwell Time Kontrolü ---
  void _handleDwellLogic(String currentGaze) {
    // A. Eğer kullanıcının baktığı yön değiştiyse (Örn: Left -> Straight veya Left -> Right)
    if (currentGaze != _lastLookedGaze) {
      _lastLookedGaze = currentGaze; // Yeni yönü kaydet
      _dwellStopwatch.reset();       // Sayacı sıfırla
      _dwellStopwatch.start();       // Sayacı başlat
      _hasTriggeredForCurrentGaze = false; // Henüz tetiklenmedi olarak işaretle
    }

    // B. Eğer "Straight" (Ortaya/Boşa) bakıyorsa işlem yapma, sadece bekle
    if (currentGaze == "Straight") {
      // Straight durumunda tetikleme olmaz, sayaç dönmeye devam etse de önemsizdir.
      // Zaten yukarıdaki (A) adımı sayesinde Straight'ten çıkınca sayaç sıfırlanacak.
      return;
    }

    // C. Süre Kontrolü ve Tetikleme
    // Eğer süre eşiği aşıldıysa VE bu bakış için daha önce tetikleme yapılmadıysa
    if (_dwellStopwatch.elapsedMilliseconds >= _dwellThresholdMs && !_hasTriggeredForCurrentGaze) {
      
      _triggerAction(currentGaze); // Aksiyonu çalıştır
      
      _hasTriggeredForCurrentGaze = true; // KİLİTLE: Kullanıcı bakışını değiştirene kadar tekrar çalışmasın.
      _dwellStopwatch.stop(); // Sayacı durdurabiliriz (opsiyonel)
    }
  }

  // --- Logic 3: Aksiyon Yönetimi ---
  void _triggerAction(String gazeType) {
    // Aksiyon gerçekleştiğinde ses ver (Geri bildirim önemlidir)
    appViewModel.soundService.playBeep();

    if (appViewModel.navbar_isOpen) {
      bool handled = true;
      
      if (gazeType.startsWith("Left")) {
         appViewModel.goToPage(0);
      } else if (gazeType == "Up") {
         appViewModel.goToPage(1);
      } else if (gazeType.startsWith("Right")) {
         appViewModel.goToPage(2);
      } else if (gazeType == "Down") {
         // Menü kapatma isteği olabilir
      } else {
        handled = false;
      }
      
      if (handled || gazeType == "Down") {
        appViewModel.navbar_isOpen = false;
      }
    } 
    else {
      // Menü Kapalıysa
      if (gazeType == "Up" && !_pagesHandleUp.contains(appViewModel.currentIndex)) {
        appViewModel.navbar_isOpen = true;
        return;
      }
      if (gazeType == "Down" && !_pagesHandleDown.contains(appViewModel.currentIndex)) {
        return;
      }

      // Sayfa özel aksiyonu
      final action = pageActions[appViewModel.currentIndex];
      if (action != null) action(gazeType);
    }
  }

  // --- Native Methods Call ---
  int calibrationStep = 0;
  Future<void> resetCalibration() async {
    await nativeService.resetCalibration();
  }

  Future<void> saveCalibration() async {
    await nativeService.saveCalibration();
  }

  void setActionForPage(int pageIndex, void Function(String) action) {
    pageActions[pageIndex] = action;
  }

  void setHandlesDown(int pageIndex, bool handles) {
    if (handles) {
      _pagesHandleDown.add(pageIndex);
    } else {
      _pagesHandleDown.remove(pageIndex);
    }
  }

  void setHandlesUp(int pageIndex, bool handles) {
    if (handles) {
      _pagesHandleUp.add(pageIndex);
    } else {
      _pagesHandleUp.remove(pageIndex);
    }
  }

  void setDwellTime(int time)
  {
    _dwellThresholdMs = time;
  }
}