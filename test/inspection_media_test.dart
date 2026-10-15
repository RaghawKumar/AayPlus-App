import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_theme.dart';
import 'package:aay_plus/features/connected/inspection_media_screen.dart';
import 'support/api_fixture.dart';

class InspectionPicker extends ImagePicker {
  ImageSource? source;
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    this.source = source;
    return XFile.fromData(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
      ),
      name: 'photo.png',
    );
  }

  @override
  Future<XFile?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    this.source = source;
    return XFile.fromData(utf8.encode('mock video bytes'), name: 'video.mp4');
  }
}

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets(
    'Pickup captures photo and gallery video, uploads them for the booking and saves inspection',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = ApiFixture(), picker = InspectionPicker();
      await api.signIn();
      api.bookings.add({
        'id': 'booking',
        'pickup_available': true,
        'start_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'listing': api.listing,
      });
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: api.state,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Builder(
                builder: (ctx) => TextButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => InspectionMediaScreen(
                        bookingId: 'booking',
                        kind: 'pickup',
                        imagePicker: picker,
                      ),
                    ),
                  ),
                  child: const Text('Open inspection'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open inspection'));
      await tester.pumpAndSettle();
      expect(find.text('photo url'), findsNothing);
      await tester.enterText(
        find.byType(TextField),
        'Condition checked before handover',
      );
      Future<void> tap(String label) async {
        await tester.scrollUntilVisible(
          find.text(label),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }

      await tap('Take photo');
      expect(picker.source, ImageSource.camera);
      await tap('Choose video');
      expect(picker.source, ImageSource.gallery);
      expect(find.text('Inspection photo'), findsOneWidget);
      expect(find.text('Inspection video'), findsOneWidget);
      await tap('Save inspection');
      expect(find.text('Open inspection'), findsOneWidget);
      final uploads = api.requests
          .where((r) => r.url.path.contains('/uploads'))
          .toList();
      expect(uploads.length, 2);
      expect(
        uploads.every((r) => r.url.queryParameters['booking_id'] == 'booking'),
        isTrue,
      );
      final saved = api.requests.firstWhere(
        (r) => r.url.path.endsWith('/pickup'),
      );
      final body = jsonDecode(saved.body);
      expect(body['photos'], hasLength(1));
      expect(body['videos'], hasLength(1));
      await tester.pumpWidget(const SizedBox());
      api.state.dispose();
    },
  );
  testWidgets('Future pickup is explained before upload and save is disabled', (
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
          home: InspectionMediaScreen(
            bookingId: 'booking',
            kind: 'pickup',
            pickupAt: DateTime.now().add(const Duration(hours: 2)),
            imagePicker: InspectionPicker(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Pickup opens'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Save inspection'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Save inspection'),
          )
          .onPressed,
      isNull,
    );
    expect(api.requests.where((r) => r.url.path.contains('/uploads')), isEmpty);
    await tester.pumpWidget(const SizedBox());
    api.state.dispose();
  });
}
