import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_theme.dart';
import 'package:aay_plus/features/connected/marketplace_screen.dart';
import 'support/api_fixture.dart';

final photoBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
);

class TestPicker extends ImagePicker {
  ImageSource? lastSource;
  bool cancel = false;
  String? failureCode;
  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    if (failureCode != null) throw PlatformException(code: failureCode!);
    lastSource = ImageSource.gallery;
    return cancel ? [] : [XFile.fromData(photoBytes, name: 'gallery.png')];
  }

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    lastSource = source;
    return cancel ? null : XFile.fromData(photoBytes, name: 'camera.png');
  }
}

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);
  test(
    'Photo upload sends authenticated image bytes and resolves backend media URLs',
    () async {
      final api = ApiFixture();
      addTearDown(api.state.dispose);
      await api.signIn();
      final url = await api.client.uploadImage(photoBytes);
      final request = api.requests.last;
      expect(request.url.path, '/api/v1/uploads');
      expect(request.headers['Content-Type'], 'application/octet-stream');
      expect(request.headers['Authorization'], 'Bearer test-token');
      expect(request.bodyBytes, photoBytes);
      expect(
        api.client.mediaUrl(url),
        'http://test/media/aaaaaaaaaaaaaaaaaaaaaaaa.jpg',
      );
    },
  );
  testWidgets(
    'Listing photos can come from gallery or camera, be removed, and selection can be cancelled',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = ApiFixture(), picker = TestPicker();
      await api.signIn();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: api.state,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ListingEditorScreen(imagePicker: picker),
          ),
        ),
      );
      expect(find.text('photo URL (optional)'), findsNothing);
      Future<void> tap(String text) async {
        await tester.scrollUntilVisible(
          find.text(text),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(text));
        await tester.pumpAndSettle();
      }

      await tap('Choose photos');
      expect(picker.lastSource, ImageSource.gallery);
      expect(find.byTooltip('Remove photo 1'), findsOneWidget);
      await tester.ensureVisible(find.byTooltip('Remove photo 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Remove photo 1'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove photo 1'), findsNothing);
      await tap('Take photo');
      expect(picker.lastSource, ImageSource.camera);
      expect(find.byTooltip('Remove photo 1'), findsOneWidget);
      picker.cancel = true;
      await tap('Choose photos');
      expect(find.byTooltip('Remove photo 2'), findsNothing);
      expect(find.byTooltip('Remove photo 1'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      api.state.dispose();
    },
  );
  testWidgets(
    'Missing iOS plugin gives rebuild guidance and selection can retry without losing the form',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = ApiFixture(),
          picker = TestPicker()..failureCode = 'channel-error';
      await api.signIn();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: api.state,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ListingEditorScreen(imagePicker: picker),
          ),
        ),
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'title',
        ),
        'Sony camera',
      );
      await tester.scrollUntilVisible(
        find.text('Choose photos'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose photos'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Photo picker is missing from this build'),
        findsOneWidget,
      );
      picker.failureCode = null;
      await tester.ensureVisible(find.text('Choose photos'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose photos'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove photo 1'), findsOneWidget);
      expect(
        find.textContaining('Photo picker is missing from this build'),
        findsNothing,
      );
      await tester.pumpWidget(const SizedBox());
      api.state.dispose();
    },
  );
}
