import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  String _selectedDoc = 'Driving License';
  bool _uploadedDocFront = true;
  bool _uploadedDocBack = true;
  bool _selfieVerified = true;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final user = state.currentUser;

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
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Identity & Trust Verification'),
        ),
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Reputation Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderNavy),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.amberAccent,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(user.avatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: AppColors.amberAccent,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${user.rating}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      state.currentRole == UserRoleMode.renter
                                          ? '• Verified Renter 🎒'
                                          : '• Verified Superhost 🔑',
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
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.borderNavy, height: 1),
                      const SizedBox(height: 16),

                      // Verification Pills row
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          VerificationBadge(
                            label: 'Mobile verified',
                            verified: user.mobileVerified,
                          ),
                          VerificationBadge(
                            label: 'Email verified',
                            verified: user.emailVerified,
                          ),
                          VerificationBadge(
                            label: 'Identity verified',
                            verified: user.identityVerified,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Rental track record stats
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardNavy,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderNavy),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${user.completedRentals}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.amberAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Completed Rentals',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardNavy,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderNavy),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${user.cancelledRentals}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.success,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Cancelled Rentals',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
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
                const SizedBox(height: 16),

                // Active Role Mode Switcher Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.amberBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.amberLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          state.currentRole == UserRoleMode.renter
                              ? '🎒'
                              : '🔑',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.currentRole == UserRoleMode.renter
                                  ? 'Active: Renter Mode'
                                  : 'Active: Host / Owner Mode',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.currentRole == UserRoleMode.renter
                                  ? 'Rahul Sharma • Browse, book & track rentals'
                                  : 'Amit Saxena • Manage listings & earnings',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNavy,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          state.toggleRole();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.currentRole == UserRoleMode.renter
                                    ? 'Switched to Renter Mode 🎒'
                                    : 'Switched to Host Mode 🔑',
                              ),
                              backgroundColor: AppColors.primaryNavy,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          state.currentRole == UserRoleMode.renter
                              ? 'Switch to Host'
                              : 'Switch to Renter',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Government ID Verification',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mandatory for vehicle rentals (Cars & Bikes) and high-value electronics to ensure deposit recovery.',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Select Document Type
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderNavy),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDoc,
                      isExpanded: true,
                      dropdownColor: AppColors.surfaceNavy,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.amberAccent,
                      ),
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      items:
                          [
                                'Driving License',
                                'Aadhaar Card',
                                'Passport',
                                'Voter ID',
                              ]
                              .map(
                                (doc) => DropdownMenuItem(
                                  value: doc,
                                  child: Text(doc),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDoc = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Upload Documents row
                Row(
                  children: [
                    Expanded(
                      child: _buildDocUploadCard(
                        title: 'Front Side',
                        isUploaded: _uploadedDocFront,
                        onTap: () => setState(
                          () => _uploadedDocFront = !_uploadedDocFront,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDocUploadCard(
                        title: 'Back Side',
                        isUploaded: _uploadedDocBack,
                        onTap: () => setState(
                          () => _uploadedDocBack = !_uploadedDocBack,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Live Selfie Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderNavy),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.cardNavy,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: const Icon(
                          Icons.face_retouching_natural_rounded,
                          color: AppColors.amberAccent,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live Face Match Selfie',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selfieVerified
                                  ? 'Biometric match: 99.4% ✓'
                                  : 'Tap to scan face',
                              style: GoogleFonts.plusJakartaSans(
                                color: _selfieVerified
                                    ? AppColors.success
                                    : AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _selfieVerified
                              ? Icons.check_circle_rounded
                              : Icons.camera_alt_outlined,
                          color: _selfieVerified
                              ? AppColors.success
                              : AppColors.amberAccent,
                        ),
                        onPressed: () =>
                            setState(() => _selfieVerified = !_selfieVerified),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Save Verification & Enter Marketplace',
                  icon: Icons.check_circle_rounded,
                  isLoading: _isSubmitting,
                  width: double.infinity,
                  onPressed: () {
                    setState(() => _isSubmitting = true);
                    Future.delayed(const Duration(milliseconds: 600), () {
                      setState(() => _isSubmitting = false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigationShell(),
                        ),
                        (route) => false,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocUploadCard({
    required String title,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceNavy,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUploaded
                ? AppColors.success.withOpacity(0.6)
                : AppColors.borderNavy,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isUploaded ? Icons.verified_rounded : Icons.upload_file_rounded,
              size: 28,
              color: isUploaded ? AppColors.success : AppColors.amberAccent,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isUploaded ? 'Uploaded ✓' : 'Upload photo',
              style: GoogleFonts.plusJakartaSans(
                color: isUploaded ? AppColors.success : AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
