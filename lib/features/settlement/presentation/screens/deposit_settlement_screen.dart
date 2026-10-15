import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/rating/presentation/screens/rating_review_screen.dart';
import 'package:aay_plus/features/rental_passport/presentation/screens/rental_passport_screen.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class DepositSettlementScreen extends StatelessWidget {
  final Booking booking;
  final double damageDeduction;
  final double lateFee;

  const DepositSettlementScreen({
    super.key,
    required this.booking,
    this.damageDeduction = 2000.0,
    this.lateFee = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final originalDeposit = booking.securityDeposit;
    final totalDeductions = damageDeduction + lateFee;
    final finalRefund = originalDeposit - totalDeductions;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        title: const Text('Deposit Settlement Ledger'),
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
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Settlement Complete Banner
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                color: AppColors.successLight,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.success, width: 2),
                              ),
                              child: const Icon(Icons.check_rounded, color: AppColors.success, size: 38),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Rental Closed & Settled',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Escrow account reconciled successfully',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Refund Highlight Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.surfaceNavy, AppColors.cardNavy],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.amberBorder),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Net Refund Dispatched to Renter',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹${finalRefund.toInt()}',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.amberDeep,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Credited to original payment method (Instant UPI / 24-48 hrs for card)',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Reconciled Statement Breakdown
                      Text(
                        'Reconciliation Breakdown',
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
                            _buildLedgerRow('Original Security Deposit Held', '+₹${originalDeposit.toInt()}', isPositive: true),
                            const Divider(color: AppColors.borderNavy),
                            if (damageDeduction > 0) ...[
                              _buildLedgerRow('Settled Damage Compensation', '-₹${damageDeduction.toInt()}', isNegative: true),
                              const Divider(color: AppColors.borderNavy),
                            ],
                            if (lateFee > 0) ...[
                              _buildLedgerRow('Late Return Fee', '-₹${lateFee.toInt()}', isNegative: true),
                              const Divider(color: AppColors.borderNavy),
                            ] else ...[
                              _buildLedgerRow('Late Return Penalty (Returned on-time)', '₹0 (Grace Period 15 min applied)'),
                              const Divider(color: AppColors.borderNavy),
                            ],
                            _buildLedgerRow('Host Payout for Damage Claim', '₹${damageDeduction.toInt()} to Host ${booking.item.ownerName}'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(color: AppColors.amberBorder, thickness: 1.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Net Refund to Renter (${booking.renterName})',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '₹${finalRefund.toInt()}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.success,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Late Return Rules Reference Box (Section 26)
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
                                const Icon(Icons.access_time_filled_rounded, color: AppColors.amberDeep, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Late Return Policy Schedule',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildLateRule('0–15 min', 'Grace period (No charge)'),
                            _buildLateRule('15–60 min', 'Flat ₹200 Late fee'),
                            _buildLateRule('> 60 min', 'Full additional hourly rate × 1.5x'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rental Passport Sealed Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.amberBorder),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.amberLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.verified_user_rounded, color: AppColors.amberDeep, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'RENTAL PASSPORT',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const StatusBadge(text: 'Released', color: AppColors.success),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Complete Pickup & Return verification docket',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RentalPassportScreen(booking: booking),
                                  ),
                                );
                              },
                              child: Text(
                                'View',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.amberDeep,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Rate & Close Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: CustomButton(
                  text: 'Rate Host & Complete Experience',
                  icon: Icons.star_rate_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RatingReviewScreen(booking: booking),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLedgerRow(String title, String amount, {bool isPositive = false, bool isNegative = false}) {
    Color col = AppColors.textPrimary;
    if (isPositive) col = AppColors.success;
    if (isNegative) col = AppColors.danger;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: Text(
              amount,
              textAlign: TextAlign.end,
              style: GoogleFonts.plusJakartaSans(
                color: col,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLateRule(String time, String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(time, style: GoogleFonts.plusJakartaSans(color: AppColors.amberDeep, fontSize: 12, fontWeight: FontWeight.w700)),
          Text(rule, style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
