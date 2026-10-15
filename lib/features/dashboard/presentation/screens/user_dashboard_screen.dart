import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/active_rental/presentation/screens/active_rental_screen.dart';
import 'package:aay_plus/features/claims_disputes/presentation/screens/admin_dispute_screen.dart';
import 'package:aay_plus/features/settlement/presentation/screens/cancellation_policy_screen.dart';
import 'package:aay_plus/features/rental_passport/presentation/screens/rental_passport_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  final int initialTab;

  const UserDashboardScreen({super.key, this.initialTab = 0});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  int _rentalSubFilter = 0; // 0: Active (1), 1: Upcoming (0), 2: Completed (14), 3: Disputes (1)

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final user = state.currentUser;

    final subFilters = ['Active (1)', 'Upcoming (0)', 'Completed (2)', 'Disputes (1)'];

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
                  Icons.calendar_month_rounded,
                  size: 14,
                  color: AppColors.amberDeep,
                ),
                const SizedBox(width: 5),
                Text(
                  'MY RENTALS',
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
          // Clear Switch to Host Mode Button
          GestureDetector(
            onTap: () {
              state.setRole(UserRoleMode.owner);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Switched to Host Mode 🔑 — Manage your listings, earnings & booking approvals.'),
                  backgroundColor: AppColors.primaryNavy,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceNavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderNavy),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎒', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 3),
                  Text(
                    'Renter',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.amberDeep,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 11, color: AppColors.borderNavy),
                  const SizedBox(width: 4),
                  const Icon(Icons.swap_horiz_rounded, size: 14, color: AppColors.textPrimary),
                  const SizedBox(width: 2),
                  Text(
                    'Host',
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
          IconButton(
            icon: const Icon(Icons.policy_outlined, color: AppColors.textPrimary, size: 20),
            tooltip: 'Cancellation Policy',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CancellationPolicyScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              // Renter Profile & Escrow Protection Banner
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderNavy),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(user.avatarUrl),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.name,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified_rounded, color: AppColors.success, size: 15),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: AppColors.amberDark, size: 15),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${user.rating} ',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '• Verified Renter • ${user.completedRentals} Completed Trips',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.cardNavy,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Active Escrow Deposit',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '₹3,000 (Protected)',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.success,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.cardNavy,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Safety Protection',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'AayPlus Shield 🛡️',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.amberDeep,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Pills
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: subFilters.length,
                  separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSel = _rentalSubFilter == index;
                    return FilterChip(
                      label: Text(subFilters[index]),
                      selected: isSel,
                      selectedColor: AppColors.amberLight,
                      backgroundColor: AppColors.surfaceNavy,
                      labelStyle: GoogleFonts.plusJakartaSans(
                        color: isSel ? AppColors.amberDeep : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSel ? AppColors.amberBorder : AppColors.borderNavy,
                      ),
                      onSelected: (_) => setState(() => _rentalSubFilter = index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Renter Content View
              Expanded(
                child: _buildRenterContent(context, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRenterContent(BuildContext context, AppStateProvider state) {
    if (_rentalSubFilter == 2) {
      // Completed rentals view
      final completed = state.completedRenterBookings;
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: completed.length,
        itemBuilder: (context, i) {
          final b = completed[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceNavy,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderNavy),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    b.item.photos.first,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.item.title,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Completed • Deposit ₹${(b.depositRefunded ?? b.securityDeposit).toInt()} Refunded ✓',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Host: ${b.item.ownerName} • Total: ₹${b.totalPayable.toInt()}',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const StatusBadge(text: 'Returned', color: AppColors.success),
              ],
            ),
          );
        },
      );
    }

    if (_rentalSubFilter == 1) {
      // Upcoming rentals view
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_available_rounded, size: 48, color: AppColors.amberDeep),
              const SizedBox(height: 12),
              Text(
                'No Upcoming Rentals',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Browse items in the Explore tab to schedule future rentals.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Active & Disputes view (default or when 0 or 3 selected)
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        if (_rentalSubFilter == 0) ...[
          // Active Booking Item Card
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking #${state.activeBooking.id}',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const StatusBadge(text: 'ACTIVE RENTAL 🟢', color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        state.activeBooking.item.photos.first,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.activeBooking.item.title,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Host: ${state.activeBooking.item.ownerName} • 10 Oct, 2 PM - 6 PM',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: AppColors.borderNavy, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deposit in Escrow',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '₹${state.activeBooking.securityDeposit.toInt()} (Safe)',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.success,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.amberBorder),
                            backgroundColor: AppColors.amberLight,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.verified_user_rounded, color: AppColors.amberDeep, size: 15),
                          label: Text(
                            'Passport',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.amberDeep,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RentalPassportScreen(booking: state.activeBooking),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryNavy,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.timer_outlined, size: 15),
                          label: Text(
                            'Track Live',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ActiveRentalScreen(booking: state.activeBooking),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Dispute Item Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceNavy,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dispute #CLM-10231',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const StatusBadge(text: 'Under Arbitration ⚖️', color: AppColors.danger),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Right Side Guard Dent Claim (₹2,000)',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Video timeline submitted to AayPlus admin arbitration panel. Escrow deposit protected.',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderMedium),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminDisputeScreen()),
                  );
                },
                child: Text(
                  'View Arbitration Dossier',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryNavy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
