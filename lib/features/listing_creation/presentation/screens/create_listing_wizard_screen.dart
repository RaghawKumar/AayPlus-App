import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/owner_dashboard/presentation/screens/owner_inventory_screen.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class CreateListingWizardScreen extends StatefulWidget {
  const CreateListingWizardScreen({super.key});

  @override
  State<CreateListingWizardScreen> createState() => _CreateListingWizardScreenState();
}

class _CreateListingWizardScreenState extends State<CreateListingWizardScreen> {
  int _currentStep = 1; // 1 to 6

  // Step 1: Category & Custom
  String _selectedCategory = 'Cameras';
  String _selectedSubcategory = 'Mirrorless';
  final TextEditingController _customCategoryCtrl = TextEditingController();

  // Step 2: Basic Info
  final TextEditingController _nameCtrl = TextEditingController(text: 'Sony A7 IV');
  final TextEditingController _brandCtrl = TextEditingController(text: 'Sony');
  final TextEditingController _modelCtrl = TextEditingController(text: 'ILCE-7M4 4K');
  final TextEditingController _yearCtrl = TextEditingController(text: '2024');
  final TextEditingController _descCtrl = TextEditingController(
    text: 'Professional full-frame hybrid camera with 33MP sensor, excellent low light, and 4K 60fps video.',
  );
  String _condition = 'Excellent';
  final TextEditingController _serialCtrl = TextEditingController(text: 'SN-78491024-SY');

  // Step 3: Photos (Front, Back, Left, Right, Closeup, Serial)
  final Map<String, bool> _photoSlots = {
    'Front Angle': true,
    'Back Angle': true,
    'Left Side': true,
    'Right Side': true,
    'Close-up Detail': true,
    'Serial / IMEI Label': true,
  };

  // Step 4: Availability
  String _availableHours = '10:00 AM – 8:00 PM';
  final List<String> _selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Step 5: Pricing & Deposit
  final TextEditingController _hourlyPriceCtrl = TextEditingController(text: '150');
  final TextEditingController _dailyPriceCtrl = TextEditingController(text: '1000');
  final TextEditingController _weeklyPriceCtrl = TextEditingController(text: '5800');
  final TextEditingController _depositCtrl = TextEditingController(text: '5000');

  // Step 6: Location & Privacy
  final TextEditingController _approxLocCtrl = TextEditingController(text: 'Sector 62, Noida');
  final TextEditingController _exactLocCtrl = TextEditingController(text: 'Tower B, Candor TechSpace, Sector 62, Noida');

  bool _isPublishing = false;

  final List<Map<String, String>> _categories = [
    {'name': 'Bikes', 'emoji': '🏍', 'sub': 'Cruiser, Sport, Scooter, EV'},
    {'name': 'Cameras', 'emoji': '📷', 'sub': 'Mirrorless, DSLR, Lenses, Drone'},
    {'name': 'Electronics', 'emoji': '💻', 'sub': 'Laptop, Tablet, Projector, Audio'},
    {'name': 'Parking', 'emoji': '🅿️', 'sub': 'Covered spot, Driveway, EV charging'},
  ];

