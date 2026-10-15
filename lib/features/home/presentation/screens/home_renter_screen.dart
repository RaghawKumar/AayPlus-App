import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/aay_logo.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/item_details/presentation/screens/item_details_screen.dart';

class HomeRenterScreen extends StatefulWidget {
  const HomeRenterScreen({super.key});
  @override
  State<HomeRenterScreen> createState() => _HomeRenterScreenState();
}

class _HomeRenterScreenState extends State<HomeRenterScreen> {
  final _search = TextEditingController();
  double _maxPrice = 5000, _maxDistance = 30, _minRating = 0;
  String _sort = 'Nearest';
  static const _categories = {
    'All': Icons.apps_rounded,
    'Bikes': Icons.two_wheeler_rounded,
    'Cameras': Icons.camera_alt_outlined,
    'Electronics': Icons.devices_rounded,
    'Parking': Icons.local_parking_rounded,
  };

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _search.clear();
    context.read<AppStateProvider>().setCategory('All');
    setState(() {
      _maxPrice = 5000;
      _maxDistance = 30;
      _minRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final query = _search.text.trim().toLowerCase();
    final items = state.items
        .where(
          (item) =>
              item.isAvailable &&
              (state.selectedCategory == 'All' ||
                  item.category == state.selectedCategory) &&
              '${item.title} ${item.category} ${item.brand}'
                  .toLowerCase()
                  .contains(query) &&
              item.hourlyPrice <= _maxPrice &&
              item.distanceKm <= _maxDistance &&
              item.rating >= _minRating,
        )
        .toList();
    items.sort(
      (a, b) => switch (_sort) {
        'Price: low to high' => a.hourlyPrice.compareTo(b.hourlyPrice),
        'Top rated' => b.rating.compareTo(a.rating),
        _ => a.distanceKm.compareTo(b.distanceKm),
      },
    );
    final filtered = _maxPrice < 5000 || _maxDistance < 30 || _minRating > 0;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ResponsiveContainer(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: AayLogo(size: 36),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton.icon(
                            onPressed: () => state.setRole(UserRoleMode.owner),
                            icon: const Icon(
                              Icons.swap_horiz_rounded,
                              size: 18,
                            ),
                            label: const Text('Host mode'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Less owning.\nMore living.',
                        style: text.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.2,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Discover your next ride, project or adventure.',
                        style: text.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'What would you like to rent?',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _search.clear();
                                    setState(() {});
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 17,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              state.selectedLocation,
                              style: text.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _pickDates(state),
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                            ),
                            label: Text(
                              '${DateFormat('d MMM').format(state.rentalStartDate)} – ${DateFormat('d MMM').format(state.rentalEndDate)}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.handshake_outlined,
                              color: AppColors.amberGlow,
                              size: 30,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Great plans don’t need big purchases.',
                                    style: text.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Compare prices. Meet your host. Make it yours for a while.',
                                    style: text.bodySmall?.copyWith(
                                      color: const Color(0xFFCBD5E1),
                                      height: 1.5,
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
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final name = _categories.keys.elementAt(index);
                      final selected = state.selectedCategory == name;
                      return ChoiceChip(
                        showCheckmark: false,
                        selected: selected,
                        avatar: Icon(
                          _categories[name],
                          size: 18,
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        label: Text(name),
                        onSelected: (_) => state.setCategory(name),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Find your next rental',
                              style: text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -.5,
                              ),
                            ),
                          ),
                          IconButton.filledTonal(
                            tooltip: 'Filter rentals',
                            onPressed: _filters,
                            icon: Badge(
                              isLabelVisible: filtered,
                              child: const Icon(Icons.tune_rounded),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${items.length} ${items.length == 1 ? 'option' : 'options'} nearby',
                              style: text.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            value: _sort,
                            underline: const SizedBox.shrink(),
                            style: text.bodySmall,
                            items:
                                ['Nearest', 'Price: low to high', 'Top rated']
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) =>
                                setState(() => _sort = value!),
                          ),
                        ],
                      ),
                      if (filtered)
                        TextButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.restart_alt, size: 16),
                          label: const Text('Reset filters'),
                        ),
                    ],
                  ),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 16),
                        Text('No rentals found', style: text.titleMedium),
                        const SizedBox(height: 8),
                        const Text(
                          'Try another search or widen your filters.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _reset,
                          child: const Text('Clear search & filters'),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                sliver: SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => _card(items[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(RentalItem item) {
    final text = Theme.of(context).textTheme;
    void open() => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: open,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.9,
                    child: item.photos.isEmpty
                        ? _imageFallback()
                        : Image.network(
                            item.photos.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stack) => _imageFallback(),
                          ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.category,
                        style: text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.star_rounded,
                          size: 17,
                          color: AppColors.amberDeep,
                        ),
                        Text('${item.rating}', style: text.labelMedium),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${item.distanceKm} km away · ${item.approxLocation}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Refundable deposit ₹${NumberFormat('#,##0').format(item.securityDeposit)}',
                      style: text.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Divider(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '₹${item.hourlyPrice.toInt()}',
                                      style: text.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / hour',
                                      style: text.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${item.dailyPrice.toInt()} / day',
                                style: text.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: open,
                          child: const Text('View rental'),
                        ),
                      ],
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

  Widget _imageFallback() => const ColoredBox(
    color: AppColors.elevatedNavy,
    child: Center(
      child: Icon(Icons.image_outlined, size: 40, color: AppColors.textMuted),
    ),
  );

  Future<void> _pickDates(AppStateProvider state) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final dates = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Choose rental dates',
    );
    if (dates != null && mounted) {
      state.setDates(
        dates.start,
        dates.end.isAfter(dates.start)
            ? dates.end
            : dates.start.add(const Duration(days: 1)),
      );
    }
  }

  Future<void> _filters() async {
    var price = _maxPrice, distance = _maxDistance, rating = _minRating;
    final applied = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, update) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make it a perfect fit',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                Text('Within ${distance.toInt()} km'),
                Slider(
                  value: distance,
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: '${distance.toInt()} km',
                  onChanged: (v) => update(() => distance = v),
                ),
                Text('Up to ₹${price.toInt()} / hour'),
                Slider(
                  value: price,
                  min: 50,
                  max: 5000,
                  divisions: 99,
                  label: '₹${price.toInt()}',
                  onChanged: (v) => update(() => price = v),
                ),
                Text(
                  rating == 0
                      ? 'Any rating'
                      : 'Rated ${rating.toStringAsFixed(1)} or higher',
                ),
                Slider(
                  value: rating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  onChanged: (v) => update(() => rating = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => update(() {
                        price = 5000;
                        distance = 30;
                        rating = 0;
                      }),
                      child: const Text('Reset'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => Navigator.pop(sheetContext, true),
                      child: const Text('Show results'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (applied == true && mounted)
      setState(() {
        _maxPrice = price;
        _maxDistance = distance;
        _minRating = rating;
      });
  }
}
