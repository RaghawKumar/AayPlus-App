import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/listing_creation/presentation/screens/create_listing_wizard_screen.dart';
import 'package:aay_plus/features/navigation/presentation/screens/main_navigation_shell.dart';

class OwnerInventoryScreen extends StatefulWidget {
  const OwnerInventoryScreen({super.key});

  @override
  State<OwnerInventoryScreen> createState() => _OwnerInventoryScreenState();
}

class _OwnerInventoryScreenState extends State<OwnerInventoryScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Bikes',
    'Cameras',
    'Electronics',
    'Parking',
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final user = state.currentUser;

    final filteredItems = _selectedCategory == 'All'
        ? state.items
        : state.items.where((i) => i.category == _selectedCategory).toList();

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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.amberLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.amberBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inventory_2_rounded,
                  size: 14,
                  color: AppColors.amberDeep,
                ),
                const SizedBox(width: 5),
                Text(
                  'MY INVENTORY',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.amberDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Switch to Renter Mode Toggle
          GestureDetector(
            onTap: () {
              state.setRole(UserRoleMode.renter);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Switched to Renter Mode 🎒 — Browse, book & track rentals with escrow protection.'),
                  backgroundColor: AppColors.primaryNavy,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceNavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderNavy),
              ),
              child: Row(
                children: [
                  const Text('🔑', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 4),
                  Text(
                    'Host',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.amberDeep,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(width: 1, height: 11, color: AppColors.borderNavy),
                  const SizedBox(width: 5),
                  const Icon(Icons.swap_horiz_rounded, size: 14, color: AppColors.textPrimary),
                  const SizedBox(width: 2),
                  Text(
                    'Renter',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              // Host Profile & Stats Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderNavy),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  user.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, color: AppColors.success, size: 15),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${state.items.length} Rentable Items Listed • 42 Completed Hostings',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardNavy,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderNavy),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Earnings',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textMuted,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '₹34,800',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.amberDeep,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // + List Item Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: CustomButton(
                  text: '+ List Another Item for Rent',
                  icon: Icons.add_circle_outline_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateListingWizardScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Category Filter Pills
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSel = _selectedCategory == cat;
                    final count = cat == 'All'
                        ? state.items.length
                        : state.items.where((i) => i.category == cat).length;

                    return FilterChip(
                      label: Text('$cat ($count)'),
                      selected: isSel,
                      selectedColor: AppColors.amberLight,
                      backgroundColor: AppColors.surfaceNavy,
                      labelStyle: GoogleFonts.plusJakartaSans(
                        color: isSel ? AppColors.amberDeep : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSel ? AppColors.amberBorder : AppColors.borderNavy,
                      ),
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Inventory Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, i) {
                    final item = filteredItems[i];
                    final isLiveRented = item.id == state.activeBooking.item.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceNavy,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLiveRented ? AppColors.amberBorder : AppColors.borderNavy,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.photos.first,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isLiveRented)
                                          const StatusBadge(
                                            text: 'RENTED OUT 🟢',
                                            color: AppColors.success,
                                          )
                                        else
                                          const StatusBadge(
                                            text: 'Active',
                                            color: AppColors.success,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${item.category} • ${item.subcategory}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textMuted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${item.hourlyPrice.toInt()}/hr • ₹${item.dailyPrice.toInt()}/day',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.amberDeep,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.borderNavy, height: 1),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.shield_outlined, color: AppColors.amberDeep, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Deposit: ₹${item.securityDeposit.toInt()}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 14),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  item.approxLocation,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.isAvailable ? 'Available' : 'Paused',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: item.isAvailable ? AppColors.success : AppColors.textMuted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: item.isAvailable,
                                      activeThumbColor: AppColors.primaryNavy,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (val) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${item.title} ${val ? 'marked Available' : 'paused'}.'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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
