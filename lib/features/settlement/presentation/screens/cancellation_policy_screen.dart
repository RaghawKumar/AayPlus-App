import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_widgets.dart';

class CancellationPolicyScreen extends StatelessWidget {
  const CancellationPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Fair Marketplace Cancellation Rules'),
        ),
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderNavy),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.handshake_outlined, color: AppColors.amberDeep, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Transparent cancellation rules protect both hosts who reserve items and renters who have sudden changes of plans.',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 1. Renter Cancellation Tier
                Text(
                  '1. When Renter Cancels',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRefundTierCard(
                  time: '> 24 Hours Before Start',
                  refund: '100% Full Refund',
                  note: 'Security deposit + full rental refunded immediately without fee.',
                  color: AppColors.success,
                  badge: 'No Penalty',
                ),
                const SizedBox(height: 10),
                _buildRefundTierCard(
                  time: '12 – 24 Hours Before Start',
                  refund: '90% Rental Refund',
                  note: '100% deposit refunded. 10% rental fee compensated to host.',
                  color: AppColors.amberDeep,
                  badge: '10% Host Prep Fee',
                ),
                const SizedBox(height: 10),
                _buildRefundTierCard(
                  time: '< 12 Hours Before Start',
                  refund: '50% Rental Refund',
                  note: '100% deposit refunded. 50% rental fee paid to host for reserved slot.',
                  color: AppColors.warning,
                  badge: 'Late Cancellation',
                ),
                const SizedBox(height: 10),
                _buildRefundTierCard(
                  time: 'After Handover / Pickup',
                  refund: 'No Refund for Expired Period',
                  note: 'Active rentals are non-refundable once item custody has been transferred.',
                  color: AppColors.danger,
                  badge: 'Locked',
                ),
                const SizedBox(height: 28),

                // 2. Owner Cancellation Penalties
                Text(
                  '2. When Host / Owner Cancels',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Owner cancellations disrupt travel and project commitments. Strict trust safeguards apply.',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderNavy),
                  ),
                  child: Column(
                    children: [
                      _buildOwnerPenaltyRow(
                        Icons.payments_rounded,
                        '100% Automatic Full Refund',
                        'Renter receives immediate instant refund including priority voucher.',
                      ),
                      const Divider(color: AppColors.borderNavy),
                      _buildOwnerPenaltyRow(
                        Icons.warning_amber_rounded,
                        'Host Cancellation Strike',
                        'Host reputation card records +1 cancelled rental and rating hit.',
                      ),
                      const Divider(color: AppColors.borderNavy),
                      _buildOwnerPenaltyRow(
                        Icons.block_rounded,
                        'Listing Restriction Penalty',
                        'Repeated cancellations (3 strikes) temporarily delists all host items.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefundTierCard({
    required String time,
    required String refund,
    required String note,
    required Color color,
    required String badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              StatusBadge(text: badge, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            refund,
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerPenaltyRow(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.amberDeep, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
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
    );
  }
}
