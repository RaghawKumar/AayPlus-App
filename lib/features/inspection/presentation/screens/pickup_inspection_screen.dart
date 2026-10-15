import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/active_rental/presentation/screens/active_rental_screen.dart';

class PickupInspectionScreen extends StatefulWidget {
  final Booking booking;

  const PickupInspectionScreen({super.key, required this.booking});

  @override
  State<PickupInspectionScreen> createState() => _PickupInspectionScreenState();
}

class _PickupInspectionScreenState extends State<PickupInspectionScreen> {
  // 6 Required Guided Photo Angles
  final Map<String, bool> _photoAngles = {
    'Front View': true,
    'Left Side': true,
    'Right Side': true,
    'Rear View': true,
    'Dashboard / Speedo': true,
    'Tyres & Wheels': true,
  };

  // Existing damage markers
  final List<DamageTag> _existingDamages = [
    const DamageTag(
      part: 'Left Side Exhaust',
      type: 'Scratch',
      description: 'Minor superficial scratch near silencer heat guard (1.5 cm)',
    ),
  ];

  // 30s Video Walk-around state
  bool _isVideoRecording = false;
  int _videoSecondsLeft = 30;
  int _videoStep = 1;
  Timer? _timer;
  bool _videoRecorded = true;

  // Declarations
  bool _ownerDeclared = true;
  bool _renterDeclared = true;
  bool _isFinalizing = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVideoRecording() {
    setState(() {
      _isVideoRecording = true;
      _videoSecondsLeft = 30;
      _videoStep = 1;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_videoSecondsLeft > 1) {
        setState(() {
          _videoSecondsLeft--;
          if (_videoSecondsLeft > 24) {
            _videoStep = 1; // Front
          } else if (_videoSecondsLeft > 18) {
            _videoStep = 2; // Left
          } else if (_videoSecondsLeft > 12) {
            _videoStep = 3; // Right
          } else if (_videoSecondsLeft > 6) {
            _videoStep = 4; // Rear
          } else {
            _videoStep = 5; // Dashboard / Serial
          }
        });
      } else {
        timer.cancel();
        setState(() {
          _isVideoRecording = false;
          _videoRecorded = true;
        });
      }
    });
  }

  void _addDamageDialog() {
    String selectedPart = 'Front';
    String selectedType = 'Dent';
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceNavy,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            '+ Mark Pre-existing Damage',
            style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedPart,
                dropdownColor: AppColors.surfaceNavy,
                decoration: const InputDecoration(labelText: 'Affected Section'),
                items: ['Front', 'Left Side', 'Right Side', 'Rear', 'Dashboard', 'Engine/Other']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: AppColors.textPrimary))))
                    .toList(),
                onChanged: (v) => selectedPart = v ?? 'Front',
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: AppColors.surfaceNavy,
                decoration: const InputDecoration(labelText: 'Damage Type'),
                items: ['Dent', 'Scratch', 'Crack', 'Broken part', 'Stain/Tear']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: AppColors.textPrimary))))
                    .toList(),
                onChanged: (v) => selectedType = v ?? 'Dent',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: descCtrl,
                label: 'Description & Location',
                hint: 'e.g. Paint scrape on rear mudguard',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy, foregroundColor: AppColors.white),
              onPressed: () {
                if (descCtrl.text.isNotEmpty) {
                  setState(() {
                    _existingDamages.add(
                      DamageTag(part: selectedPart, type: selectedType, description: descCtrl.text),
                    );
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add Damage'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final item = booking.item;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Pickup Verification'),
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
                      // Process Step Bar
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.handshake_rounded, color: AppColors.amberAccent, size: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'In-Person Handover Checklist',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'Both Owner (${item.ownerName}) and Renter (${booking.renterName}) must inspect together.',
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

                      // Section 1: 6 Guided Photo Angles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1. Guided Angle Photos (6/6)',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const StatusBadge(text: 'All Captured ✓', color: AppColors.success),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.95,
                        children: _photoAngles.entries.map((entry) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceNavy,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: entry.value ? AppColors.success.withOpacity(0.5) : AppColors.borderNavy,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  entry.value ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                                  color: entry.value ? AppColors.success : AppColors.amberAccent,
                                  size: 24,
                                ),
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
                                  entry.value ? 'Verified' : 'Tap to snap',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: entry.value ? AppColors.success : AppColors.textMuted,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 22),

                      // Section 2: 30-Second Walk-around Video
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '2. Structured 30s Walk-around Video',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (_videoRecorded)
                            const StatusBadge(text: 'Recorded ✓', color: AppColors.success),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Video Recording Simulation Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isVideoRecording ? const Color(0xFF2E1515) : AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isVideoRecording ? AppColors.danger : AppColors.borderNavy,
                            width: _isVideoRecording ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (_isVideoRecording) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: AppColors.danger,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'RECORDING LIVE (00:${_videoSecondsLeft.toString().padLeft(2, '0')})',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.danger,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'GPS: 28.6280° N, 77.3649° E',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              LinearProgressIndicator(
                                value: (30 - _videoSecondsLeft) / 30,
                                backgroundColor: AppColors.darkNavy,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.danger),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.cardNavy,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _videoStep == 1
                                      ? '👉 Step 1: Pan across FRONT face'
                                      : _videoStep == 2
                                          ? '👉 Step 2: Show LEFT side and exhaust'
                                          : _videoStep == 3
                                              ? '👉 Step 3: Show RIGHT side'
                                              : _videoStep == 4
                                                  ? '👉 Step 4: Show REAR wheel & plate'
                                                  : '👉 Step 5: Zoom in on DASHBOARD / SERIAL NO',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.amberAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardNavy,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.videocam_rounded, color: AppColors.amberAccent, size: 28),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'walkaround_pickup_30s.mp4',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textPrimary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Timestamp: 10 Oct 2:02 PM • GPS tagged • Hash verified',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textSecondary,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.replay_rounded, color: AppColors.amberDeep),
                                    onPressed: _startVideoRecording,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Section 3: Existing Damage Checklist
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '3. Recorded Pre-Existing Damage',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.add_circle_outline, size: 16, color: AppColors.amberDeep),
                            label: Text(
                              'Add Damage',
                              style: GoogleFonts.plusJakartaSans(color: AppColors.amberDeep, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            onPressed: _addDamageDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (_existingDamages.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceNavy,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderNavy),
                          ),
                          child: Center(
                            child: Text(
                              'No pre-existing damages noted.',
                              style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 13),
                            ),
                          ),
                        )
                      else
                        ..._existingDamages.map((dmg) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceNavy,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.amberAccent.withOpacity(0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: AppColors.amberAccent, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${dmg.part} • ${dmg.type}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        dmg.description,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const StatusBadge(text: 'Logged', color: AppColors.amberAccent),
                              ],
                            ),
                          );
                        }),
                      const SizedBox(height: 22),

                      // Section 4: Dual Damage Declaration
                      Text(
                        '4. Dual Handover Declaration',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Owner Declaration Checkbox
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
                              value: _ownerDeclared,
                              activeColor: AppColors.primaryNavy,
                              checkColor: AppColors.white,
                              onChanged: (v) => setState(() => _ownerDeclared = v ?? false),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Owner Declaration (${item.ownerName})',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '“I confirm that the above 6 photos and 30s video accurately represent the item at pickup. No additional undisclosed damages exist.”',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Renter Declaration Checkbox
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
                              value: _renterDeclared,
                              activeColor: AppColors.primaryNavy,
                              checkColor: AppColors.white,
                              onChanged: (v) => setState(() => _renterDeclared = v ?? false),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Renter Declaration (${booking.renterName})',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '“I have physically inspected the item, verified the condition, and accept the item into my custody.”',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
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

              // Bottom Verify & Start Rental CTA Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: CustomButton(
                  text: 'Confirm Handover • Start Rental',
                  icon: Icons.key_rounded,
                  isLoading: _isFinalizing,
                  width: double.infinity,
                  onPressed: (_ownerDeclared && _renterDeclared && _videoRecorded)
                      ? () {
                          setState(() => _isFinalizing = true);
                          Future.delayed(const Duration(milliseconds: 700), () {
                            context.read<AppStateProvider>().confirmPickupInspection();
                            setState(() => _isFinalizing = false);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ActiveRentalScreen(booking: widget.booking),
                              ),
                            );
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
