enum UserRoleMode { renter, owner }

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final double rating;
  final int completedRentals;
  final int cancelledRentals;
  final bool mobileVerified;
  final bool emailVerified;
  final bool identityVerified;
  final double walletBalance;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.rating,
    required this.completedRentals,
    required this.cancelledRentals,
    this.mobileVerified = true,
    this.emailVerified = true,
    this.identityVerified = true,
    this.walletBalance = 14500.0,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    double? rating,
    int? completedRentals,
    int? cancelledRentals,
    bool? mobileVerified,
    bool? emailVerified,
    bool? identityVerified,
    double? walletBalance,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      completedRentals: completedRentals ?? this.completedRentals,
      cancelledRentals: cancelledRentals ?? this.cancelledRentals,
      mobileVerified: mobileVerified ?? this.mobileVerified,
      emailVerified: emailVerified ?? this.emailVerified,
      identityVerified: identityVerified ?? this.identityVerified,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}

class RentalItem {
  final String id;
  final String title;
  final String category;
  final String subcategory;
  final String brand;
  final String model;
  final int year;
  final String description;
  final String condition;
  final String serialNumber;
  final double hourlyPrice;
  final double dailyPrice;
  final double weeklyPrice;
  final double securityDeposit;
  final String approxLocation;
  final String exactLocation;
  final String ownerId;
  final String ownerName;
  final double ownerRating;
  final int ownerCompletedRentals;
  final List<String> features;
  final List<String> photos;
  final double rating;
  final int reviewsCount;
  final double distanceKm;
  final bool isAvailable;

  const RentalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.subcategory,
    required this.brand,
    required this.model,
    required this.year,
    required this.description,
    required this.condition,
    required this.serialNumber,
    required this.hourlyPrice,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.securityDeposit,
    required this.approxLocation,
    required this.exactLocation,
    required this.ownerId,
    required this.ownerName,
    required this.ownerRating,
    required this.ownerCompletedRentals,
    required this.features,
    required this.photos,
    required this.rating,
    required this.reviewsCount,
    required this.distanceKm,
    this.isAvailable = true,
  });
}

enum BookingStatus {
  requested,
  confirmed,
  active,
  returned,
  claimSubmitted,
  disputed,
  completed,
  cancelled,
}

class Booking {
  final String id;
  final RentalItem item;
  final String renterId;
  final String renterName;
  final double renterRating;
  final int renterCompletedRentals;
  final DateTime startTime;
  final DateTime returnTime;
  final double rentalAmount;
  final double platformFee;
  final double securityDeposit;
  final double totalPayable;
  BookingStatus status;
  bool agreementAcceptedOwner;
  bool agreementAcceptedRenter;
  bool pickupInspectionDone;
  bool returnInspectionDone;
  double? damageClaimAmount;
  double? depositRefunded;

  Booking({
    required this.id,
    required this.item,
    required this.renterId,
    required this.renterName,
    required this.renterRating,
    required this.renterCompletedRentals,
    required this.startTime,
    required this.returnTime,
    required this.rentalAmount,
    required this.platformFee,
    required this.securityDeposit,
    required this.totalPayable,
    this.status = BookingStatus.requested,
    this.agreementAcceptedOwner = false,
    this.agreementAcceptedRenter = false,
    this.pickupInspectionDone = false,
    this.returnInspectionDone = false,
    this.damageClaimAmount,
    this.depositRefunded,
  });

  int get durationHours => returnTime.difference(startTime).inHours;

  RentalPassport toRentalPassport() => RentalPassport.fromBooking(this);
}

class DamageTag {
  final String part;
  final String type; // Scratch, Dent, Crack, Broken part, Other
  final String description;
  final String? photoUrl;

  const DamageTag({
    required this.part,
    required this.type,
    required this.description,
    this.photoUrl,
  });
}

class InspectionRecord {
  final String bookingId;
  final String stage; // 'pickup' or 'return'
  final DateTime timestamp;
  final String gpsLocation;
  final Map<String, String> photoAngles; // Front, Left, Right, Rear, Dashboard, Tyres
  final List<DamageTag> damageTags;
  final bool videoWalkaroundRecorded;
  final bool ownerConfirmed;
  final bool renterConfirmed;

  const InspectionRecord({
    required this.bookingId,
    required this.stage,
    required this.timestamp,
    required this.gpsLocation,
    required this.photoAngles,
    required this.damageTags,
    this.videoWalkaroundRecorded = true,
    this.ownerConfirmed = true,
    this.renterConfirmed = true,
  });
}

enum ClaimStatus {
  submitted,
  acceptedByRenter,
  disputedByRenter,
  resolvedAdmin,
}

class DamageClaim {
  final String id;
  final String bookingId;
  final String itemTitle;
  final String ownerName;
  final String renterName;
  final String category;
  final String description;
  final double claimAmount;
  final String evidencePhoto;
  final String evidenceVideo;
  ClaimStatus status;
  String? adminResolution;
  double? settledAmount;

