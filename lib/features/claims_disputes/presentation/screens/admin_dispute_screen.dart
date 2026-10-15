import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/settlement/presentation/screens/deposit_settlement_screen.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class AdminDisputeScreen extends StatefulWidget {
  const AdminDisputeScreen({super.key});

  @override
  State<AdminDisputeScreen> createState() => _AdminDisputeScreenState();
}

class _AdminDisputeScreenState extends State<AdminDisputeScreen> {
  int _selectedTab = 0; // 0: Case Evidence, 1: Agreement, 2: Chat Logs
  bool _isSettling = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final booking = state.activeBooking;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
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
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Admin Dispute Resolution Panel'),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.amberLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.amberAccent),
            ),
            child: Center(
              child: Text(
                'ADMIN ARBITRATOR',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.amberAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
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
                      // Dispute Case Meta Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppColors.disputeGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.dangerBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'CASE #10231 • DISPUTE ACTIVE',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.danger,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const StatusBadge(text: 'Pending Review', color: AppColors.warning),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              booking.item.title,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.cardNavy,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderNavy),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.person_pin_rounded, size: 14, color: AppColors.textMuted),
                                            const SizedBox(width: 4),
                                            Text(
                                              'HOST / CLAIMANT',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.textMuted,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          booking.item.ownerName,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textPrimary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Claims ₹2,000',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.danger,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 1,
                                    color: AppColors.borderNavy,
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textMuted),
                                            const SizedBox(width: 4),
                                            Text(
                                              'RENTER / DEFENDANT',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: AppColors.textMuted,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          booking.renterName,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textPrimary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Disputing Claim',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.amberDeep,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Custom Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton('Media Evidence', 0),
                            _buildTabButton('Rental Agreement', 1),
                            _buildTabButton('Audit Logs', 2),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      if (_selectedTab == 0) ...[
                        // Evidence side-by-side
                        Text(
                          'Comprehensive Evidence Dossier',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),

                        _buildEvidenceCard(
                          title: 'Pickup Inspection Video (30s Walkaround)',
                          sub: 'Recorded 10 Oct 2:02 PM • Right side shows zero dents',
                          badge: 'Pickup Baseline ✓',
                          badgeColor: AppColors.success,
                          icon: Icons.videocam_rounded,
                        ),
                        const SizedBox(height: 10),

                        _buildEvidenceCard(
                          title: 'Return Inspection Video (30s Walkaround)',
                          sub: 'Recorded 10 Oct 6:00 PM • Clear impact dent on right guard',
                          badge: 'Damage Evident ❌',
                          badgeColor: AppColors.danger,
                          icon: Icons.videocam_rounded,
                        ),
                        const SizedBox(height: 10),

                        _buildEvidenceCard(
                          title: 'Side-by-Side Photos (Angle #3 Right Flank)',
                          sub: 'Exhaust silencer dent depth ~12mm with paint abrasion',
                          badge: 'High-Res Macro Photo',
                          badgeColor: AppColors.amberDeep,
                          icon: Icons.camera_alt_rounded,
                        ),
                      ] else if (_selectedTab == 1) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceNavy,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderNavy),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Executed Digital Contract Terms',
                                style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Clause 4.2: Bailee accepts strict financial liability for any damage occurring while vehicle is in their custody.\n• Clause 7.1: Security deposit of ₹3,000 held in escrow expressly covers repair cost assessments.',
                                style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: const [
                                  VerificationBadge(label: 'Owner Signed 1:15 PM ✓'),
                                  VerificationBadge(label: 'Renter Signed 1:55 PM ✓'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceNavy,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderNavy),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Audit Timeline', style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                              const SizedBox(height: 8),
                              Text('10 Oct 2:05 PM — Handover verified with 6 photos & GPS match', style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('10 Oct 6:00 PM — Return inspection tagged new damage on right side', style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('10 Oct 6:15 PM — Host ${booking.item.ownerName} submitted ₹2,000 claim', style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('10 Oct 6:25 PM — Renter ${booking.renterName} escalated to dispute', style: GoogleFonts.plusJakartaSans(color: AppColors.amberDeep, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Admin Decision Guidance
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardNavy,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.balance_rounded, color: AppColors.amberAccent, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Based on forensic video timestamp alignment, the damage occurred within the active rental window.',
                                style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 11, height: 1.4),
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

              // Bottom Admin Arbitration Action Buttons
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
                            text: 'Reject Claim',
                            icon: Icons.cancel_outlined,
                            isOutlined: true,
                            onPressed: () => _resolveDispute(context, 'rejected', 0.0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomButton(
                            text: 'Partial (₹1,000)',
                            icon: Icons.pie_chart_outline_rounded,
                            isOutlined: true,
                            onPressed: () => _resolveDispute(context, 'partial', 1000.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Approve Owner Claim (₹2,000)',
                      icon: Icons.check_circle_rounded,
                      isDanger: false,
                      isLoading: _isSettling,
                      width: double.infinity,
                      onPressed: () => _resolveDispute(context, 'approved', 2000.0),
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

  void _resolveDispute(BuildContext context, String decision, double settledAmount) {
    setState(() => _isSettling = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      final state = context.read<AppStateProvider>();
      state.adminResolveDispute('CLM-10231', decision, settledAmount);
      setState(() => _isSettling = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DepositSettlementScreen(
            booking: state.activeBooking,
            damageDeduction: settledAmount,
            lateFee: 0,
          ),
        ),
      );
    });
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenceCard({
    required String title,
    required String sub,
    required String badge,
    required Color badgeColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceNavy,
        borderRadius: BorderRadius.circular(14),
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
            child: Icon(icon, color: AppColors.amberDeep, size: 24),
          ),
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
                  sub,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                StatusBadge(text: badge, color: badgeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