  void _nextStep() {
    if (_currentStep < 6) {
      setState(() => _currentStep++);
    } else {
      _publishListing();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _publishListing() {
    setState(() => _isPublishing = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      final state = context.read<AppStateProvider>();
      final newItem = RentalItem(
        id: 'item_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: '${_brandCtrl.text} ${_nameCtrl.text}',
        category: _selectedCategory,
        subcategory: _selectedSubcategory,
        brand: _brandCtrl.text,
        model: _modelCtrl.text,
        year: int.tryParse(_yearCtrl.text) ?? 2024,
        description: _descCtrl.text,
        condition: _condition,
        serialNumber: _serialCtrl.text,
        hourlyPrice: double.tryParse(_hourlyPriceCtrl.text) ?? 150.0,
        dailyPrice: double.tryParse(_dailyPriceCtrl.text) ?? 1000.0,
        weeklyPrice: double.tryParse(_weeklyPriceCtrl.text) ?? 5800.0,
        securityDeposit: double.tryParse(_depositCtrl.text) ?? 5000.0,
        approxLocation: _approxLocCtrl.text,
        exactLocation: _exactLocCtrl.text,
        ownerId: state.currentUser.id,
        ownerName: state.currentUser.name,
        ownerRating: state.currentUser.rating,
        ownerCompletedRentals: state.currentUser.completedRentals,
        features: ['Original accessories', 'Functional check passed', 'Serial verified', 'Case included'],
        photos: [
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
          'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=800',
        ],
        rating: 5.0,
        reviewsCount: 0,
        distanceKm: 0.5,
        isAvailable: true,
      );

      state.addListing(newItem);
      state.setRole(UserRoleMode.owner);
      setState(() => _isPublishing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Listing "${newItem.title}" published successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerInventoryScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        title: Text('List Item for Rent (Step $_currentStep of 6)'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (_currentStep > 1) {
              _prevStep();
            } else if (Navigator.canPop(context)) {
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
              // Progress Bar
              LinearProgressIndicator(
                value: _currentStep / 6,
                backgroundColor: AppColors.surfaceNavy,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amberAccent),
                minHeight: 4,
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.amberLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.amberBorder),
                        ),
                        child: Text(
                          _getStepTag(),
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.amberDeep,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        _getStepTitle(),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getStepSubtitle(),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Step Content
                      _buildCurrentStepContent(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceNavy,
                  border: Border(top: BorderSide(color: AppColors.borderNavy)),
                ),
                child: Row(
                  children: [
                    if (_currentStep > 1) ...[
                      Expanded(
                        child: CustomButton(
                          text: 'Back',
                          isOutlined: true,
                          onPressed: _prevStep,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: _currentStep == 6 ? 'Publish Listing' : 'Next Step',
                        icon: _currentStep == 6 ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                        isLoading: _isPublishing,
                        onPressed: _nextStep,
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

  String _getStepTag() {
    switch (_currentStep) {
      case 1:
        return 'STEP 1: CATEGORY SELECTION';
      case 2:
        return 'STEP 2: ITEM SPECIFICATIONS';
      case 3:
        return 'STEP 3: MULTI-ANGLE EVIDENCE';
      case 4:
        return 'STEP 4: CALENDAR AVAILABILITY';
      case 5:
        return 'STEP 5: RENTAL PRICING & DEPOSIT';
      case 6:
        return 'STEP 6: LOCATION PRIVACY';
      default:
        return '';
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'What do you want to rent?';
      case 2:
        return 'Enter Item Information';
      case 3:
        return 'Upload 6 Mandatory Photos';
      case 4:
        return 'Set Availability Schedule';
      case 5:
        return 'Set Rates & Security Deposit';
      case 6:
        return 'Pickup Location & Privacy';
      default:
        return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 1:
        return 'Select a standard category or create a custom rental item.';
      case 2:
        return 'Details build buyer confidence and ensure quick verification.';
      case 3:
        return 'Pre-rental baseline photos protect you against damage claims.';
      case 4:
        return 'Choose which days and hours renters can pick up the item.';
      case 5:
        return 'Support hourly, daily, and weekly options for max earnings.';
      case 6:
        return 'Public map shows approximate area. Exact address is private.';
      default:
        return '';
    }
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1Category();
      case 2:
        return _buildStep2BasicInfo();
      case 3:
        return _buildStep3Photos();
      case 4:
        return _buildStep4Availability();
      case 5:
        return _buildStep5Pricing();
      case 6:
        return _buildStep6Location();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1Category() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, i) {
            final cat = _categories[i];
            final isSelected = _selectedCategory == cat['name'];
            return InkWell(
              onTap: () => setState(() => _selectedCategory = cat['name']!),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.amberLight : AppColors.surfaceNavy,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.amberBorder : AppColors.borderNavy,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(cat['emoji']!, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          cat['name']!,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected ? AppColors.amberDeep : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cat['sub']!,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceNavy,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.amberBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.amberDeep, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '$_selectedCategory Handover Rules (Phase 1 MVP)',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _selectedCategory == 'Bikes'
                    ? '• Driving license verification required\n• RC & Insurance check\n• 2 Helmets & fuel policy logging\n• Traffic fines liability agreement'
                    : _selectedCategory == 'Cameras'
                        ? '• Serial number verification on lens mount\n• Lens scratch & sensor dust check\n• Battery & SD card accessory checklist\n• Operational shutter test'
                        : _selectedCategory == 'Electronics'
                            ? '• Serial / IMEI sticker validation\n• Battery health & charger check\n• Screen & ports inspection\n• Renter data wipe acknowledgment'
                            : '• Exact parking slot number / bay\n• Entry/exit access hours\n• Boom barrier RFID card / pass\n• Building security clearance',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _customCategoryCtrl,
          label: 'Custom Subcategory / Item Tag',
          hint: 'e.g. Vintage Telephoto Lens, Covered Basement Slot...',
        ),
      ],
    );
  }

  Widget _buildStep2BasicInfo() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameCtrl,
          label: 'Item Title',
          hint: 'e.g. Sony A7 IV Mirrorless',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _brandCtrl,
                label: 'Brand',
                hint: 'Sony',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                controller: _modelCtrl,
                label: 'Model',
                hint: 'ILCE-7M4',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _yearCtrl,
                label: 'Year',
                hint: '2024',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Condition',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceNavy,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderNavy),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _condition,
                        isExpanded: true,
                        dropdownColor: AppColors.surfaceNavy,
                        style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 13),
                        items: ['Pristine', 'Excellent', 'Good', 'Fair']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _condition = v!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: _descCtrl,
          label: 'Item Description & Included Accessories',
          hint: 'Describe condition, included batteries, chargers, or gear...',
          maxLines: 3,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: _serialCtrl,
          label: 'Serial Number / IMEI / Chassis',
          hint: 'SN-78491024-SY',
          helperText: 'Required for high-value gear to prevent unauthorized part swapping.',
        ),
      ],
    );
  }

  Widget _buildStep3Photos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Multi-Angle Photos (All 6 Mandated)',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.3,
          children: _photoSlots.entries.map((entry) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceNavy,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: entry.value ? AppColors.success.withOpacity(0.6) : AppColors.borderNavy),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    entry.value ? Icons.check_circle_rounded : Icons.add_photo_alternate_rounded,
                    color: entry.value ? AppColors.success : AppColors.amberDeep,
                    size: 26,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.key,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.value ? 'Photo Uploaded ✓' : 'Tap to capture',
                    style: GoogleFonts.plusJakartaSans(
                      color: entry.value ? AppColors.success : AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep4Availability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Days of the Week',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
            final isSelected = _selectedDays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: isSelected,
              selectedColor: AppColors.primaryNavy,
              checkmarkColor: AppColors.white,
              backgroundColor: AppColors.surfaceNavy,
              side: BorderSide(color: isSelected ? AppColors.primaryNavy : AppColors.borderMedium),
              labelStyle: GoogleFonts.plusJakartaSans(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedDays.add(day);
                  } else {
                    _selectedDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          'Daily Handover Time Slots',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceNavy,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderNavy),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: AppColors.amberDeep, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    _availableHours,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const StatusBadge(text: '10 hrs/day', color: AppColors.success),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep5Pricing() {
    return Column(
      children: [
        CustomTextField(
          controller: _hourlyPriceCtrl,
          label: 'Hourly Rate (₹)',
          hint: '150',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.currency_rupee_rounded,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: _dailyPriceCtrl,
          label: 'Daily Rate (₹)',
          hint: '1000',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.currency_rupee_rounded,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: _weeklyPriceCtrl,
          label: 'Weekly Rate (₹)',
          hint: '5800',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.currency_rupee_rounded,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: _depositCtrl,
          label: 'Required Security Deposit (₹)',
          hint: '5000',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.shield_rounded,
          helperText: 'Held in secure escrow and released upon return without damage.',
        ),
      ],
    );
  }

  Widget _buildStep6Location() {
    return Column(
      children: [
        CustomTextField(
          controller: _approxLocCtrl,
          label: 'Public Approximate Location',
          hint: 'Sector 62, Noida',
          prefixIcon: Icons.location_on_outlined,
          helperText: 'Shown on search results to protect your privacy.',
        ),
        const SizedBox(height: 18),
        CustomTextField(
          controller: _exactLocCtrl,
          label: 'Private Exact Handover Address',
          hint: 'Tower B, Candor TechSpace, Sector 62, Noida',
          prefixIcon: Icons.lock_outline_rounded,
          helperText: 'Disclosed only to the renter after you accept their booking.',
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceNavy,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderNavy),
          ),
          child: Row(
            children: [
              const Icon(Icons.privacy_tip_rounded, color: AppColors.amberAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Privacy Shield: Your exact address and phone number remain hidden until the digital rental agreement is executed.',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