  DamageClaim({
    required this.id,
    required this.bookingId,
    required this.itemTitle,
    required this.ownerName,
    required this.renterName,
    required this.category,
    required this.description,
    required this.claimAmount,
    required this.evidencePhoto,
    required this.evidenceVideo,
    this.status = ClaimStatus.submitted,
    this.adminResolution,
    this.settledAmount,
  });
}

class RentalPassport {
  final String passportId;
  final String bookingId;
  final String itemTitle;
  final String itemCategory;
  final String ownerName;
  final String renterName;
  final DateTime pickupDate;
  final int pickupPhotosCount;
  final int pickupVideosCount;
  final Map<String, bool> pickupConditions;
  final bool pickupOwnerDeclared;
  final bool pickupRenterDeclared;
  final DateTime? returnDate;
  final int returnPhotosCount;
  final int returnVideosCount;
  final String returnConditionStatus;
  final double securityDeposit;
  final String depositStatus;
  final double? refundedAmount;
  final double? damageAmount;
  final List<String> categoryRules;

  const RentalPassport({
    required this.passportId,
    required this.bookingId,
    required this.itemTitle,
    required this.itemCategory,
    required this.ownerName,
    required this.renterName,
    required this.pickupDate,
    this.pickupPhotosCount = 8,
    this.pickupVideosCount = 1,
    required this.pickupConditions,
    this.pickupOwnerDeclared = true,
    this.pickupRenterDeclared = true,
    this.returnDate,
    this.returnPhotosCount = 8,
    this.returnVideosCount = 1,
    this.returnConditionStatus = 'Passed',
    required this.securityDeposit,
    this.depositStatus = 'Released',
    this.refundedAmount,
    this.damageAmount,
    required this.categoryRules,
  });

  static RentalPassport fromBooking(Booking booking) {
    final isReturned = booking.status == BookingStatus.returned ||
        booking.status == BookingStatus.completed ||
        booking.returnInspectionDone;

    List<String> rules;
    switch (booking.item.category.toLowerCase()) {
      case 'bikes':
        rules = [
          'Driving License verified',
          '2 ISI Helmets provided & inspected',
          'Fuel level recorded at handover',
          'RC & Insurance valid',
          'Traffic fines liability agreement signed',
        ];
        break;
      case 'cameras':
        rules = [
          'Serial number & lens mounts verified',
          'Sensor & viewfinder spotless check',
          'Shutter & autofocus test passed',
          'Battery & SD accessories confirmed',
        ];
        break;
      case 'electronics':
        rules = [
          'Serial & IMEI sticker cross-checked',
          'Battery health & charging cable verified',
          'Display & ports inspected for cracks',
          'Renter data-wipe acknowledgment signed',
        ];
        break;
      case 'parking':
        rules = [
          'Specific parking slot verified (Bay P2-44)',
          'Boom barrier RFID card / pass issued',
          'Entry & exit time windows confirmed',
          'Society security clearance documented',
        ];
        break;
      default:
        rules = [
          'Identification & KYC verified',
          'Condition checklist completed',
          'Mutual declaration executed',
        ];
    }

    return RentalPassport(
      passportId: 'PASSPORT-${booking.id.replaceAll('BK-', 'REN')}',
      bookingId: '#${booking.id.replaceAll('BK-', 'REN')}',
      itemTitle: booking.item.title,
      itemCategory: booking.item.category,
      ownerName: booking.item.ownerName.split(' ').first,
      renterName: booking.renterName.split(' ').first,
      pickupDate: booking.startTime,
      pickupPhotosCount: 8,
      pickupVideosCount: 1,
      pickupConditions: const {
        'Front': true,
        'Rear': true,
        'Left': true,
        'Right': true,
        'Engine / Components': true,
        'Tyres / Accessories': true,
      },
      pickupOwnerDeclared: booking.agreementAcceptedOwner,
      pickupRenterDeclared: booking.agreementAcceptedRenter,
      returnDate: isReturned ? booking.returnTime : null,
      returnPhotosCount: isReturned ? 8 : 0,
      returnVideosCount: isReturned ? 1 : 0,
      returnConditionStatus: booking.status == BookingStatus.completed
          ? 'Passed'
          : (booking.status == BookingStatus.claimSubmitted ? 'Claim In Review' : (isReturned ? 'Passed' : 'Active')),
      securityDeposit: booking.securityDeposit,
      depositStatus: booking.status == BookingStatus.completed
          ? 'Released'
          : (booking.status == BookingStatus.claimSubmitted ? 'In Escrow' : (isReturned ? 'Pending Release' : 'In Escrow')),
      refundedAmount: booking.depositRefunded ?? (booking.status == BookingStatus.completed ? booking.securityDeposit : null),
      damageAmount: booking.damageClaimAmount,
      categoryRules: rules,
    );
  }
}
