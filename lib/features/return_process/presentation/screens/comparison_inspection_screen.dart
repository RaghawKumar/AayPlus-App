import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/claims_disputes/presentation/screens/damage_claim_screen.dart';
import 'package:aay_plus/features/settlement/presentation/screens/deposit_settlement_screen.dart';
import 'package:aay_plus/features/rental_passport/presentation/screens/rental_passport_screen.dart';

class ComparisonInspectionScreen extends StatelessWidget {
  final Booking booking;

  const ComparisonInspectionScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Return Evidence Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_rounded, color: AppColors.amberDeep),
            tooltip: 'Rental Passport',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RentalPassportScreen(booking: booking),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Alert Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.dangerBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.report_problem_rounded, color: AppColors.danger, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Discrepancy Detected During Handover',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '1 new structural damage identified on Right Side that was not present at pickup.',
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
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Pickup Condition vs Return Condition',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Side-by-side Photo/Video Baseline vs Return Evidence Comparison',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 1: FRONT
                      _buildComparisonCard(
                        sectionTitle: 'Front Face & Headlamp',
                        pickupState: 'No damage recorded',
                        pickupStatusGood: true,
                        returnState: 'No damage detected',
                        returnStatusGood: true,
                        hasMismatch: false,
                        icon: Icons.two_wheeler_rounded,
                      ),
                      const SizedBox(height: 12),

                      // Card 2: LEFT SIDE
                      _buildComparisonCard(
                        sectionTitle: 'Left Side & Silencer Guard',
                        pickupState: 'Small superficial scratch (Logged)',
                        pickupStatusGood: false,
                        returnState: 'Small superficial scratch (Consistent)',
                        returnStatusGood: false,
                        hasMismatch: false,
                        icon: Icons.arrow_back_rounded,
                      ),
                      const SizedBox(height: 12),

                      // Card 3: RIGHT SIDE (NEW DAMAGE DETECTED)
                      _buildComparisonCard(
                        sectionTitle: 'Right Side & Fuel Guard',
                        pickupState: 'No damage recorded (Clean)',
                        pickupStatusGood: true,
                        returnState: 'Large dent & deep paint scratch ❌',
                        returnStatusGood: false,
                        hasMismatch: true,
                        icon: Icons.arrow_forward_rounded,
                      ),
                      const SizedBox(height: 12),

                      // Card 4: REAR & DASHBOARD
                      _buildComparisonCard(
                        sectionTitle: 'Rear Wheel & Dashboard',
                        pickupState: 'Clean / Odometer 12,450 km',
                        pickupStatusGood: true,
                        returnState: 'Clean / Odometer 12,492 km (+42 km)',
                        returnStatusGood: true,
                        hasMismatch: false,
                        icon: Icons.speed_rounded,
                      ),
                      const SizedBox(height: 24),

                      // Escrow Deposit Protection Box
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Security Deposit in Escrow',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
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
                            const SizedBox(height: 6),
                            Text(
                              'Funds remain securely frozen until either party confirms all-clear, or an estimated damage claim is settled.',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                height: 1.4,
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

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'Raise Damage Claim (₹2,000)',
                      icon: Icons.warning_rounded,
                      isDanger: true,
                      width: double.infinity,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DamageClaimScreen(booking: booking),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'No Claim • Release Full ₹3,000 Deposit',
                      icon: Icons.check_circle_rounded,
                      isOutlined: true,
                      width: double.infinity,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DepositSettlementScreen(
                              booking: booking,
                              damageDeduction: 0,
                              lateFee: 0,
                            ),
                          ),
                        );
                      },
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

  Widget _buildComparisonCard({
    required String sectionTitle,
    required String pickupState,
    required bool pickupStatusGood,
    required String returnState,
    required bool returnStatusGood,
    required bool hasMismatch,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hasMismatch ? AppColors.dangerLight : AppColors.surfaceNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasMismatch ? AppColors.dangerBorder : AppColors.borderNavy,
          width: hasMismatch ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: hasMismatch ? AppColors.danger : AppColors.amberDeep, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    sectionTitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                text: hasMismatch ? 'NEW DAMAGE ❌' : 'MATCHED ✓',
                color: hasMismatch ? AppColors.danger : AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cardNavy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PICKUP CONDITION',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textMuted,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pickupState,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasMismatch ? AppColors.danger.withOpacity(0.08) : AppColors.cardNavy,
                    borderRadius: BorderRadius.circular(10),
                    border: hasMismatch ? Border.all(color: AppColors.danger.withOpacity(0.3)) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RETURN CONDITION',
                        style: GoogleFonts.plusJakartaSans(
                          color: hasMismatch ? AppColors.danger : AppColors.textMuted,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        returnState,
                        style: GoogleFonts.plusJakartaSans(
                          color: hasMismatch ? AppColors.danger : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
