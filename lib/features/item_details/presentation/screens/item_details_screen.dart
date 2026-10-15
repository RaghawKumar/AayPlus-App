import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/booking/presentation/screens/booking_calculation_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final RentalItem item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  int _selectedPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(item.brand),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColors.amberDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo Viewer
                      Stack(
                        children: [
                          SizedBox(
                            height: 260,
                            width: double.infinity,
                            child: Image.network(
                              item.photos[_selectedPhotoIndex % item.photos.length],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.cardNavy,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported_rounded, color: AppColors.textMuted, size: 50),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_selectedPhotoIndex + 1}/${item.photos.length} Multi-angle Photos',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Multi-angle Photo Thumbnails (Front, Back, Left, Right, Closeup, Serial)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Row(
                          children: [
                            for (int i = 0; i < item.photos.length; i++)
                              GestureDetector(
                                onTap: () => setState(() => _selectedPhotoIndex = i),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _selectedPhotoIndex == i ? AppColors.amberAccent : AppColors.borderNavy,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(item.photos[i]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceNavy,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.borderNavy),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.qr_code_2_rounded, color: AppColors.amberAccent, size: 20),
                                  Text(
                                    'Serial Verified',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Title & Category
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.subcategory} • Year ${item.year}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    item.condition,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Rating & Distance Bar
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppColors.amberDark, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.rating}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ' (${item.reviewsCount} completed rentals)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.place_rounded, color: AppColors.textMuted, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.distanceKm} km away',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Pricing Models Box
                            Text(
                              'Rental Pricing Structure',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildPriceBox('Hourly', '₹${item.hourlyPrice.toInt()}', '/hr'),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildPriceBox('Daily (Popular)', '₹${item.dailyPrice.toInt()}', '/day', isPopular: true),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildPriceBox('Weekly', '₹${item.weeklyPrice.toInt()}', '/wk'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Security Deposit Banner
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceNavy,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.amberBorder),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.amberLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.shield_rounded, color: AppColors.amberDeep, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Security Deposit: ',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.textSecondary,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '₹${item.securityDeposit.toInt()}',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.amberDeep,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '100% Refundable instantly upon return without new damage.',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textMuted,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Approximate Location Privacy Guard
                            Text(
                              'Pickup Location',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceNavy,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.borderNavy),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.lock_outline_rounded, color: AppColors.amberDark, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Approximate: ${item.approxLocation}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'To protect owner privacy, the exact address and landmark are disclosed after the booking is approved.',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Owner Profile Card
                            Text(
                              'Meet the Owner',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceNavy,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.borderNavy),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: AppColors.cardNavy,
                                    backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.ownerName,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: AppColors.amberDark, size: 16),
                                            Text(
                                              ' ${item.ownerRating} ',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.textPrimary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '• ${item.ownerCompletedRentals} rentals hosted',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const VerificationBadge(label: 'KYC ✓'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Features & Inclusions
                            Text(
                              'Included Features',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: item.features.map((feat) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                                      const SizedBox(width: 10),
                                      Text(
                                        feat,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),

                            // Description
                            Text(
                              'Description',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom CTA Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: const Border(top: BorderSide(color: AppColors.borderNavy)),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Starting at',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${item.hourlyPrice.toInt()}',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '/hr',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        text: 'Book Now',
                        icon: Icons.calendar_today_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingCalculationScreen(item: item),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceBox(String title, String price, String suffix, {bool isPopular = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isPopular ? AppColors.amberLight : AppColors.surfaceNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPopular ? AppColors.amberBorder : AppColors.borderNavy,
          width: isPopular ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: isPopular ? AppColors.amberDeep : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                suffix,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
