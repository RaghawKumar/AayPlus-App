import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_theme.dart';
import 'package:aay_plus/features/connected/marketplace_screen.dart';
import 'support/api_fixture.dart';

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets(
    'Connected discovery displays API listings and searches without demo fallback',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = ApiFixture();
      await api.signIn();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: api.state,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const MarketplaceScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('API camera'), findsOneWidget);
      expect(tester.widget<Text>(find.text('All')).style?.color, Colors.white);
      expect(
        tester.widget<Text>(find.text('Parking')).style?.color,
        isNot(Colors.white),
      );
      await tester.ensureVisible(find.text('Parking'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Parking'));
      await tester.pumpAndSettle();
      expect(find.text('No rentals found'), findsOneWidget);
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(find.text('API camera'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'missing item');
      await tester.pumpAndSettle();
      expect(find.text('No rentals found'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'camera');
      await tester.pumpAndSettle();
      expect(find.text('API camera'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      api.state.dispose();
    },
  );
  testWidgets('Quote and request use the API then show renter confirmation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final api = ApiFixture();
    await api.signIn();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: api.state,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: ListingRequestScreen(listing: api.listing),
        ),
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Check availability & price'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check availability & price'));
    await tester.pumpAndSettle();
    expect(find.text('Total: ₹3,510'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Send booking request'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send booking request'));
    await tester.pumpAndSettle();
    expect(
      find.text('Request sent. Waiting for the host to approve.'),
      findsOneWidget,
    );
    expect(find.text('Approve request'), findsNothing);
    expect(api.bookings.single['status'], 'requested');
    await tester.pumpWidget(const SizedBox());
    api.state.dispose();
  });
}
