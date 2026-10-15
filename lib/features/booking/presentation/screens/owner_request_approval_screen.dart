import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/agreement/presentation/screens/digital_agreement_screen.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class OwnerRequestApprovalScreen extends StatefulWidget {
  final Booking booking;

  const OwnerRequestApprovalScreen({super.key, required this.booking});

  @override
  State<OwnerRequestApprovalScreen> createState() => _OwnerRequestApprovalScreenState();
}

class _OwnerRequestApprovalScreenState extends State<OwnerRequestApprovalScreen> {
  bool _isAccepting = false;
  bool _isRejecting = false;

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final item = booking.item;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: const Text('Owner Booking Request'),
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Incoming Alert Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.amberLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.amberBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_rounded, color: AppColors.amberDeep, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Rental Request Received!',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Please review the renter profile and schedule before accepting.',
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
                ),
                const SizedBox(height: 20),

                // Item & Schedule Card
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.photos.first,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Schedule: 10 Oct, 2:00 PM – 6:00 PM (4 hrs)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.amberDeep,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.borderNavy, height: 1),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Payout Earnings',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '₹${booking.rentalAmount.toInt()}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.success,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Security Deposit in Escrow',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '₹${booking.securityDeposit.toInt()}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.amberDeep,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Renter Reputation Profile Card
                Text(
                  'Renter Reputation & Profile',
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150'),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.renterName,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: AppColors.amberDeep, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${booking.renterRating}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '• ${booking.renterCompletedRentals} completed rentals',
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
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.borderNavy, height: 1),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          VerificationBadge(label: 'Mobile ✓', verified: true),
                          VerificationBadge(label: 'Aadhaar ID ✓', verified: true),
                          VerificationBadge(label: 'Driving License ✓', verified: true),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Acceptance Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Reject',
                        icon: Icons.close_rounded,
                        isOutlined: true,
                        isDanger: true,
                        isLoading: _isRejecting,
                        onPressed: () {
                          setState(() => _isRejecting = true);
                          Future.delayed(const Duration(milliseconds: 500), () {
                            context.read<AppStateProvider>().updateBookingStatus(booking.id, BookingStatus.cancelled);
                            setState(() => _isRejecting = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Booking request rejected. Payment refunded to renter.'),
                                backgroundColor: AppColors.danger,
                              ),
                            );
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: 'Accept Booking',
                        icon: Icons.check_circle_rounded,
                        isLoading: _isAccepting,
                        onPressed: () {
                          setState(() => _isAccepting = true);
                          Future.delayed(const Duration(milliseconds: 600), () {
                            context.read<AppStateProvider>().updateBookingStatus(booking.id, BookingStatus.confirmed);
                            setState(() => _isAccepting = false);
                            // Navigate to Digital Rental Agreement
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DigitalAgreementScreen(booking: booking),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
