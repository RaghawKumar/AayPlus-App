import 'package:flutter/material.dart';
import '../logging/dev_log.dart';
import '../models/models.dart';
import '../network/api_client.dart';

class AppStateProvider extends ChangeNotifier {
  final ApiClient api;
  AppStateProvider({ApiClient? api}) : api = api ?? ApiClient();
  UserRoleMode _currentRole = UserRoleMode.renter;
  UserRoleMode get currentRole => _currentRole;
  void toggleRole() => setRole(
    _currentRole == UserRoleMode.renter
        ? UserRoleMode.owner
        : UserRoleMode.renter,
  );
  void setRole(UserRoleMode role) {
    DevLog.action('Switch to ${role.name} mode');
    _currentRole = role;
    notifyListeners();
  }

  Map<String, dynamic>? user;
  bool get signedIn => user != null && api.token != null;
  bool busy = false;
  String? error;
  bool _disposed = false;
  int _session = 0;
  Future<void>? _refreshing;
  List<Map<String, dynamic>> listingRows = [],
      ownListingRows = [],
      bookingRows = [],
      disputeRows = [],
      ledgerRows = [];
  UserProfile get currentUser => UserProfile(
    id: user?['id'] ?? '',
    name: user?['name'] ?? '',
    email: user?['email'] ?? '',
    phone: user?['phone'] ?? '',
    avatarUrl: '',
    rating: 0,
    completedRentals: bookingRows
        .where((b) => b['status'] == 'completed')
        .length,
    cancelledRentals: bookingRows
        .where((b) => b['status'] == 'cancelled')
        .length,
    mobileVerified: signedIn,
    emailVerified: false,
    identityVerified: user?['kyc_status'] == 'verified',
    walletBalance: 0,
  );
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<Map<String, dynamic>> requestOtp(String phone) async =>
      Map<String, dynamic>.from(
        await api.request('/auth/otp', method: 'POST', body: {'phone': phone}),
      );
  Future<void> signIn(String phone, String code, String name) async {
    final result = await api.request(
      '/auth/verify',
      method: 'POST',
      body: {'phone': phone, 'code': code, 'name': name},
    );
    ++_session;
    api.token = result['token'];
    user = Map<String, dynamic>.from(result['user']);
    error = null;
    _notify();
    await refresh();
  }

  Future<void> signOut() async {
    try {
      if (api.token != null)
        await api.request('/auth/logout', method: 'POST', body: {});
    } finally {
      _clearSession();
    }
  }

  void _clearSession() {
    ++_session;
    api.token = null;
    user = null;
    listingRows = [];
    ownListingRows = [];
    bookingRows = [];
    disputeRows = [];
    ledgerRows = [];
    _currentRole = UserRoleMode.renter;
    _notify();
  }

  Future<void> refresh() {
    return _refreshing ??= _load().whenComplete(() => _refreshing = null);
  }

