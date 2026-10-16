import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_theme.dart';
import 'package:aay_plus/features/connected/marketplace_screen.dart';
import 'support/api_fixture.dart';

void main() {
  testWidgets(
    'Host opens own listing, edits it, and archives with confirmation',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = ApiFixture();
      api.user['id'] = 'host';
      api.ownListings.add(api.listing);
      await api.signIn();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: api.state,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const MarketplaceScreen(initialIndex: 2),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('API camera').last);
      await tester.tap(find.text('API camera').last);
      await tester.pumpAndSettle();
      expect(find.text('Listing details'), findsOneWidget);
      expect(find.text('Camera with lens'), findsOneWidget);
      await tester.tap(find.text('Edit listing'));
      await tester.pumpAndSettle();
      final title = find.widgetWithText(TextFormField, 'title');
      expect(
        tester.widget<TextFormField>(title).controller!.text,
        'API camera',
      );
      await tester.enterText(title, 'Updated camera');
      await tester.scrollUntilVisible(
        find.text('Save changes'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();
      final edit = api.requests.lastWhere((r) => r.method == 'PATCH');
      expect(edit.url.path, '/api/v1/listings/listing');
      expect(jsonDecode(edit.body)['title'], 'Updated camera');
      expect(jsonDecode(edit.body)['hourly_paise'], 12000);
      expect(jsonDecode(edit.body).containsKey('active'), isFalse);
      expect(find.text('Listing details'), findsOneWidget);
      await tester.tap(find.text('Archive'));
      await tester.pumpAndSettle();
      expect(find.text('Archive this listing?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(api.listing['active'], isTrue);
      await tester.tap(find.text('Archive'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Archive'));
      await tester.pumpAndSettle();
      expect(api.listing['active'], isFalse);
      expect(find.text('Restore'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      api.state.dispose();
    },
  );
}
