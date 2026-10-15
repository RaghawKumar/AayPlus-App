import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aay_plus/core/constants/app_theme.dart';
import 'package:aay_plus/features/connected/marketplace_widgets.dart';

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets(
    'Full flow guide fits a narrow phone and exposes all three journeys',
    (tester) async {
      tester.view.physicalSize = const Size(320, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const RentalFlowScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sign in & verify'), findsOneWidget);
      await tester.tap(find.text('Host'));
      await tester.pumpAndSettle();
      expect(find.text('Verify your account'), findsOneWidget);
      await tester.tap(find.text('Review'));
      await tester.pumpAndSettle();
      expect(find.text('Review members'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Reduced motion reveals content immediately and disputed progress stays explicit',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Reveal(child: RentalProgress(status: 'disputed')),
            ),
          ),
        ),
      );
      expect(tester.widget<Opacity>(find.byType(Opacity).first).opacity, 1);
      expect(
        find.text('A damage claim is awaiting administrator review.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
