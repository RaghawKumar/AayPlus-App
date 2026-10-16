import 'dart:async';
import 'dart:convert';
import '../logging/dev_log.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? status;
  const ApiException(this.message, [this.status]);
  @override
  String toString() => message;
}

class ApiClient {
  final http.Client _client;
  final String baseUrl;
  String? token;
  ApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl =
          baseUrl ??
          const String.fromEnvironment('API_BASE_URL', defaultValue: '') {
    if (this.baseUrl.isNotEmpty && !Uri.parse(this.baseUrl).hasScheme) {
      throw ArgumentError('API_BASE_URL must be an absolute URL');
    }
  }
  String get url => baseUrl.isNotEmpty
      ? baseUrl.replaceAll(RegExp(r'/$'), '')
      : 'https://aayplus-backend.onrender.com/api/v1';

  Future<dynamic> request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final timer = Stopwatch()..start();
    DevLog.event('api.request', {
      'method': method,
      'path': path.split('?').first,
      'body': body,
    });
    try {
      final response = await _client
          .send(
            http.Request(method, Uri.parse('$url$path'))
              ..headers.addAll({
                'Content-Type': 'application/json',
                if (token != null) 'Authorization': 'Bearer $token',
              })
              ..body = body == null ? '' : jsonEncode(body),
          )
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 15));
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      DevLog.event('api.response', {
        'method': method,
        'path': path.split('?').first,
        'status': response.statusCode,
        'durationMs': timer.elapsedMilliseconds,
        'body': decoded,
      });
      if (response.statusCode >= 400) {
        throw ApiException(
          (decoded['error'] as Map?)?['message']?.toString() ??
              'Request failed',
          response.statusCode,
        );
      }
      return decoded['data'];
    } on ApiException {
      rethrow;
    } on TimeoutException {
      DevLog.event('api.error', {'type': 'timeout'});
      throw const ApiException('The server took too long. Please try again.');
    } on http.ClientException {
      DevLog.event('api.error', {'type': 'connection'});
      throw const ApiException(
        'Cannot reach the server. Check your connection and API address.',
      );
    } on FormatException {
      throw const ApiException('The server returned an invalid response.');
    }
  }

  Future<List<Map<String, dynamic>>> collection(String path) async {
    final rows = <Map<String, dynamic>>[];
    for (var offset = 0; ; offset += 100) {
      final page =
          await request('$path?limit=100&offset=$offset')
              as Map<String, dynamic>;
      final items = (page['items'] as List).cast<Map<String, dynamic>>();
      rows.addAll(items);
      if (items.length < 100) return rows;
    }
  }

  String mediaUrl(String path) => Uri.parse(url).resolve(path).toString();

  Future<String> uploadImage(Uint8List bytes) => uploadMedia(bytes);

  Future<String> uploadMedia(
    Uint8List bytes, {
    String? bookingId,
    bool video = false,
  }) async {
    final path =
        '/uploads${video ? '/videos' : ''}${bookingId == null ? '' : '?booking_id=$bookingId'}';
    final limit = (video ? 50 : 8) * 1024 * 1024;
    if (bytes.isEmpty || bytes.length > limit) {
      throw ApiException(
        video
            ? 'Choose a video smaller than 50 MB.'
            : 'Choose a photo smaller than 8 MB.',
      );
    }
    final timer = Stopwatch()..start();
    DevLog.event('api.upload', {
      'path': path.split('?').first,
      'size': bytes.length,
    });
    try {
      final response = await _client
          .send(
            http.Request('POST', Uri.parse('$url$path'))
              ..headers.addAll({
                'Content-Type': 'application/octet-stream',
                if (token != null) 'Authorization': 'Bearer $token',
              })
              ..bodyBytes = bytes,
          )
          .then(http.Response.fromStream)
          .timeout(Duration(seconds: video ? 120 : 45));
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      DevLog.event('api.response', {
        'path': '/uploads',
        'status': response.statusCode,
        'durationMs': timer.elapsedMilliseconds,
        'body': decoded,
      });
      if (response.statusCode >= 400) {
        throw ApiException(
          (decoded['error'] as Map?)?['message']?.toString() ??
              'Photo upload failed',
          response.statusCode,
        );
      }
      return decoded['data']['url'] as String;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      DevLog.event('api.error', {'type': 'timeout'});
      throw const ApiException('Photo upload timed out. Please try again.');
    } on http.ClientException {
      DevLog.event('api.error', {'type': 'connection'});
      throw const ApiException(
        'Photo upload failed. Check your connection and try again.',
      );
    } on FormatException {
      throw const ApiException(
        'The upload server returned an invalid response.',
      );
    }
  }

  void close() => _client.close();
}
