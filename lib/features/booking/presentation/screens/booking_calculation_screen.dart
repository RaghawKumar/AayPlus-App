import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/booking/presentation/screens/owner_request_approval_screen.dart';

class BookingCalculationScreen extends StatefulWidget {
  final RentalItem item;

  const BookingCalculationScreen({super.key, required this.item});

  @override
  State<BookingCalculationScreen> createState() =>
      _BookingCalculationScreenState();
}

class _BookingCalculationScreenState extends State<BookingCalculationScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  late int _durationHours;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppStateProvider>();
    _startDate = state.rentalStartDate;
    _endDate = state.rentalEndDate;
    _durationHours = ((_endDate.difference(_startDate).inMinutes) / 60)
        .ceil()
        .clamp(1, 8760);
  }

  String _selectedPaymentMethod = 'UPI (GPay / PhonePe)';
  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final rentalCharge = _durationHours * item.hourlyPrice;
    const platformFee = 30.0;
    final deposit = item.securityDeposit;
    final totalPayable = rentalCharge + platformFee + deposit;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Confirm & Pay'),
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
                      // Item Summary Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.photos.first,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.brand} • ${item.category}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '📍 ${item.approxLocation}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.amberDeep,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Time Selector Card
                      Text(
                        'Rental Schedule',
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
                            Row(
                              children: [
                                const Icon(
                                  Icons.play_circle_filled_rounded,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start Time',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'd MMM, h:mm a',
                                        ).format(_startDate),
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardNavy,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Change',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.amberDeep,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(color: AppColors.borderNavy),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.stop_circle_rounded,
                                  color: AppColors.danger,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Return Time',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'd MMM, h:mm a',
                                        ).format(_endDate),
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardNavy,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Change',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.amberDeep,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.amberLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.amberBorder,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Duration: $_durationHours Hours (₹${item.hourlyPrice.toInt()}/hr)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.amberDeep,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Transparent Price Breakdown
                      Text(
                        'Transparent Price Calculation',
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
                            _buildPriceRow(
                              'Rental charge ($_durationHours hrs × ₹${item.hourlyPrice.toInt()})',
                              '₹${rentalCharge.toInt()}',
                            ),
                            const SizedBox(height: 10),
                            _buildPriceRow(
                              'Platform fee & safety verification',
                              '₹${platformFee.toInt()}',
                            ),
                            const SizedBox(height: 10),
                            _buildPriceRow(
                              'Refundable Security Deposit',
                              '₹${deposit.toInt()}',
                              isDeposit: true,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: AppColors.borderNavy),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Payable',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '₹${totalPayable.toInt()}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.amberDeep,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Deposit Reassurance
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.successBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_clock_rounded,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Deposit protection: ₹${deposit.toInt()} is held in escrow and released back immediately upon successful return inspection.',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Payment Method Selector
                      Text(
                        'Select Payment Mode',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...[
                        'UPI (GPay / PhonePe)',
                        'Credit or Debit Card',
                        'Net Banking / Wallet',
                      ].map((method) {
                        final isSelected = _selectedPaymentMethod == method;
                        return InkWell(
                          onTap: () =>
                              setState(() => _selectedPaymentMethod = method),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.amberLight
                                  : AppColors.surfaceNavy,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.amberBorder
                                    : AppColors.borderNavy,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? AppColors.amberDeep
                                      : AppColors.textMuted,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  method,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Pay & Request CTA Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: CustomButton(
                  text: 'Pay ₹${totalPayable.toInt()} & Send Request',
                  icon: Icons.shield_rounded,
                  isLoading: _isProcessingPayment,
                  width: double.infinity,
                  onPressed: () {
                    setState(() => _isProcessingPayment = true);
                    Future.delayed(const Duration(milliseconds: 700), () {
                      if (!mounted) return;
                      final state = context.read<AppStateProvider>();
                      state.createBooking(
                        item: widget.item,
                        start: _startDate,
                        end: _endDate,
                        rentalAmount: rentalCharge,
                        platformFee: platformFee,
                        deposit: deposit,
                      );
                      setState(() => _isProcessingPayment = false);

                      // Navigate to Owner Approval Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OwnerRequestApprovalScreen(
                            booking: state.activeBooking,
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

  Widget _buildPriceRow(String label, String amount, {bool isDeposit = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isDeposit
                    ? AppColors.amberDeep
                    : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isDeposit ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (isDeposit) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 14,
                color: AppColors.amberDeep,
              ),
            ],
          ],
        ),
        Text(
          amount,
          style: GoogleFonts.plusJakartaSans(
            color: isDeposit ? AppColors.amberDeep : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
