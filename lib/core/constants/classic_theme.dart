import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // --- Arka plan katmanları ---
  static Color darkBackground = HexColor("#1d242e"); // Ana arka plan
  static Color darkSurface = HexColor("#2a3341");    // Kart / buton yüzeyi (arka plandan belirgin)
  static Color darkElevated = HexColor("#2D3138");   // Yükseltilmiş panel (dialog, ayarlar kutusu)
  static Color darkInput = HexColor("#252930");      // Giriş alanı / iç içe konteyner

  // --- Vurgu renkleri ---
  static Color accentGray = HexColor("#514d5e");     // Navbar, ikincil alanlar
  static Color tealShade = HexColor("#385158");      // LLM kutusu arka planı
  static Color limeAccent = HexColor("#048783");     // Aktif durum, birincil buton
  static Color yellowAccent = HexColor("#b8e0d0");   // Hover / focus durumu (yumuşak teal-beyaz)

  // --- Bilgi paneli renkleri ---
  static Color infoSurface = HexColor("#395079");   // Kamera çerçevesi, log içeriği
  static Color infoHeader = HexColor("#2D4672");    // Log başlığı

  // --- Durum renkleri ---
  static Color errorColor = HexColor("#EF4444");        // Hata / silme işlemleri
  static Color errorSurface = const Color(0x26EF4444);  // Hata arka planı (%15 opaklık)
  static Color successColor = HexColor("#22c55e");      // Başarı durumu
  static Color warningColor = HexColor("#FFAB40");      // Uyarı durumu (orangeAccent)
  static Color infoColor = HexColor("#3b82f6");         // Bilgi / indirme durumu

  // --- Kenarlık renkleri ---
  static const Color borderMuted = Color(0x61000000);   // Soluk kenarlık (black38, gaze klavye)
  static const Color borderSubtle = Color(0x1AFFFFFF);  // Çok ince kenarlık (white10)

  // --- Metin renkleri ---
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF); // white70
  static const Color textMuted = Color(0x8AFFFFFF);     // white54
  static const Color textDisabled = Color(0x61FFFFFF);  // white38
  static const Color textFaint = Color(0x3DFFFFFF);     // white24
}

class GazeIcons {
  static const double _width = 36;
  static const double _height = 36;
  static const BoxFit _fit = BoxFit.contain;

  static Widget _gazeWidget(String name) {
    return Image.asset(
      'assets/images/$name.png',
      width: _width,
      height: _height,
      fit: _fit,
    );
  }

  static final Widget leftup = _gazeWidget("leftupgaze");
  static final Widget rightup = _gazeWidget("rightupgaze"); 
  static final Widget left = _gazeWidget("leftgaze"); 
  static final Widget right = _gazeWidget("rightgaze"); 
  static final Widget closed = _gazeWidget("closedgaze"); 
  static final Widget up = _gazeWidget("upgaze"); 
  static final Widget down = _gazeWidget("downgaze"); 
}

class WidgetDetails {
  static const double borderRadius = 18.0;
  static const double boxPadding = 10.0;
}

class AppTextStyles {
  static TextStyle interMedium14 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle interBold18 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}