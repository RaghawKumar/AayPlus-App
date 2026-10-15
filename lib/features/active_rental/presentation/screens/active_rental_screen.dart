import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/return_process/presentation/screens/return_inspection_screen.dart';
import 'package:aay_plus/features/rental_passport/presentation/screens/rental_passport_screen.dart';

class ActiveRentalScreen extends StatefulWidget {
  final Booking booking;

  const ActiveRentalScreen({super.key, required this.booking});

  @override
  State<ActiveRentalScreen> createState() => _ActiveRentalScreenState();
}

class _ActiveRentalScreenState extends State<ActiveRentalScreen> {
  void _openReportIssueModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Report Issue During Rental',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Immediate 24/7 roadside & safety support hotline is active.',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ...[
                {'title': 'Mechanical Breakdown / Puncture', 'icon': Icons.car_crash_rounded, 'color': AppColors.warning},
                {'title': 'Traffic Accident / Collision', 'icon': Icons.emergency_rounded, 'color': AppColors.danger},
                {'title': 'Defect or Operational Problem', 'icon': Icons.build_circle_rounded, 'color': AppColors.amberDeep},
                {'title': 'Emergency SOS Police / Ambulance', 'icon': Icons.local_police_rounded, 'color': AppColors.danger},
                {'title': 'Other Item Problem', 'icon': Icons.help_outline_rounded, 'color': AppColors.info},
              ].map((issue) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Support ticket created for: ${issue['title']}'),
                        backgroundColor: issue['color'] as Color,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardNavy,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderNavy),
                    ),
                    child: Row(
                      children: [
                        Icon(issue['icon'] as IconData, color: issue['color'] as Color, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          issue['title'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _openContactOwnerModal() {
    final item = widget.booking.item;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
              ),
              const SizedBox(height: 12),
              Text(
                item.ownerName,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Host • ⭐ ${item.ownerRating} (42 rentals hosted)',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Call Owner',
                      icon: Icons.phone_rounded,
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'In-App Chat',
                      icon: Icons.chat_bubble_outline_rounded,
                      isOutlined: true,
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Live Rental Tracking'),
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
                      // Status Glow Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppColors.activeRentalGradient,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.success.withOpacity(0.6)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bolt_rounded, color: AppColors.success, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'RENTAL ACTIVE',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.success,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Live Countdown Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Time Remaining',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '2h 40m',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.amberDeep,
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: 0.35,
                              backgroundColor: AppColors.cardNavy,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amberAccent),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Started At', style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 11)),
                                    Text('2:05 PM', style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Scheduled Return', style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 11)),
                                    Text('6:00 PM Today', style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Rental Passport Quick Card
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
                              child: const Icon(Icons.assignment_turned_in_rounded, color: AppColors.amberDeep, size: 24),
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
                                      const StatusBadge(text: 'Sealed', color: AppColors.success),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '8 Pickup Photos • 1 Video • 6 Condition Checks',
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
                                    builder: (_) => RentalPassportScreen(booking: widget.booking),
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
                      const SizedBox(height: 20),

                      // Quick Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Contact Owner',
                              icon: Icons.chat_rounded,
                              isOutlined: true,
                              onPressed: _openContactOwnerModal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Report Issue',
                              icon: Icons.warning_amber_rounded,
                              isDanger: true,
                              onPressed: _openReportIssueModal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Return Navigation Card
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
                                const Icon(Icons.navigation_rounded, color: AppColors.amberDeep, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Return Destination',
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
                              item.exactLocation,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Grace period applies: 15 minutes before late fee',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
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

              // Bottom Return Trigger
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: CustomButton(
                  text: 'Initiate Return Handover & Inspection',
                  icon: Icons.assignment_return_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReturnInspectionScreen(booking: widget.booking),
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
