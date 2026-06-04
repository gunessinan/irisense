import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:irisense/app/app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemma/core/api/flutter_gemma.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint(".env dosyası yüklenemedi: $e");
  }

  await FlutterGemma.initialize();

  bool permissionsGranted = await requestPermissions();
  runApp(IrisenseApp(hasPermission: permissionsGranted));
}

Future<bool> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.speech,
  ].request();

  bool allGranted = statuses.values.every((status) => status.isGranted);

  if (allGranted) {
    return true;
  }

  if (statuses.values.any((status) => status.isPermanentlyDenied)) {
    await openAppSettings();
  }

  return false;
}
