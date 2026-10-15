import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class RentalPassportScreen extends StatelessWidget {
  final Booking booking;

  const RentalPassportScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final passport = RentalPassport.fromBooking(booking);
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                (route) => false,
              );
            }
          },
        ),
        title: const Text('Rental Passport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            tooltip: 'Share Passport',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rental Passport ${passport.bookingId} copied to clipboard.'),
                  backgroundColor: AppColors.primaryNavy,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      // Official Passport Docket Document
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.amberBorder, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowMedium,
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Passport Top Header Ribbon
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryNavy,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.amberLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(Icons.verified_user_rounded, color: AppColors.amberDeep, size: 20),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'RENTAL PASSPORT',
                                                style: GoogleFonts.plusJakartaSans(
                                                  color: AppColors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                              Text(
                                                'AayPlus Verified P2P Handover Docket',
                                                style: GoogleFonts.plusJakartaSans(
                                                  color: AppColors.amberGlow,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                        ),
                                        child: Text(
                                          passport.bookingId,
                                          style: GoogleFonts.jetBrainsMono(
                                            color: AppColors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Main Details Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Item & Parties Block
                                  _buildItemAndPartiesBlock(passport),
                                  const SizedBox(height: 20),
                                  _buildDivider(),
                                  const SizedBox(height: 20),

                                  // PICKUP Section
                                  _buildSectionHeader(
                                    title: 'PICKUP HANDOVER',
                                    icon: Icons.login_rounded,
                                    badgeText: 'Verified',
                                    badgeColor: AppColors.success,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPickupContent(passport, dateFormat, timeFormat),
                                  const SizedBox(height: 20),
                                  _buildDivider(),
                                  const SizedBox(height: 20),

                                  // RETURN Section
                                  _buildSectionHeader(
                                    title: 'RETURN HANDOVER',
                                    icon: Icons.logout_rounded,
                                    badgeText: passport.returnConditionStatus,
                                    badgeColor: passport.returnDate != null ? AppColors.success : AppColors.info,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildReturnContent(passport, dateFormat, timeFormat),
                                  const SizedBox(height: 20),
                                  _buildDivider(),
                                  const SizedBox(height: 20),

                                  // SECURITY DEPOSIT Section
                                  _buildSectionHeader(
                                    title: 'SECURITY DEPOSIT ESCROW',
                                    icon: Icons.shield_rounded,
                                    badgeText: passport.depositStatus,
                                    badgeColor: passport.depositStatus == 'Released' ? AppColors.success : AppColors.amberDeep,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDepositContent(passport),
                                  const SizedBox(height: 20),
                                  _buildDivider(),
                                  const SizedBox(height: 20),

                                  // Category-Specific Phase 1 Rules
                                  _buildCategoryRulesSection(passport),
                                  const SizedBox(height: 24),

                                  // Security Seal & Digital Hash Stamp
                                  _buildDigitalSecurityStamp(passport),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Actions Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Download PDF',
                        icon: Icons.download_rounded,
                        isOutlined: true,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Downloading official cryptographic PDF docket...'),
                              backgroundColor: AppColors.primaryNavy,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Close Docket',
                        icon: Icons.check_circle_outline_rounded,
                        onPressed: () => Navigator.pop(context),
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

  Widget _buildItemAndPartiesBlock(RentalPassport passport) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderNavy),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      passport.itemTitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.amberBorder),
                ),
                child: Text(
                  passport.itemCategory,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.amberDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildPartyTile(label: 'Owner', name: passport.ownerName, icon: Icons.person_outline_rounded),
              ),
              Container(width: 1, height: 36, color: AppColors.borderNavy),
              Expanded(
                child: _buildPartyTile(label: 'Renter', name: passport.renterName, icon: Icons.person_pin_circle_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartyTile({required String label, required String name, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 13),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.amberDeep, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
          ),
          child: Text(
            badgeText,
            style: GoogleFonts.plusJakartaSans(
              color: badgeColor,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickupContent(RentalPassport passport, DateFormat dateFormat, DateFormat timeFormat) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderNavy),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetaTile('Date', dateFormat.format(passport.pickupDate)),
              _buildMetaTile('Time', timeFormat.format(passport.pickupDate)),
              _buildMetaTile('Evidence', '📷 ${passport.pickupPhotosCount} Photos • 🎥 ${passport.pickupVideosCount} Video'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Condition Verified:',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: passport.pickupConditions.keys.map((key) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.successBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded, color: AppColors.success, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      key,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Declaration: ',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _buildDeclarationChip('Owner Signed ✓'),
              const SizedBox(width: 6),
              _buildDeclarationChip('Renter Signed ✓'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReturnContent(RentalPassport passport, DateFormat dateFormat, DateFormat timeFormat) {
    final hasReturn = passport.returnDate != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderNavy),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetaTile('Date', hasReturn ? dateFormat.format(passport.returnDate!) : 'In Progress'),
              _buildMetaTile('Time', hasReturn ? timeFormat.format(passport.returnDate!) : 'Scheduled 6:00 PM'),
              _buildMetaTile('Evidence', hasReturn ? '📷 ${passport.returnPhotosCount} Photos • 🎥 ${passport.returnVideosCount} Video' : 'Pending Return'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Condition: ',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: hasReturn ? AppColors.successLight : AppColors.infoLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: hasReturn ? AppColors.successBorder : AppColors.infoBorder),
                ),
                child: Text(
                  hasReturn ? '✓ ${passport.returnConditionStatus}' : '⏳ Handover In Progress',
                  style: GoogleFonts.plusJakartaSans(
                    color: hasReturn ? AppColors.success : AppColors.info,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepositContent(RentalPassport passport) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderNavy),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security Deposit Amount',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${passport.securityDeposit.toInt()}',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.amberDeep,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: passport.depositStatus == 'Released' ? AppColors.successLight : AppColors.warningLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: passport.depositStatus == 'Released' ? AppColors.successBorder : AppColors.warningBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  passport.depositStatus == 'Released' ? Icons.check_circle_rounded : Icons.lock_clock_rounded,
                  color: passport.depositStatus == 'Released' ? AppColors.success : AppColors.amberDeep,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Status: ${passport.depositStatus}',
                  style: GoogleFonts.plusJakartaSans(
                    color: passport.depositStatus == 'Released' ? AppColors.success : AppColors.amberDeep,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRulesSection(RentalPassport passport) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phase 1 Category Rule Compliance (${passport.itemCategory}):',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: passport.categoryRules.map((rule) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rule,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDigitalSecurityStamp(RentalPassport passport) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.elevatedNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderNavy),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.qr_code_2_rounded, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Passport Seal: ${passport.passportId}',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.lock_rounded, color: AppColors.success, size: 14),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Cryptographically sealed handover baseline • Verified by AayPlus Escrow Protocol',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildDeclarationChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.success,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.borderNavy);
  }
}
