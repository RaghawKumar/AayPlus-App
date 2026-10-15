import 'package:flutter/material.dart';
import 'package:aay_plus/features/connected/marketplace_screen.dart';

class MainNavigationShell extends StatelessWidget {
  final int initialIndex;
  const MainNavigationShell({super.key, this.initialIndex = 0});
  @override
  Widget build(BuildContext context) =>
      MarketplaceScreen(initialIndex: initialIndex);
}
