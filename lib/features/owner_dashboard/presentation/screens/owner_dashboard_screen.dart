import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/listing_creation/presentation/screens/create_listing_wizard_screen.dart';
import 'package:aay_plus/features/booking/presentation/screens/owner_request_approval_screen.dart';
import 'package:aay_plus/features/return_process/presentation/screens/return_inspection_screen.dart';
import 'package:aay_plus/features/claims_disputes/presentation/screens/admin_dispute_screen.dart';
import 'package:aay_plus/features/rental_passport/presentation/screens/rental_passport_screen.dart';
import 'package:aay_plus/features/owner_dashboard/presentation/screens/owner_inventory_screen.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final activeBooking = state.activeBooking;
    final pendingBooking = state.pendingBookingRequest;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.amberLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.amberBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storefront_rounded,
                  size: 14,
                  color: AppColors.amberDeep,
                ),
                const SizedBox(width: 5),
                Text(
                  'HOST PORTAL',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.amberDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Switch to Renter Mode Toggle
          GestureDetector(
            onTap: () {
              state.setRole(UserRoleMode.renter);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Switched to Renter Mode 🎒 — Browse, book & track rentals with escrow protection.'),
                  backgroundColor: AppColors.primaryNavy,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceNavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderNavy),
              ),
              child: Row(
                children: [
                  const Text('🔑', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 4),
                  Text(
                    'Host',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.amberDeep,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(width: 1, height: 11, color: AppColors.borderNavy),
                  const SizedBox(width: 5),
                  const Icon(Icons.swap_horiz_rounded, size: 14, color: AppColors.textPrimary),
                  const SizedBox(width: 2),
                  Text(
                    'Renter',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Earnings Analytics Hero Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.surfaceNavy, AppColors.cardNavy],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.amberBorder),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Lifetime Earnings',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹34,800',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.amberDeep,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.trending_up_rounded,
                                  color: AppColors.success,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '+18.4% this month',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.borderNavy, height: 1),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCol(
                              'Available Payout',
                              '₹12,400',
                              AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: AppColors.borderNavy,
                          ),
                          Expanded(
                            child: _buildMetricCol(
                              'Escrow Held Safe',
                              '₹15,000',
                              AppColors.success,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: AppColors.borderNavy,
                          ),
                          Expanded(
                            child: _buildMetricCol(
                              'Host Rating',
                              '⭐ 4.9',
                              AppColors.amberDeep,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Quick Action: + Create Listing CTA Button
                CustomButton(
                  text: '+ List Another Item for Rent',
                  icon: Icons.add_circle_outline_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateListingWizardScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Section 1: Pending Rental Requests (Crucial for Owner)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pending Booking Requests',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const StatusBadge(
                      text: '1 Waiting Approval',
                      color: AppColors.warning,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Incoming Booking Request Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.amberBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              pendingBooking.item.photos.first,
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pendingBooking.item.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Schedule: Today, 3 PM - 10 PM (7 hrs)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Renter: ${pendingBooking.renterName} ⭐ ${pendingBooking.renterRating} (${pendingBooking.renterCompletedRentals} rentals)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.amberDeep,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.borderNavy, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payout Earning',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                '₹${pendingBooking.rentalAmount.toInt()}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.success,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryNavy,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            icon: const Icon(
                              Icons.visibility_rounded,
                              size: 16,
                            ),
                            label: Text(
                              'Review Request',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OwnerRequestApprovalScreen(
                                    booking: pendingBooking,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 2: Active Items on Rental Handover
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live Rentals in Progress',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const StatusBadge(
                      text: '🟢 Custody Transferred',
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderNavy),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.two_wheeler_rounded,
                              color: AppColors.success,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeBooking.item.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Rented to Amit Saxena • Scheduled Return: 6:00 PM',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.amberBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  color: AppColors.amberDeep,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Rental Passport Sealed',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RentalPassportScreen(
                                      booking: activeBooking,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'View Docket →',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.amberDeep,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.borderMedium,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              icon: const Icon(
                                Icons.phone_outlined,
                                size: 15,
                                color: AppColors.textPrimary,
                              ),
                              label: Text(
                                'Contact Renter',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.surfaceNavy,
                                foregroundColor: AppColors.amberDeep,
                                side: const BorderSide(
                                  color: AppColors.amberBorder,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              icon: const Icon(
                                Icons.assignment_return_rounded,
                                size: 15,
                              ),
                              label: Text(
                                'Inspect Return',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReturnInspectionScreen(
                                      booking: activeBooking,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 3: My Inventory Listings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Active Listings (${state.items.length})',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateListingWizardScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '+ Add New',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.amberDeep,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ...state.items.take(3).map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceNavy,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderNavy),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.photos.first,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${item.hourlyPrice.toInt()}/hr • ₹${item.dailyPrice.toInt()}/day',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.amberDeep,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Deposit: ₹${item.securityDeposit.toInt()} • ${item.condition}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: item.isAvailable,
                          activeThumbColor: AppColors.primaryNavy,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (val) {},
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderMedium),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.textPrimary),
                    label: Text(
                      'View & Manage All ${state.items.length} Inventory Items →',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OwnerInventoryScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Section 4: Dispute / Incident Monitoring
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.dangerBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.gavel_rounded,
                          color: AppColors.danger,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dispute Arbitration Dossier #10231',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Claim of ₹2,000 for right side dent backed by 30s handover video.',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.amberDeep,
                          size: 16,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminDisputeScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, Color col) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: col,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
