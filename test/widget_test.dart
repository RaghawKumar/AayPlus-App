import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/main.dart';
import 'package:aay_plus/core/models/models.dart';
import 'support/api_fixture.dart';

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('App starts at real sign-in without demo accounts', (
    tester,
  ) async {
    final api = ApiFixture();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: api.state, child: const AayPlusApp()),
    );
    expect(find.text('Make room for more.'), findsOneWidget);
    expect(api.state.signedIn, isFalse);
    expect(api.state.items, isEmpty);
    await tester.pumpWidget(const SizedBox());
    api.state.dispose();
  });
  test(
    'Role switching preserves the authenticated identity and prices convert from paise',
    () async {
      final api = ApiFixture();
      addTearDown(api.state.dispose);
      await api.signIn();
      expect(api.state.currentUser.name, 'API Member');
      expect(api.state.items.single.hourlyPrice, 120);
      expect(api.state.items.single.securityDeposit, 3000);
      api.state.toggleRole();
      expect(api.state.currentRole, UserRoleMode.owner);
      expect(api.state.currentUser.id, 'renter');
      expect(
        api.requests
            .where((r) => r.url.path.endsWith('/me'))
            .last
            .headers['Authorization'],
        'Bearer test-token',
      );
    },
  );
  test(
    'Mutations persist through API and refresh the displayed account',
    () async {
      final api = ApiFixture();
      addTearDown(api.state.dispose);
      await api.signIn();
      await api.state.mutate('/me', {
        'name': 'Updated member',
      }, method: 'PATCH');
      expect(api.state.currentUser.name, 'Updated member');
      expect(api.requests.any((r) => r.method == 'PATCH'), isTrue);
    },
  );
  test(
    'Refresh failures expose an error without replacing data with samples',
    () async {
      final api = ApiFixture();
      addTearDown(api.state.dispose);
      await api.signIn();
      api.fail = true;
      await api.state.refresh();
      expect(api.state.error, 'Server unavailable');
      expect(api.state.items.single.id, 'listing');
    },
  );
  test('Expired session clears account and all private data', () async {
    final api = ApiFixture();
    addTearDown(api.state.dispose);
    await api.signIn();
    api.unauthorized = true;
    await api.state.refresh();
    expect(api.state.signedIn, isFalse);
    expect(api.state.bookingRows, isEmpty);
    expect(api.state.user, isNull);
    expect(api.client.token, isNull);
  });
}
