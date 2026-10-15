import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/widgets/aay_logo.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/auth/presentation/screens/login_otp_screen.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'tag': 'FOR RENTERS',
      'title': 'Rent Any Equipment\nNearby Instantly',
      'desc': 'From Royal Enfield bikes to Sony A7 IV cameras and DJI drones. Book by the hour or day with instant confirmation.',
      'icon': Icons.explore_rounded,
      'badge': 'Verified Hosts & Fair Rates',
      'image': 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800',
    },
    {
      'tag': 'FOR OWNERS / HOSTS',
      'title': 'Turn Your Idle Gear\nInto Steady Income',
      'desc': 'List your DSLR, bike, car, or tools in 5 minutes. Set your own hourly, daily, and security deposit terms.',
      'icon': Icons.monetization_on_rounded,
      'badge': 'Earn ₹25,000–₹60,000 / month',
      'image': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
    },
    {
      'tag': 'SECURITY & ESCROW',
      'title': 'Forensic Handover &\nDeposit Protection',
      'desc': 'Digital legal contract, mandatory 30s walkaround video, side-by-side return comparison, and automated escrow deposit return.',
      'icon': Icons.verified_user_rounded,
      'badge': '100% Zero-Risk Protocol',
      'image': 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              // Header with logo and Skip button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (_currentPage > 0) ...[
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                        const AayLogo(size: 36),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                        );
                      },
                      child: Text(
                        'Skip to App',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.amberDeep,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView Slides
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Hero Image Container with border
                          Container(
                            height: 240,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.borderNavy, width: 1.5),
                              image: DecorationImage(
                                image: NetworkImage(slide['image'] as String),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.6),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceNavy.withValues(alpha: 0.95),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.amberBorder),
                                ),
                                child: Text(
                                  slide['badge'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.amberDeep,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.amberLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.amberBorder),
                            ),
                            child: Text(
                              slide['tag'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.amberDeep,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Title
                          Text(
                            slide['title'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Description
                          Text(
                            slide['desc'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (idx) {
                  final isCurrent = _currentPage == idx;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isCurrent ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.amberAccent : AppColors.cardNavy,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Dual-role reassurance note
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceNavy,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderNavy),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sync_alt_rounded, color: AppColors.amberAccent, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '1 Unified Profile: Switch between Renter & Owner anytime.',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    CustomButton(
                      text: _currentPage == 2 ? 'Get Started • Create Profile' : 'Continue',
                      icon: Icons.arrow_forward_rounded,
                      width: double.infinity,
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginOtpScreen()),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                        );
                      },
                      child: Text(
                        'Continue as Guest Explorer',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
}
