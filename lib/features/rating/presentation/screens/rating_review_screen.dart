import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class RatingReviewScreen extends StatefulWidget {
  final Booking booking;

  const RatingReviewScreen({super.key, required this.booking});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  int _activeReviewer = 0; // 0: Renter reviews Owner, 1: Owner reviews Renter
  double _overallStars = 5.0;

  // Specific rating dimensions
  double _itemConditionStars = 5.0;
  double _pickupExpStars = 5.0;
  double _communicationStars = 5.0;
  double _accuracyStars = 5.0;

  final TextEditingController _feedbackController = TextEditingController(
    text: 'Bike was in top running condition! Smooth pickup verification and honest host.',
  );
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final item = booking.item;

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        title: const Text('Dual Trust Network Review'),
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
                      // Toggle review perspective
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceNavy,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _activeReviewer = 0),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _activeReviewer == 0 ? AppColors.primaryNavy : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Renter rates Host',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: _activeReviewer == 0 ? AppColors.white : AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _activeReviewer = 1),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _activeReviewer == 1 ? AppColors.primaryNavy : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Host rates Renter',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: _activeReviewer == 1 ? AppColors.white : AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User being reviewed
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(
                                _activeReviewer == 0
                                    ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'
                                    : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _activeReviewer == 0 ? item.ownerName : booking.renterName,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              _activeReviewer == 0 ? 'Item Host for ${item.title}' : 'Verified Renter',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Main Star Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < _overallStars ? Icons.star_rounded : Icons.star_border_rounded,
                                    color: AppColors.amberDeep,
                                    size: 36,
                                  ),
                                  onPressed: () => setState(() => _overallStars = index + 1.0),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Granular Dimensions
                      Text(
                        _activeReviewer == 0 ? 'Rate Detailed Experience' : 'Rate Renter Reliability',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 15,
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
                            if (_activeReviewer == 0) ...[
                              _buildDimensionRow('Item Condition', _itemConditionStars, (v) => setState(() => _itemConditionStars = v)),
                              const Divider(color: AppColors.borderNavy),
                              _buildDimensionRow('Pickup Experience', _pickupExpStars, (v) => setState(() => _pickupExpStars = v)),
                              const Divider(color: AppColors.borderNavy),
                              _buildDimensionRow('Owner Communication', _communicationStars, (v) => setState(() => _communicationStars = v)),
                              const Divider(color: AppColors.borderNavy),
                              _buildDimensionRow('Listing Accuracy', _accuracyStars, (v) => setState(() => _accuracyStars = v)),
                            ] else ...[
                              _buildDimensionRow('Item Handling & Care', _itemConditionStars, (v) => setState(() => _itemConditionStars = v)),
                              const Divider(color: AppColors.borderNavy),
                              _buildDimensionRow('Punctuality & Timeliness', _pickupExpStars, (v) => setState(() => _pickupExpStars = v)),
                              const Divider(color: AppColors.borderNavy),
                              _buildDimensionRow('Responsiveness', _communicationStars, (v) => setState(() => _communicationStars = v)),
                              const Divider(color: AppColors.borderNavy),
                              _buildDimensionRow('Return Cleanliness', _accuracyStars, (v) => setState(() => _accuracyStars = v)),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Written Feedback
                      CustomTextField(
                        controller: _feedbackController,
                        label: 'Public Trust Network Review',
                        hint: 'Share details of your experience...',
                        maxLines: 3,
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
                  text: 'Submit Rating & Go to Dashboard',
                  icon: Icons.check_circle_rounded,
                  isLoading: _isSubmitting,
                  width: double.infinity,
                  onPressed: () {
                    setState(() => _isSubmitting = true);
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (!mounted) return;
                      setState(() => _isSubmitting = false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainNavigationShell(initialIndex: 1)),
                        (route) => false,
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

  Widget _buildDimensionRow(String title, double stars, void Function(double) onRate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: List.generate(5, (i) {
              return InkWell(
                onTap: () => onRate(i + 1.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppColors.amberDeep,
                    size: 18,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
