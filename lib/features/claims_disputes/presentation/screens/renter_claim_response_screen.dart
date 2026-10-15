import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/settlement/presentation/screens/deposit_settlement_screen.dart';
import 'package:aay_plus/features/claims_disputes/presentation/screens/admin_dispute_screen.dart';

class RenterClaimResponseScreen extends StatefulWidget {
  final Booking booking;
  final double claimAmount;
  final String claimDescription;

  const RenterClaimResponseScreen({
    super.key,
    required this.booking,
    this.claimAmount = 2000.0,
    this.claimDescription = 'Large dent on right side exhaust pipe guard and paint scratch on fuel tank flank.',
  });

  @override
  State<RenterClaimResponseScreen> createState() => _RenterClaimResponseScreenState();
}

class _RenterClaimResponseScreenState extends State<RenterClaimResponseScreen> {
  bool _isAccepting = false;
  bool _isDisputing = false;

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final item = booking.item;
    final remainingRefund = booking.securityDeposit - widget.claimAmount;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Review Damage Claim'),
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
                          color: AppColors.amberLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.amberBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_rounded, color: AppColors.amberDeep, size: 26),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fair Resolution Opportunity',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'AayPlus does not charge your deposit automatically. You can accept the repair quote or escalate to an unbiased Admin review.',
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

                      // Claim Summary Card
                      Container(
                        padding: const EdgeInsets.all(18),
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
                                  'Owner Reported Claim',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const StatusBadge(text: 'Action Required', color: AppColors.warning),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Claimed by Host: ${item.ownerName}',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: AppColors.borderNavy, height: 1),
                            const SizedBox(height: 14),

                            Text(
                              'Issue Details:',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.claimDescription,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Claim Repair Amount',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '₹${widget.claimAmount.toInt()}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.danger,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Security Deposit Balance Refund',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '₹${remainingRefund.toInt()} refunded',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.success,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Attached Evidence Preview
                      Text(
                        'Attached Evidence from Handover',
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
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceNavy,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderNavy),
                                image: DecorationImage(
                                  image: NetworkImage(item.photos.first),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(Icons.zoom_in_rounded, color: AppColors.white, size: 28),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceNavy,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderNavy),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.play_circle_fill_rounded, color: AppColors.amberDeep, size: 36),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Play 30s Inspection Clip',
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
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Dual Response Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Dispute Claim',
                            icon: Icons.gavel_rounded,
                            isOutlined: true,
                            isDanger: true,
                            isLoading: _isDisputing,
                            onPressed: () {
                              setState(() => _isDisputing = true);
                              Future.delayed(const Duration(milliseconds: 600), () {
                                context.read<AppStateProvider>().renterRespondToClaim('CLM-10231', false);
                                setState(() => _isDisputing = false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AdminDisputeScreen(),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: 'Accept & Deduct',
                            icon: Icons.check_circle_rounded,
                            isLoading: _isAccepting,
                            onPressed: () {
                              setState(() => _isAccepting = true);
                              Future.delayed(const Duration(milliseconds: 600), () {
                                context.read<AppStateProvider>().renterRespondToClaim('CLM-10231', true);
                                setState(() => _isAccepting = false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DepositSettlementScreen(
                                      booking: widget.booking,
                                      damageDeduction: widget.claimAmount,
                                      lateFee: 0,
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'If disputed, case is referred to AayPlus Arbitration with complete video timeline.',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
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
}