  Future<void> _load() async {
    final session = _session;
    busy = true;
    error = null;
    _notify();
    try {
      final values = await Future.wait<dynamic>([
        api.collection('/listings'),
        if (signedIn) ...[
          api.request('/me'),
          api.collection('/me/listings'),
          api.collection('/bookings'),
          api.collection('/disputes'),
          api.collection('/ledger'),
        ],
      ]);
      if (_disposed || session != _session) return;
      listingRows = values[0];
      if (values.length > 1) {
        user = values[1];
        ownListingRows = values[2];
        bookingRows = values[3];
        disputeRows = values[4];
        ledgerRows = values[5];
      }
    } on ApiException catch (e) {
      if (session == _session) {
        error = e.message;
        if (e.status == 401) _clearSession();
      }
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<dynamic> mutate(
    String path,
    Map<String, dynamic> data, {
    String method = 'POST',
  }) async {
    final result = await api.request(path, method: method, body: data);
    // Do not reuse a poll that started before the write.
    await _refreshing;
    await refresh();
    return result;
  }

  Future<void> updateProfile(UserProfile profile) async {
    await mutate('/me', {
      'name': profile.name,
      'email': profile.email,
    }, method: 'PATCH');
  }

  String _selectedCategory = 'All',
      _searchQuery = '',
      _selectedLocation = 'Nearby';
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get selectedLocation => _selectedLocation;
  DateTime _rentalStartDate = DateTime.now().add(const Duration(hours: 2));
  DateTime _rentalEndDate = DateTime.now().add(const Duration(hours: 6));
  DateTime get rentalStartDate => _rentalStartDate;
  DateTime get rentalEndDate => _rentalEndDate;
  void setCategory(String value) {
    _selectedCategory = value;
    _notify();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    _notify();
  }

  void setLocation(String value) {
    _selectedLocation = value;
    _notify();
  }

  void setDates(DateTime start, DateTime end) {
    _rentalStartDate = start;
    _rentalEndDate = end;
    _notify();
  }

  static RentalItem itemFromApi(Map<String, dynamic> row) => RentalItem(
    id: row['id'],
    title: row['title'],
    category: row['category'],
    subcategory: '',
    brand: '',
    model: '',
    year: 0,
    description: row['description'],
    condition: '',
    serialNumber: '',
    hourlyPrice: (row['hourly_paise'] as num) / 100,
    dailyPrice: (row['daily_paise'] as num) / 100,
    weeklyPrice: (row['weekly_paise'] as num) / 100,
    securityDeposit: (row['deposit_paise'] as num) / 100,
    approxLocation: row['location'],
    exactLocation: row['location'],
    ownerId: row['owner_id'],
    ownerName: row['owner_name'] ?? 'Host',
    ownerRating: 0,
    ownerCompletedRentals: 0,
    features: [],
    photos: List<String>.from(row['photos']),
    rating: 0,
    reviewsCount: 0,
    distanceKm: 0,
    isAvailable: row['active'] == true || row['active'] == 1,
  );
  List<RentalItem> get items => listingRows.map(itemFromApi).toList();
  // Compatibility adapters for older presentation components; the connected shell uses API rows.
  List<Booking> get bookings => bookingRows.map((row) {
    final rent = (row['rental_paise'] as num) / 100,
        fee = (row['fee_paise'] as num) / 100,
        deposit = (row['deposit_paise'] as num) / 100;
    return Booking(
      id: row['id'],
      item: itemFromApi(Map<String, dynamic>.from(row['listing'])),
      renterId: row['renter_id'],
      renterName: row['renter_name'] ?? '',
      renterRating: 0,
      renterCompletedRentals: 0,
      startTime: DateTime.fromMillisecondsSinceEpoch(row['start_at'] * 1000),
      returnTime: DateTime.fromMillisecondsSinceEpoch(row['end_at'] * 1000),
      rentalAmount: rent,
      platformFee: fee,
      securityDeposit: deposit,
      totalPayable: rent + fee + deposit,
      status: switch (row['status']) {
        'approved' => BookingStatus.confirmed,
        'active' => BookingStatus.active,
        'return_review' => BookingStatus.returned,
        'disputed' => BookingStatus.disputed,
        'completed' => BookingStatus.completed,
        'cancelled' || 'rejected' => BookingStatus.cancelled,
        _ => BookingStatus.requested,
      },
      agreementAcceptedOwner: row['owner_signed'] == 1,
      agreementAcceptedRenter: row['renter_signed'] == 1,
    );
  }).toList();
  String? _selectedBookingId;
  Booking get activeBooking => bookings.firstWhere(
    (b) => b.id == _selectedBookingId,
    orElse: () => bookings.first,
  );
  Booking get pendingBookingRequest => bookings.firstWhere(
    (b) =>
        b.item.ownerId == currentUser.id && b.status == BookingStatus.requested,
  );
  List<Booking> get completedRenterBookings => bookings
      .where(
        (b) =>
            b.renterId == currentUser.id && b.status == BookingStatus.completed,
      )
      .toList();
  List<DamageClaim> get claims => disputeRows.map((row) {
    final matches = bookingRows.where((b) => b['id'] == row['booking_id']);
    final booking = matches.isEmpty ? null : matches.first;
    return DamageClaim(
      id: row['id'],
      bookingId: row['booking_id'],
      itemTitle: booking?['listing']?['title'] ?? '',
      ownerName: booking?['owner_name'] ?? '',
      renterName: booking?['renter_name'] ?? '',
      category: '',
      description: row['description'],
      claimAmount: (row['claim_paise'] as num) / 100,
      evidencePhoto: '',
      evidenceVideo: '',
      status: row['status'] == 'resolved'
          ? ClaimStatus.resolvedAdmin
          : row['response'] == null
          ? ClaimStatus.submitted
          : ClaimStatus.disputedByRenter,
      adminResolution: row['notes'],
      settledAmount: row['settlement_paise'] == null
          ? null
          : (row['settlement_paise'] as num) / 100,
    );
  }).toList();
  Future<void> addListing(RentalItem item) async {
    await mutate('/listings', {
      'title': item.title,
      'category': item.category,
      'description': item.description,
      'location': item.approxLocation,
      'hourly_paise': (item.hourlyPrice * 100).round(),
      'daily_paise': (item.dailyPrice * 100).round(),
      'weekly_paise': (item.weeklyPrice * 100).round(),
      'deposit_paise': (item.securityDeposit * 100).round(),
      'photos': item.photos,
    });
  }

  Future<void> createBooking({
    required RentalItem item,
    required DateTime start,
    required DateTime end,
    required double rentalAmount,
    required double platformFee,
    required double deposit,
  }) async {
    final row = await mutate('/bookings', {
      'listing_id': item.id,
      'start': start.toUtc().toIso8601String(),
      'end': end.toUtc().toIso8601String(),
    });
    _selectedBookingId = row['id'];
  }

  Future<void> updateBookingStatus(String bid, BookingStatus status) async {
    await mutate(
      '/bookings/$bid/${status == BookingStatus.confirmed ? 'approve' : 'cancel'}',
      {},
    );
  }

  Future<void> acceptAgreement({required bool isOwner}) async {
    await mutate('/bookings/${activeBooking.id}/sign', {});
  }

  Future<void> confirmPickupInspection() => Future.error(
    const ApiException(
      'Record inspection evidence from the connected Rentals screen.',
    ),
  );
  Future<void> confirmReturnInspection() => Future.error(
    const ApiException(
      'Record inspection evidence from the connected Rentals screen.',
    ),
  );
  Future<void> submitDamageClaim({
    required String description,
    required double amount,
    required String category,
  }) async {
    await mutate('/bookings/${activeBooking.id}/claim', {
      'description': description,
      'claim_paise': (amount * 100).round(),
    });
  }

  Future<void> renterRespondToClaim(String claimId, bool accept) async {
    await mutate('/disputes/$claimId/response', {
      'response': accept
          ? 'I accept this claim for administrator review.'
          : 'I dispute this claim and request review.',
    });
  }

  Future<void> adminResolveDispute(
    String claimId,
    String decision,
    double settledAmount,
  ) async {
    await mutate('/admin/disputes/$claimId/resolve', {
      'settlement_paise': (settledAmount * 100).round(),
      'notes': decision,
    });
  }

  @override
  void dispose() {
    _disposed = true;
    api.close();
    super.dispose();
  }
}
