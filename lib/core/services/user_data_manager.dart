import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataManager extends ChangeNotifier {
  SharedPreferences? _prefs;

  // --- Keys ---
  static const String _keyDwellTime = 'dwell_time';
  static const String _keyLanguage = 'language';
  static const String _keyGenModel = 'gen_model';
  static const String _keyDebug = 'debug_mode';

  // --- Default Values ---
  String _dwellTime = "Standard";
  String _language = "en-US";
  String _generationModel = "Gemini";
  String _debugMode = "Disabled";

  // --- Getters ---
  String get dwellTime => _dwellTime;
  String get language => _language;
  String get generationModel => _generationModel;
  String get debugMode => _debugMode;
  
  /*
  String getLanguage({bool ownLanguage = false})
  {
    switch (_language)
    {
      case "en-US":
        return ownLanguage ? "English" : "English";
      case "tr-TR":
        return ownLanguage ? "Türkçe" : "Turkish";
      case "es-ES":
        return ownLanguage ? "Español" : "Spanish";
      case "zh-CN":
        return ownLanguage ? "中文" : "Chinese";
      case "ru-RU":
        return ownLanguage ? "Русский" : "Russian";
      case "de-DE":
        return ownLanguage ? "Deutsch" : "German";
      default:
        return "English";
    }
  }
  */

  // --- Initialize ---
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    _dwellTime = _prefs?.getString(_keyDwellTime) ?? "Standard";
    _language = _prefs?.getString(_keyLanguage) ?? "en-US";
    _generationModel = _prefs?.getString(_keyGenModel) ?? "Gemini";
    _debugMode = _prefs?.getString(_keyDebug) ?? "Disabled";
    
    notifyListeners();
  }

  // <--- Setters --->
  Future<void> setDwellTime(String value) async {
    _dwellTime = value;
    await _prefs?.setString(_keyDwellTime, value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _prefs?.setString(_keyLanguage, value);
    notifyListeners();
  }

  Future<void> setGenerationModel(String value) async {
    _generationModel = value;
    await _prefs?.setString(_keyGenModel, value);
    notifyListeners();
  }

  Future<void> setDebugMode(String value) async {
    _debugMode = value;
    await _prefs?.setString(_keyDebug, value);
    notifyListeners();
  }
}