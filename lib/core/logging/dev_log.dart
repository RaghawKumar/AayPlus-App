import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DevLog {
  static final _private = RegExp(
    r'token|authorization|cookie|password|secret|code|phone|email|bytes|photos|videos|photo_url',
    caseSensitive: false,
  );
  static dynamic sanitize(dynamic value, [int depth = 0]) {
    if (depth > 5) return '[truncated]';
    if (value is Uint8List) return '[binary omitted]';
    if (value is Map)
      return {
        for (final entry in value.entries.take(40))
          entry.key.toString(): _private.hasMatch(entry.key.toString())
              ? '[redacted]'
              : sanitize(entry.value, depth + 1),
      };
    if (value is List)
      return [
        ...value.take(10).map((v) => sanitize(v, depth + 1)),
        if (value.length > 10) '[${value.length - 10} more items]',
      ];
    if (value is String && value.length > 300)
      return '${value.substring(0, 300)}…';
    return value;
  }

  static void event(String event, [Map<String, dynamic> data = const {}]) {
    if (kDebugMode)
      debugPrint('[AayPlus][$event] ${jsonEncode(sanitize(data))}');
  }

  static void screen(String name) => event('screen', {'name': name});
  static void action(String name) => event('action', {'name': name});
}

class DevNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      DevLog.event('navigation.push', {
        'route': route.settings.name ?? route.runtimeType.toString(),
      });
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      DevLog.event('navigation.back', {
        'route': route.settings.name ?? route.runtimeType.toString(),
        'to': previousRoute?.settings.name,
      });
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      DevLog.event('navigation.replace', {'route': newRoute?.settings.name});
}
