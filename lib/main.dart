import 'package:flutter/material.dart';
import 'package:aay_plus/core/logging/dev_log.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_theme.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/features/connected/marketplace_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait orientation for mobile-first app feel
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Transparent status bar with dark icons for light theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF8FAFC),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppStateProvider())],
      child: const AayPlusApp(),
    ),
  );
}

class AayPlusApp extends StatelessWidget {
  const AayPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey(context.watch<AppStateProvider>().signedIn),
      title: 'AayPlus - Peer-to-Peer Rental Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorObservers: [DevNavigationObserver()],
      home: const ConnectedGate(),
    );
  }
}
