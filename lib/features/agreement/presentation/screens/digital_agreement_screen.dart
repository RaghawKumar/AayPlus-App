import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/inspection/presentation/screens/pickup_inspection_screen.dart';

class DigitalAgreementScreen extends StatefulWidget {
  final Booking booking;

  const DigitalAgreementScreen({super.key, required this.booking});

  @override
  State<DigitalAgreementScreen> createState() => _DigitalAgreementScreenState();
}

class _DigitalAgreementScreenState extends State<DigitalAgreementScreen> {
  bool _agreedOnTime = true;
  bool _agreedSameCondition = true;
  bool _agreedDamageCharges = true;
  bool _agreedUsageRules = true;
  bool _renterSigned = false;

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final item = booking.item;
    final allChecked = _agreedOnTime && _agreedSameCondition && _agreedDamageCharges && _agreedUsageRules;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Digital Rental Agreement'),
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
                      // Header Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amberLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.amberAccent.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.gavel_rounded, color: AppColors.amberAccent, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'LEGAL BINDING CONTRACT • INDIAN CONTRACT ACT 1872',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.amberAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Rental Master Agreement',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Booking ID: ${booking.id} • Registered on AayPlus Escrow',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Contract Summary Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Column(
                          children: [
                            _buildContractRow('Item Rented', item.title, isBold: true),
                            const Divider(color: AppColors.borderNavy),
                            _buildContractRow('Owner (Bailor)', item.ownerName),
                            const Divider(color: AppColors.borderNavy),
                            _buildContractRow('Renter (Bailee)', booking.renterName),
                            const Divider(color: AppColors.borderNavy),
                            _buildContractRow('Rental Period', '10 Oct, 2:00 PM → 6:00 PM (4 hrs)'),
                            const Divider(color: AppColors.borderNavy),
                            _buildContractRow('Security Deposit', '₹${booking.securityDeposit.toInt()} (Held in Escrow)'),
                            const Divider(color: AppColors.borderNavy),
                            _buildContractRow('Expected Condition', 'Identical condition as recorded at Pickup Verification', isHighlight: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Mandatory Bailee Obligations',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildCheckTile(
                        title: 'Return on time',
                        subtitle: 'Return promptly at or before 6:00 PM. A grace period of 15 mins applies, followed by late fees.',
                        value: _agreedOnTime,
                        onChanged: (v) => setState(() => _agreedOnTime = v ?? false),
                      ),
                      _buildCheckTile(
                        title: 'Return item in same condition',
                        subtitle: 'Item must be returned without structural damage, punctures, or unauthorized modifications.',
                        value: _agreedSameCondition,
                        onChanged: (v) => setState(() => _agreedSameCondition = v ?? false),
                      ),
                      _buildCheckTile(
                        title: 'Pay applicable damage charges',
                        subtitle: 'Authorize security deposit deduction or additional liability charges if verified damage occurs during rental.',
                        value: _agreedDamageCharges,
                        onChanged: (v) => setState(() => _agreedDamageCharges = v ?? false),
                      ),
                      _buildCheckTile(
                        title: 'Follow usage restrictions & laws',
                        subtitle: 'Must hold valid driving license, no off-roading, no illegal activities, and comply with speed limits.',
                        value: _agreedUsageRules,
                        onChanged: (v) => setState(() => _agreedUsageRules = v ?? false),
                      ),
                      const SizedBox(height: 24),

                      // Signatures Dual Status
                      Text(
                        'Digital Signatures Status',
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
                            // Owner Signature Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Owner: ${item.ownerName}',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'Digitally Signed & Accepted ✓',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.success,
                                            fontSize: 11,
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
                                    color: AppColors.cardNavy,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '10 Oct 1:15 PM',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: AppColors.borderNavy),
                            ),
                            // Renter Signature Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _renterSigned ? Icons.check_circle_rounded : Icons.pending_rounded,
                                      color: _renterSigned ? AppColors.success : AppColors.amberAccent,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Renter: ${booking.renterName}',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          _renterSigned ? 'Digitally Signed & Accepted ✓' : 'Signature Pending',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: _renterSigned ? AppColors.success : AppColors.amberDeep,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (!_renterSigned)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: allChecked ? AppColors.primaryNavy : AppColors.elevatedNavy,
                                      foregroundColor: allChecked ? AppColors.white : AppColors.textMuted,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: allChecked
                                        ? () {
                                            setState(() => _renterSigned = true);
                                            context.read<AppStateProvider>().acceptAgreement(isOwner: false);
                                          }
                                        : null,
                                    child: Text(
                                      'Click to Sign',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Button Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: CustomButton(
                  text: _renterSigned ? 'Proceed to Pickup Verification' : 'Sign & Accept Agreement',
                  icon: Icons.qr_code_scanner_rounded,
                  width: double.infinity,
                  onPressed: () {
                    if (!_renterSigned) {
                      setState(() => _renterSigned = true);
                      context.read<AppStateProvider>().acceptAgreement(isOwner: false);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PickupInspectionScreen(booking: booking),
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

  Widget _buildContractRow(String label, String value, {bool isBold = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.plusJakartaSans(
                color: isHighlight
                    ? AppColors.amberDeep
                    : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: (isBold || isHighlight) ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value ? AppColors.borderNavy : AppColors.danger.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            activeColor: AppColors.primaryNavy,
            checkColor: AppColors.white,
            onChanged: onChanged,
          ),
          const SizedBox(width: 6),
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
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    height: 1.3,
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
