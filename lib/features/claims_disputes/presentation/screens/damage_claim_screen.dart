import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/claims_disputes/presentation/screens/renter_claim_response_screen.dart';

class DamageClaimScreen extends StatefulWidget {
  final Booking booking;

  const DamageClaimScreen({super.key, required this.booking});

  @override
  State<DamageClaimScreen> createState() => _DamageClaimScreenState();
}

class _DamageClaimScreenState extends State<DamageClaimScreen> {
  String _selectedCategory = 'New physical damage (Dent/Scratch)';
  final TextEditingController _descController = TextEditingController(
    text: 'Large dent on right side exhaust pipe guard and paint scratch on fuel tank flank.',
  );
  final TextEditingController _costController = TextEditingController(text: '2000');
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('File Damage Claim'),
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
                      // Header Card
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
                                const Icon(Icons.shield_outlined, color: AppColors.amberDeep, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Damage Protection Policy',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Claims are backed by the ₹${booking.securityDeposit.toInt()} escrow deposit. Renter will have full opportunity to review evidence and respond.',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Damage Category
                      Text(
                        'Damage Category',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            dropdownColor: AppColors.surfaceNavy,
                            style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 14),
                            items: [
                              'New physical damage (Dent/Scratch)',
                              'Broken or missing component',
                              'Severe dirt/stain requiring detailing',
                              'Late return excessive overstay',
                              'Electronic/mechanical malfunction',
                            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (v) => setState(() => _selectedCategory = v!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Description
                      CustomTextField(
                        controller: _descController,
                        label: 'Detailed Description of Damage',
                        hint: 'Describe exact location and severity...',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 18),

                      // Estimated Repair Cost
                      CustomTextField(
                        controller: _costController,
                        label: 'Estimated Repair / Replacement Cost (₹)',
                        hint: '2000',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.currency_rupee_rounded,
                        helperText: 'Max claimable under deposit: ₹${booking.securityDeposit.toInt()}',
                      ),
                      const SizedBox(height: 20),

                      // Evidence Attached
                      Text(
                        'Evidence Automatically Attached',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
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
                          children: [
                            _buildEvidenceRow(Icons.photo_library_rounded, 'Return High-Res Photos (Right Side Angle)'),
                            const Divider(color: AppColors.borderNavy),
                            _buildEvidenceRow(Icons.video_camera_back_rounded, '30s Return Walk-around Video Clip'),
                            const Divider(color: AppColors.borderNavy),
                            _buildEvidenceRow(Icons.description_rounded, 'Signed Rental Master Agreement #BK-10231'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Submit CTA Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: CustomButton(
                  text: 'Submit Damage Claim (₹${_costController.text})',
                  icon: Icons.send_rounded,
                  isLoading: _isSubmitting,
                  isDanger: true,
                  width: double.infinity,
                  onPressed: () {
                    final amount = double.tryParse(_costController.text) ?? 2000.0;
                    setState(() => _isSubmitting = true);
                    Future.delayed(const Duration(milliseconds: 600), () {
                      context.read<AppStateProvider>().submitDamageClaim(
                            description: _descController.text,
                            amount: amount,
                            category: _selectedCategory,
                          );
                      setState(() => _isSubmitting = false);

                      // Navigate to Renter Claim Response Screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RenterClaimResponseScreen(
                            booking: widget.booking,
                            claimAmount: amount,
                            claimDescription: _descController.text,
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenceRow(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.amberDeep, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
        ],
      ),
    );
  }
}
