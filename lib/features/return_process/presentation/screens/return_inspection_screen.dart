import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/return_process/presentation/screens/comparison_inspection_screen.dart';

class ReturnInspectionScreen extends StatefulWidget {
  final Booking booking;

  const ReturnInspectionScreen({super.key, required this.booking});

  @override
  State<ReturnInspectionScreen> createState() => _ReturnInspectionScreenState();
}

class _ReturnInspectionScreenState extends State<ReturnInspectionScreen> {
  final Map<String, bool> _returnPhotos = {
    'Front View': true,
    'Left Side': true,
    'Right Side': true,
    'Rear View': true,
    'Dashboard / Speedo': true,
    'Tyres & Wheels': true,
  };

  bool _checklistConfirmed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Return Handover Inspection'),
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
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.compare_rounded, color: AppColors.amberDeep, size: 26),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Return Verification in Progress',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Capturing return evidence to compare directly against pickup baselines.',
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
                        '1. Return Photos (6/6 Captured)',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),

                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.95,
                        children: _returnPhotos.entries.map((entry) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceNavy,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.success.withOpacity(0.5)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                                const SizedBox(height: 6),
                                Text(
                                  entry.key,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Snapped ✓',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.success,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        '2. Return Walk-around Video (30s)',
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.cardNavy,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.video_file_rounded, color: AppColors.amberDeep, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'walkaround_return_inspection_30s.mp4',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Completed • 6:00 PM • Hash verified',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const StatusBadge(text: 'Ready', color: AppColors.success),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        '3. Handover Checklist Confirmation',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _checklistConfirmed,
                              activeColor: AppColors.primaryNavy,
                              checkColor: AppColors.white,
                              onChanged: (v) => setState(() => _checklistConfirmed = v ?? false),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Keys returned, accessories verified (2 helmets, mobile mount, RC document), and fuel level matched.',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
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

              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: CustomButton(
                  text: 'Compare Pickup vs Return Condition',
                  icon: Icons.compare_arrows_rounded,
                  width: double.infinity,
                  onPressed: () {
                    context.read<AppStateProvider>().confirmReturnInspection();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ComparisonInspectionScreen(booking: widget.booking),
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
}
