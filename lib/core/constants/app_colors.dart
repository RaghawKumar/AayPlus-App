import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors matching the AayPlus Logo
  static const Color primaryNavy = Color(0xFF0F172A);  // Rich Midnight Slate 900
  static const Color brandNavy = Color(0xFF0A1931);    // Deep Logo Navy
  static const Color navyDark = Color(0xFF0A1931);
  static const Color navySurface = Color(0xFF1E293B);  // Slate 800 for dark chips / accents

  // Modern Light Theme Canvas & Surfaces
  static const Color scaffoldBg = Color(0xFFF8FAFC);   // Main scaffold background (Slate 50)
  static const Color darkNavy = Color(0xFFF8FAFC);     // Backward compatibility alias for scaffold
  static const Color surfaceNavy = Color(0xFFFFFFFF);  // Cards & elevated surfaces (Pure White)
  static const Color cardNavy = Color(0xFFFFFFFF);     // Cards & item tiles
  static const Color elevatedNavy = Color(0xFFF1F5F9); // Light pill/chip container (Slate 100)
  static const Color borderNavy = Color(0xFFE2E8F0);   // Modern card border (Slate 200)
  static const Color borderMedium = Color(0xFFCBD5E1); // Defined interactive border (Slate 300)
  static const Color lightBorder = Color(0xFFE2E8F0);  // Subtle hairline divider
  static const Color shadowLight = Color(0x0F0F172A);  // Subtle ambient shadow for light mode cards
  static const Color shadowMedium = Color(0x1A0F172A); // Elevated card shadow

  // Amber / Golden Orange Accent from Logo Swoosh & 'Plus'
  static const Color amberAccent = Color(0xFFF59E0B);  // Vibrant Golden Amber 500
  static const Color amberGlow = Color(0xFFFBBF24);    // Amber 400
  static const Color amberDark = Color(0xFFD97706);    // Rich Warm Amber 600
  static const Color amberDeep = Color(0xFFB45309);    // Deep Amber 700 (High contrast on white!)
  static const Color amberText = Color(0xFFB45309);    // High contrast (6.9:1) text color for light mode
  static const Color amberLight = Color(0xFFFEF3C7);   // Soft premium badge background (Amber 100)
  static const Color amberBorder = Color(0xFFFDE68A);  // Pill border (Amber 200)

  // Text & Neutral Colors for Light Theme (High Contrast & Professional)
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);  // Rich Slate 900 for headings & primary text (16:1)
  static const Color textSecondary = Color(0xFF334155);// Clean Slate 700 for subtitles & body
  static const Color textMuted = Color(0xFF64748B);    // Slate 500 for hints, labels & captions (4.6:1 WCAG AA)
  static const Color textDark = Color(0xFF0F172A);
  static const Color textOnDark = Color(0xFFFFFFFF);   // For text on dark navy surfaces
  static const Color textWhite = Color(0xFFFFFFFF);    // For text placed on dark surfaces

  // Status & Utility Colors (Crisp and vibrant for light background)
  static const Color success = Color(0xFF059669);      // Emerald 600
  static const Color successLight = Color(0xFFECFDF5); // Emerald 50
  static const Color successBorder = Color(0xFFA7F3D0);// Emerald 200
  static const Color danger = Color(0xFFDC2626);       // Red 600
  static const Color dangerLight = Color(0xFFFEF2F2);  // Red 50
  static const Color dangerBorder = Color(0xFFFECACA); // Red 200
  static const Color warning = Color(0xFFD97706);      // Amber 600
  static const Color warningLight = Color(0xFFFFFBEB); // Amber 50
  static const Color warningBorder = Color(0xFFFDE68A);// Amber 200
  static const Color info = Color(0xFF0284C7);         // Sky 600
  static const Color infoLight = Color(0xFFF0F9FF);    // Sky 50
  static const Color infoBorder = Color(0xFFBAE6FD);   // Sky 200

  // Gradients for Light Theme
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberButtonGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient navyCardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient activeRentalGradient = LinearGradient(
    colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient disputeGradient = LinearGradient(
    colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
