import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aay_plus/core/logging/dev_log.dart';

void main() {
  test(
    'Development logs redact secrets and image bytes and bound collection output',
    () {
      final messages = <String>[];
      final previous = debugPrint;
      debugPrint = (message, {wrapWidth}) {
        if (message != null) messages.add(message);
      };
      addTearDown(() => debugPrint = previous);
      DevLog.event('api.response', {
        'token': 'private-token',
        'body': {
          'phone': '+919876543210',
          'developmentCode': '123456',
          'photos': ['private-photo'],
        },
        'binary': Uint8List.fromList([1, 2, 3]),
        'items': List.generate(15, (i) => i),
      });
      final log = messages.single;
      expect(log, contains('[redacted]'));
      expect(log, contains('[binary omitted]'));
      expect(log, contains('[5 more items]'));
      for (final secret in [
        'private-token',
        '+919876543210',
        '123456',
        'private-photo',
      ]) {
        expect(log, isNot(contains(secret)));
      }
    },
  );
}
