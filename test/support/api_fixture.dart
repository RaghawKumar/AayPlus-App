import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aay_plus/core/network/api_client.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';

class ApiFixture {
  final requests = <http.Request>[];
  bool fail = false, unauthorized = false;
  Map<String, dynamic> user = {
    'id': 'renter',
    'phone': '+919876543210',
    'name': 'API Member',
    'email': '',
    'kyc_status': 'verified',
    'role': 'member',
  };
  final listing = <String, dynamic>{
    'id': 'listing',
    'title': 'API camera',
    'category': 'Cameras',
    'description': 'Camera with lens',
    'location': 'Noida',
    'owner_id': 'host',
    'owner_name': 'API Host',
    'hourly_paise': 12000,
    'daily_paise': 60000,
    'weekly_paise': 300000,
    'deposit_paise': 300000,
    'photos': <String>[],
    'active': true,
  };
  final bookings = <Map<String, dynamic>>[];
  final ownListings = <Map<String, dynamic>>[];
  late final ApiClient client = ApiClient(
    baseUrl: 'http://test/api/v1',
    client: MockClient(handle),
  );
  late final AppStateProvider state = AppStateProvider(api: client);
  Future<http.Response> handle(http.Request request) async {
    requests.add(request);
    final path = request.url.path.replaceFirst('/api/v1', '');
    if (unauthorized && path == '/me')
      return http.Response(
        jsonEncode({
          'error': {'message': 'Session expired'},
        }),
        401,
      );
    if (fail)
      return http.Response(
        jsonEncode({
          'error': {'message': 'Server unavailable'},
        }),
        503,
      );
    dynamic data;
    if (path == '/uploads/videos') {
      data = {'url': '/api/v1/evidence/bbbbbbbbbbbbbbbbbbbbbbbb.mp4'};
    } else if (path == '/uploads') {
      data = {'url': '/media/aaaaaaaaaaaaaaaaaaaaaaaa.jpg'};
    } else if (path == '/auth/otp') {
      data = {'developmentCode': '123456', 'expiresIn': 300};
    } else if (path == '/auth/verify') {
      data = {'token': 'test-token', 'user': user};
    } else if (path == '/auth/logout') {
      data = {'loggedOut': true};
    } else if (path == '/me') {
      if (request.method == 'PATCH')
        user.addAll(Map<String, dynamic>.from(jsonDecode(request.body)));
      data = user;
    } else if (path.startsWith('/listings/') && request.method == 'PATCH') {
      listing.addAll(Map<String, dynamic>.from(jsonDecode(request.body)));
      data = listing;
    } else if (path == '/bookings/quote') {
      data = {
        'rental_paise': 48000,
        'fee_paise': 3000,
        'deposit_paise': 300000,
        'total_paise': 351000,
        'hours': 4,
      };
    } else if (path == '/bookings' && request.method == 'POST') {
      final body = jsonDecode(request.body);
      data = {
        'id': 'booking',
        'listing_id': 'listing',
        'listing': listing,
        'renter_id': 'renter',
        'owner_id': 'host',
        'renter_name': user['name'],
        'owner_name': 'API Host',
        'start_at':
            DateTime.parse(body['start']).millisecondsSinceEpoch ~/ 1000,
        'end_at': DateTime.parse(body['end']).millisecondsSinceEpoch ~/ 1000,
        'status': 'requested',
        'rental_paise': 48000,
        'fee_paise': 3000,
        'deposit_paise': 300000,
        'renter_signed': 0,
        'owner_signed': 0,
        'inspections': <dynamic>[],
      };
      bookings.add(Map<String, dynamic>.from(data));
    } else if (path == '/bookings/booking') {
      data = bookings.first;
    } else {
      data = {
        'items': switch (path) {
          '/listings' => [listing],
          '/me/listings' => ownListings,
          '/bookings' => bookings,
          _ => <dynamic>[],
        },
        'limit': 100,
        'offset': 0,
      };
    }
    return http.Response(
      jsonEncode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  Future<void> signIn() =>
      state.signIn('+919876543210', '123456', 'API Member');
}
