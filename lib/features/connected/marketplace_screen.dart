import 'dart:async';
import 'marketplace_widgets.dart';
import 'account_section.dart';
import 'inspection_media_screen.dart';
import 'package:aay_plus/core/logging/dev_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/features/auth/presentation/screens/login_otp_screen.dart';

String rupees(dynamic paise) =>
    '₹${NumberFormat('#,##0.##').format((paise as num) / 100)}';
String when(dynamic seconds) => DateFormat(
  'd MMM, h:mm a',
).format(DateTime.fromMillisecondsSinceEpoch((seconds as num).toInt() * 1000));

class ConnectedGate extends StatelessWidget {
  const ConnectedGate({super.key});
  @override
  Widget build(BuildContext context) =>
      context.watch<AppStateProvider>().signedIn
      ? const MarketplaceScreen()
      : const LoginOtpScreen();
}

class MarketplaceScreen extends StatefulWidget {
  final int initialIndex;
  const MarketplaceScreen({super.key, this.initialIndex = 0});
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late int index;
  Timer? timer;
  String query = '', category = 'All', sort = 'Newest';
  late final AnimationController tabMotion;
  String? actionError;
  bool acting = false;
  @override
  void initState() {
    super.initState();
    tabMotion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();
    DevLog.screen('Marketplace');
    index = widget.initialIndex.clamp(0, 3);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AppStateProvider>().refresh();
    });
    timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) context.read<AppStateProvider>().refresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AppStateProvider>().refresh();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    tabMotion.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> act(Future<dynamic> Function() fn) async {
    DevLog.action('Account or listing action');
    if (acting) return;
    setState(() {
      acting = true;
      actionError = null;
    });
    try {
      await fn();
    } catch (e) {
      if (mounted) setState(() => actionError = e.toString());
    } finally {
      if (mounted) setState(() => acting = false);
    }
  }

  Widget empty(String title, String description) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
    child: Column(
      children: [
        const Icon(Icons.inbox_outlined, size: 42, color: AppColors.textMuted),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(description, textAlign: TextAlign.center),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final host = state.currentRole == UserRoleMode.owner;
    final pages = [
      explore(state),
      rentals(state, host),
      inventory(state),
      account(state),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            'Explore',
            host ? 'Hosting' : 'My rentals',
            'My listings',
            'Your account',
          ][index],
        ),
        actions: [
          IconButton(
            tooltip: 'How it works',
            icon: const Icon(Icons.route_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'How it works'),
                builder: (_) => const RentalFlowScreen(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Refresh shared data',
            onPressed: state.busy
                ? null
                : () {
                    DevLog.action('Refresh marketplace');
                    state.refresh();
                  },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.busy || acting) const LinearProgressIndicator(minHeight: 2),
          if (state.error != null || actionError != null)
            MaterialBanner(
              content: Text(actionError ?? state.error!),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => actionError = null);
                    state.refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: FadeTransition(
                  opacity: MediaQuery.disableAnimationsOf(context)
                      ? const AlwaysStoppedAnimation(1)
                      : tabMotion,
                  child: IndexedStack(index: index, children: pages),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          DevLog.screen(
            ['Explore', 'Rentals', 'My listings', 'Account'][value],
          );
          if (value == index) return;
          setState(() => index = value);
          tabMotion.forward(
            from: MediaQuery.disableAnimationsOf(context) ? 1 : 0,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Rentals',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Listings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget explore(AppStateProvider state) {
    final rows = state.listingRows
        .where(
          (row) =>
              row['owner_id'] != state.currentUser.id &&
              (category == 'All' || row['category'] == category) &&
              '${row['title']} ${row['description']} ${row['location']}'
                  .toLowerCase()
                  .contains(query.toLowerCase()),
        )
        .toList();
    if (sort != 'Newest')
      rows.sort(
        (a, b) => sort == 'Price: low to high'
            ? (a['hourly_paise'] as num).compareTo(b['hourly_paise'])
            : (b['hourly_paise'] as num).compareTo(a['hourly_paise']),
      );
    return RefreshIndicator(
      onRefresh: state.refresh,
      child: ListView(
        key: const PageStorageKey('explore'),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Reveal(
            child: FeatureBanner(
              eyebrow: 'Good plans start here',
              title: 'Less owning.\nMore living.',
              subtitle:
                  'For the weekend ride. The big idea. The moments worth making.',
              action: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.near_me_outlined,
                    size: 14,
                    color: Color(0xFFFFCC76),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      'Rent from your community',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              hintText: 'Search rentals or locations',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: ['All', 'Bikes', 'Cameras', 'Electronics', 'Parking'].map(
              (value) {
                final selected = category == value;
                return Semantics(
                  button: true,
                  selected: selected,
                  label: '$value category',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        DevLog.action('Filter category: $value');
                        setState(() => category = value);
                      },
                      child: AnimatedContainer(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 180),
                        constraints: const BoxConstraints(minHeight: 48),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? ink : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? ink : AppColors.borderNavy,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categoryIcon(value),
                              size: 18,
                              color: selected ? Colors.white : ink,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              value,
                              style: TextStyle(
                                color: selected ? Colors.white : ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          if (!state.currentUser.identityVerified)
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Card(
                color: warm,
                child: ListTile(
                  leading: const Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.amberDeep,
                  ),
                  title: const Text(
                    'One step closer to your first rental',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Verify your account before renting or hosting.',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => setState(() => index = 3),
                ),
              ),
            ),
          const SectionTitle(
            'Find your next possibility',
            'Browse real listings. Choose the time that works for you.',
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${rows.length} ${rows.length == 1 ? 'rental' : 'rentals'} to explore',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              DropdownButton<String>(
                value: sort,
                underline: const SizedBox.shrink(),
                style: Theme.of(context).textTheme.bodySmall,
                items: ['Newest', 'Price: low to high', 'Price: high to low']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => sort = v!),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (rows.isEmpty)
            empty(
              'No rentals found',
              'Try another search, or check back when hosts add items.',
            ),
          ...rows.map(
            (row) => ListingTile(
              key: ValueKey(row['id']),
              row: row,
              mediaUrl: state.api.mediaUrl,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'Listing details'),
                  builder: (_) => ListingRequestScreen(listing: row),
                ),
              ),
            ),
          ),
          Card(
            color: warm,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.route_outlined, color: AppColors.amberDeep),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'New to renting? We’ll walk you through it.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RentalFlowScreen(),
                      ),
                    ),
                    child: const Text('See how'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rentals(AppStateProvider state, bool host) {
    final rows = state.bookingRows
        .where(
          (row) => row[host ? 'owner_id' : 'renter_id'] == state.currentUser.id,
        )
        .toList();
    return RefreshIndicator(
      onRefresh: state.refresh,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Reveal(
            child: FeatureBanner(
              eyebrow: host ? 'Your host hub' : 'Your rental journal',
              title: host
                  ? 'Good things.\nIn good hands.'
                  : 'Your next chapter,\nalready in motion.',
              subtitle: host
                  ? 'Review requests, prepare handovers and follow every return.'
                  : 'From the first request to the final return, it’s all here.',
              icon: Icons.calendar_month_outlined,
            ),
          ),
          const SizedBox(height: 22),
          SegmentedButton<UserRoleMode>(
            segments: const [
              ButtonSegment(value: UserRoleMode.renter, label: Text('Renting')),
              ButtonSegment(value: UserRoleMode.owner, label: Text('Hosting')),
            ],
            selected: {state.currentRole},
            onSelectionChanged: (v) => state.setRole(v.first),
          ),
          const SizedBox(height: 20),
          if (rows.isEmpty)
            empty(
              'Nothing here yet',
              host
                  ? 'Booking requests for your listings will appear here.'
                  : 'Request a rental from Explore to get started.',
            ),
          ...rows.map(
            (row) => BookingSummaryCard(
              booking: row,
              hosting: host,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'Booking details'),
                  builder: (_) => BookingScreen(id: row['id']),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inventory(AppStateProvider state) => RefreshIndicator(
    onRefresh: state.refresh,
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Reveal(
          child: FeatureBanner(
            eyebrow: 'Made to be shared',
            title: 'Make your things\nwork for you.',
            subtitle:
                'A clear listing today. Someone’s next great plan tomorrow.',
            icon: Icons.inventory_2_outlined,
          ),
        ),
        SectionTitle(
          'Your collection',
          '${state.ownListingRows.where((r) => r['active'] == true).length} active · ${state.ownListingRows.where((r) => r['active'] != true).length} archived',
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListingEditorScreen()),
          ),
          icon: const Icon(Icons.add),
          label: const Text('List an item'),
        ),
        if (state.ownListingRows.isEmpty)
          empty(
            'Your first listing starts here',
            'Verified accounts can add items and receive rental requests.',
          ),
        ...state.ownListingRows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Card(
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HostListingScreen(listing: row),
                  ),
                ),
                leading: Icon(categoryIcon(row['category']), color: ink),
                title: Text(row['title']),
                subtitle: Text(
                  '${row['active'] == true ? 'Active' : 'Archived'} · ${rupees(row['hourly_paise'])} / hour',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  Widget account(AppStateProvider state) => AccountSection(
    state: state,
    busy: acting,
    onEdit: () async {
      final values = await editFields(context, 'Edit your profile', {
        'name': state.currentUser.name,
        'email': state.currentUser.email,
      });
      if (values != null && mounted) {
        await act(() => state.mutate('/me', values, method: 'PATCH'));
      }
    },
    onSignOut: () => act(state.signOut),
  );
}

Future<Map<String, dynamic>?> editFields(
  BuildContext context,
  String title,
  Map<String, String> fields,
) async {
  final controllers = fields.map(
    (key, value) => MapEntry(key, TextEditingController(text: value)),
  );
  try {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: controllers.entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: entry.key.replaceAll('_', ' '),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              ctx,
              controllers.map((key, value) => MapEntry(key, value.text.trim())),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  } finally {
    // The dialog route releases its fields after its exit animation.
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      for (final c in controllers.values) {
        c.dispose();
      }
    });
  }
}

class ListingRequestScreen extends StatefulWidget {
  final Map<String, dynamic> listing;
  const ListingRequestScreen({super.key, required this.listing});
  @override
  State<ListingRequestScreen> createState() => _ListingRequestScreenState();
}

class _ListingRequestScreenState extends State<ListingRequestScreen> {
  late DateTime start, end;
  Map<String, dynamic>? quote;
  bool busy = false;
  String? error;
  @override
  void initState() {
    super.initState();
    DevLog.screen('Listing details');
    final state = context.read<AppStateProvider>();
    start = state.rentalStartDate;
    end = state.rentalEndDate;
  }

  Future<void> choose(bool beginning) async {
    DevLog.action(beginning ? 'Choose pickup date' : 'Choose return date');
    final day = await showDatePicker(
      context: context,
      initialDate: beginning ? start : end,
      firstDate: DateUtils.dateOnly(DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(beginning ? start : end),
    );
    if (time == null || !mounted) return;
    setState(() {
      final date = DateTime(
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      );
      if (beginning) {
        start = date;
      } else {
        end = date;
      }
      quote = null;
    });
  }

  Future<void> submit() async {
    DevLog.action(
      quote == null ? 'Check availability and price' : 'Send booking request',
    );
    final state = context.read<AppStateProvider>();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final data = {
        'listing_id': widget.listing['id'],
        'start': start.toUtc().toIso8601String(),
        'end': end.toUtc().toIso8601String(),
      };
      if (quote == null) {
        final result = await state.api.request(
          '/bookings/quote',
          method: 'POST',
          body: data,
        );
        if (mounted) setState(() => quote = Map<String, dynamic>.from(result));
      } else {
        final result = await state.mutate('/bookings', data);
        state.setDates(start, end);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BookingScreen(id: result['id'])),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          quote = null;
        });
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.listing;
    return Scaffold(
      appBar: AppBar(title: const Text('Plan your rental')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if ((row['photos'] as List).isNotEmpty) ...[
                SizedBox(
                  height: 220,
                  child: PageView(
                    children: (row['photos'] as List)
                        .map(
                          (photo) => ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              context.read<AppStateProvider>().api.mediaUrl(
                                photo,
                              ),
                              fit: BoxFit.cover,
                              errorBuilder: (_, error, stack) => const Center(
                                child: Icon(Icons.image_outlined, size: 40),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(row['photos'] as List).length} photos · Swipe to view',
                ),
                const SizedBox(height: 20),
              ],
              Text(
                row['title'],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${row['location']} · Hosted by ${row['owner_name'] ?? 'a community member'}',
              ),
              const SizedBox(height: 20),
              const SectionTitle(
                'About this item',
                'The details, straight from your host.',
              ),
              Text(
                row['description'],
                style: const TextStyle(
                  height: 1.8,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(
                'A plan for every occasion',
                'Compare packages before choosing your dates.',
              ),
              Row(
                children: ['hourly', 'daily', 'weekly']
                    .map(
                      (period) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: period == 'daily' ? warm : Colors.white,
                            border: Border.all(color: AppColors.borderNavy),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                period == 'hourly'
                                    ? Icons.schedule
                                    : period == 'daily'
                                    ? Icons.wb_sunny_outlined
                                    : Icons.date_range_outlined,
                                size: 20,
                                color: ink,
                              ),
                              const SizedBox(height: 12),
                              FittedBox(
                                child: Text(
                                  rupees(row['${period}_paise']),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                period,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.shield_outlined,
                    color: AppColors.amberDeep,
                  ),
                  title: Text(
                    'Refundable deposit ${rupees(row['deposit_paise'])}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Any damage claim is reviewed before settlement.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              const SectionTitle(
                'Make time for it',
                'Choose pickup and return. We’ll check availability for you.',
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Pickup'),
                subtitle: Text(DateFormat('d MMM yyyy, h:mm a').format(start)),
                trailing: const Icon(Icons.edit_calendar),
                onTap: busy ? null : () => choose(true),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Return'),
                subtitle: Text(DateFormat('d MMM yyyy, h:mm a').format(end)),
                trailing: const Icon(Icons.edit_calendar),
                onTap: busy ? null : () => choose(false),
              ),
              if (quote != null)
                Reveal(
                  key: const ValueKey("quote"),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your quote · ${quote!['hours']} hours',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Rental: ${rupees(quote!['rental_paise'])}\nPlatform fee: ${rupees(quote!['fee_paise'])}\nRefundable deposit: ${rupees(quote!['deposit_paise'])}',
                          ),
                          const Divider(),
                          Text(
                            'Total: ${rupees(quote!['total_paise'])}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'The server checks availability and chooses the best hourly, daily or weekly price. Your host must approve the request. Payments are not yet collected.',
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: busy ? null : submit,
                child: Text(
                  busy
                      ? 'Please wait…'
                      : quote == null
                      ? 'Check availability & price'
                      : 'Send booking request',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HostListingScreen extends StatefulWidget {
  final Map<String, dynamic> listing;
  const HostListingScreen({super.key, required this.listing});
  @override
  State<HostListingScreen> createState() => _HostListingScreenState();
}

class _HostListingScreenState extends State<HostListingScreen> {
  bool saving = false;
  int photoIndex = 0;
  String? error;

  Future<void> changeVisibility(Map<String, dynamic> row) async {
    if (saving) return;
    final state = context.read<AppStateProvider>();
    final active = row['active'] == true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(active ? 'Archive this listing?' : 'Restore this listing?'),
        content: Text(
          active
              ? 'It will be hidden from Explore and stop accepting new requests. Existing bookings stay available.'
              : 'It will appear in Explore and accept new rental requests again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(active ? 'Archive' : 'Restore'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await state.mutate('/listings/${row['id']}', {
        'active': !active,
      }, method: 'PATCH');
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    var row = widget.listing;
    for (final item in state.ownListingRows) {
      if (item['id'] == row['id']) {
        row = item;
        break;
      }
    }
    final current = row;
    final theme = Theme.of(context).textTheme;
    final photos = List<String>.from(row['photos']);
    final active = row['active'] == true;
    final bookings = state.bookingRows
        .where(
          (b) =>
              b['listing_id'] == row['id'] &&
              b['owner_id'] == state.currentUser.id,
        )
        .toList();
    Widget fallback() => ColoredBox(
      color: AppColors.elevatedNavy,
      child: Center(
        child: Icon(
          categoryIcon(row['category']),
          size: 72,
          color: AppColors.textMuted,
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Listing details')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: RefreshIndicator(
            onRefresh: state.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1.4,
                    child: photos.isEmpty
                        ? fallback()
                        : PageView(
                            onPageChanged: (i) =>
                                setState(() => photoIndex = i),
                            children: photos
                                .map(
                                  (url) => Image.network(
                                    state.api.mediaUrl(url),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, error, stack) =>
                                        fallback(),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ),
                if (photos.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '${photoIndex.clamp(0, photos.length - 1) + 1} of ${photos.length} photos · Swipe to browse',
                      textAlign: TextAlign.center,
                      style: theme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: Icon(categoryIcon(row['category']), size: 16),
                      label: Text(row['category']),
                    ),
                    Chip(
                      avatar: Icon(
                        active
                            ? Icons.visibility_outlined
                            : Icons.archive_outlined,
                        size: 16,
                        color: active ? AppColors.success : AppColors.textMuted,
                      ),
                      label: Text(active ? 'Active' : 'Archived'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(row['title'], style: theme.headlineSmall),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(row['location'], style: theme.bodyMedium),
                    ),
                  ],
                ),
                const SectionTitle(
                  'About this item',
                  'What renters will see on your listing.',
                ),
                Text(row['description'], style: theme.bodyLarge),
                const SectionTitle(
                  'Your rental prices',
                  'Updated prices apply to new bookings.',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        for (final entry in {
                          'Per hour': 'hourly_paise',
                          'Per day': 'daily_paise',
                          'Per week': 'weekly_paise',
                          'Refundable deposit': 'deposit_paise',
                        }.entries)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: theme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    rupees(row[entry.value]),
                                    style: theme.titleMedium,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  active
                      ? 'Visible in Explore. Renters can request available dates.'
                      : 'Hidden from Explore. Restore it when you’re ready to accept requests.',
                  style: theme.bodySmall,
                ),
                SectionTitle(
                  'Bookings for this item',
                  '${bookings.length} ${bookings.length == 1 ? 'booking' : 'bookings'}',
                ),
                if (bookings.isEmpty)
                  const Text(
                    'New booking requests for this listing will appear here.',
                  ),
                ...bookings.map(
                  (booking) => BookingSummaryCard(
                    booking: booking,
                    hosting: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(id: booking['id']),
                      ),
                    ),
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      error!,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: saving
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ListingEditorScreen(listing: current),
                          ),
                        ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit listing'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: saving ? null : () => changeVisibility(current),
                  icon: Icon(
                    active ? Icons.archive_outlined : Icons.unarchive_outlined,
                    size: 18,
                  ),
                  label: Text(
                    saving
                        ? 'Saving…'
                        : active
                        ? 'Archive'
                        : 'Restore',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListingEditorScreen extends StatefulWidget {
  final ImagePicker? imagePicker;
  final Map<String, dynamic>? listing;
  const ListingEditorScreen({super.key, this.imagePicker, this.listing});
  @override
  State<ListingEditorScreen> createState() => _ListingEditorScreenState();
}

class _ListingEditorScreenState extends State<ListingEditorScreen> {
  late final ImagePicker picker = widget.imagePicker ?? ImagePicker();
  final selectedPhotos = <_ListingPhoto>[];
  final existingPhotos = <String>[];
  int get photoCount => selectedPhotos.length + existingPhotos.length;
  bool picking = false;
  String? uploadStatus;
  @override
  void initState() {
    super.initState();
    DevLog.screen(widget.listing == null ? 'Create listing' : 'Edit listing');
    final row = widget.listing;
    if (row != null) {
      for (final key in ['title', 'description', 'location']) {
        fields[key]!.text = row[key];
      }
      for (final entry in {
        'hourly price': 'hourly_paise',
        'daily price': 'daily_paise',
        'weekly price': 'weekly_paise',
        'deposit': 'deposit_paise',
      }.entries) {
        fields[entry.key]!.text = ((row[entry.value] as num) / 100)
            .toStringAsFixed(2);
      }
      category = row['category'];
      existingPhotos.addAll(List<String>.from(row['photos']));
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
      recoverPhotos();
  }

  Future<void> recoverPhotos() async {
    try {
      final recovered = await picker.retrieveLostData();
      if (recovered.files != null) await addPhotos(recovered.files!);
      if (recovered.exception != null && mounted)
        setState(
          () => error =
              'Could not recover the selected photo. Please choose it again.',
        );
    } catch (_) {
      /* Normal selection remains available if recovery is unsupported. */
    }
  }

  Future<void> addPhotos(List<XFile> files) async {
    for (final file in files) {
      if (!mounted || photoCount >= 12) return;
      if (await file.length() > 8 * 1024 * 1024) {
        if (mounted)
          setState(() => error = 'Each photo must be smaller than 8 MB.');
        continue;
      }
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => selectedPhotos.add(_ListingPhoto(bytes)));
    }
  }

  Future<void> pickPhotos(ImageSource source) async {
    if (picking || busy || photoCount >= 12) return;
    FocusScope.of(context).unfocus();
    DevLog.action(
      source == ImageSource.camera ? 'Take photo' : 'Choose photos',
    );
    setState(() {
      picking = true;
      error = null;
    });
    try {
      if (source == ImageSource.camera) {
        final file = await picker.pickImage(
          source: source,
          imageQuality: 85,
          maxWidth: 1600,
          maxHeight: 1600,
          requestFullMetadata: false,
        );
        if (file != null) await addPhotos([file]);
      } else {
        final files = await picker.pickMultiImage(
          limit: 12 - photoCount,
          imageQuality: 85,
          maxWidth: 1600,
          maxHeight: 1600,
          requestFullMetadata: false,
        );
        await addPhotos(files);
      }
    } on MissingPluginException {
      DevLog.event('picker.error', {
        'type': 'missing-plugin',
        'source': source.name,
      });
      if (mounted)
        setState(() => error = _pickerError('channel-error', source));
    } on PlatformException catch (e) {
      DevLog.event('picker.error', {
        'type': e.code,
        'message': e.message,
        'source': source.name,
      });
      if (mounted) setState(() => error = _pickerError(e.code, source));
    } catch (e) {
      DevLog.event('picker.error', {
        'type': e.runtimeType.toString(),
        'source': source.name,
      });
      if (mounted)
        setState(
          () => error = 'Could not read that photo. Please try another image.',
        );
    } finally {
      if (mounted) setState(() => picking = false);
    }
  }

  String _pickerError(String type, ImageSource source) {
    switch (type) {
      case 'channel-error':
        return kDebugMode
            ? 'Photo picker is missing from this build. Stop the app completely, run pod install in ios, then run flutter run again. Hot reload is not enough.'
            : 'Photos are unavailable in this version. Please update or reinstall the app.';
      case 'camera_access_denied':
      case 'photo_access_denied':
      case 'photo_access_denied_without_prompt':
        return 'Allow camera or photo access for AayPlus in your phone settings, then try again.';
      case 'camera_access_restricted':
      case 'photo_access_restricted':
        return 'Camera or photo access is restricted on this device. Check your device restrictions.';
      case 'invalid_source':
      case 'camera_unavailable':
        return 'No camera is available on this device. Choose photos instead.';
      case 'multiple_request':
      case 'already_active':
        return 'A photo picker is already open. Finish or close it before trying again.';
      default:
        return source == ImageSource.camera
            ? 'Could not take the photo. Please try again or choose a photo from your library.'
            : 'Could not load the selected photos. Try another photo from your library.';
    }
  }

  final form = GlobalKey<FormState>();
  final fields = {
    for (final key in [
      'title',
      'description',
      'location',
      'hourly price',
      'daily price',
      'weekly price',
      'deposit',
    ])
      key: TextEditingController(),
  };
  String category = 'Cameras';
  bool busy = false;
  String? error;
  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    DevLog.action('Publish listing');
    if (busy || picking || !form.currentState!.validate()) return;
    final state = context.read<AppStateProvider>();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final urls = [...existingPhotos];
      for (var i = 0; i < selectedPhotos.length; i++) {
        if (mounted)
          setState(
            () => uploadStatus =
                'Uploading photo ${i + 1} of ${selectedPhotos.length}…',
          );
        final photo = selectedPhotos[i];
        photo.url ??= await state.api.uploadImage(photo.bytes);
        urls.add(photo.url!);
      }
      if (mounted)
        setState(
          () => uploadStatus = widget.listing == null
              ? 'Publishing listing…'
              : 'Saving changes…',
        );
      if (!mounted) return;
      await state.mutate(
        widget.listing == null
            ? '/listings'
            : '/listings/${widget.listing!['id']}',
        {
          'title': fields['title']!.text.trim(),
          'description': fields['description']!.text.trim(),
          'location': fields['location']!.text.trim(),
          'category': category,
          'hourly_paise': (double.parse(fields['hourly price']!.text) * 100)
              .round(),
          'daily_paise': (double.parse(fields['daily price']!.text) * 100)
              .round(),
          'weekly_paise': (double.parse(fields['weekly price']!.text) * 100)
              .round(),
          'deposit_paise': (double.parse(fields['deposit']!.text) * 100)
              .round(),
          'photos': urls,
        },
        method: widget.listing == null ? 'POST' : 'PATCH',
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.listing == null ? 'List an item' : 'Edit listing'),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Form(
          key: form,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Reveal(
                child: FeatureBanner(
                  eyebrow: widget.listing == null
                      ? 'Create something worth sharing'
                      : 'Keep your listing up to date',
                  title: widget.listing == null
                      ? 'Your item.\nTheir next adventure.'
                      : 'A little update.\nA better listing.',
                  subtitle: widget.listing == null
                      ? 'Great photos and thoughtful details make a great first impression.'
                      : 'Update details, photos and prices. Existing bookings keep their recorded amounts.',
                  icon: Icons.add_photo_alternate_outlined,
                ),
              ),
              const SectionTitle(
                'Start with the essentials',
                'Use a clear title, helpful description and accurate prices.',
              ),
              if (!context
                  .watch<AppStateProvider>()
                  .currentUser
                  .identityVerified)
                Card(
                  color: warm,
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Verification needed before publishing. Ask your administrator to verify your account in Members & verification. Your listing can be drafted here.',
                      style: TextStyle(fontSize: 12, height: 1.7),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Bikes', 'Cameras', 'Electronics', 'Parking']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: busy ? null : (v) => setState(() => category = v!),
              ),
              ...fields.entries.map((entry) {
                final numeric = [
                  'hourly price',
                  'daily price',
                  'weekly price',
                  'deposit',
                ].contains(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: entry.value,
                    enabled: !busy,
                    keyboardType: numeric
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                    maxLines: entry.key == 'description' ? 3 : 1,
                    decoration: InputDecoration(
                      labelText: entry.key,
                      prefixText: numeric ? '₹ ' : null,
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (numeric) {
                        final n = double.tryParse(v);
                        return n != null &&
                                n.isFinite &&
                                n >= (entry.key == 'deposit' ? 0 : .01) &&
                                n <= 1000000
                            ? null
                            : 'Enter a valid price';
                      }
                      return v.isEmpty ? 'This field is required' : null;
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
              Text(
                'Item photos',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add up to 12 photos. The first photo is your cover. Each photo can be up to 8 MB.',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: busy || picking || photoCount >= 12
                        ? null
                        : () => pickPhotos(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Choose photos'),
                  ),
                  OutlinedButton.icon(
                    onPressed: busy || picking || photoCount >= 12
                        ? null
                        : () => pickPhotos(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Take photo'),
                  ),
                ],
              ),
              if (picking)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: LinearProgressIndicator(),
                ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...existingPhotos.asMap().entries.map(
                    (entry) => SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              context.read<AppStateProvider>().api.mediaUrl(
                                entry.value,
                              ),
                              fit: BoxFit.cover,
                              errorBuilder: (_, error, stack) => const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            ),
                          ),
                          if (entry.key == 0)
                            const Positioned(
                              bottom: 6,
                              left: 6,
                              child: Chip(label: Text('Cover')),
                            ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: IconButton.filled(
                              tooltip: 'Remove existing photo ${entry.key + 1}',
                              onPressed: busy || picking
                                  ? null
                                  : () => setState(
                                      () => existingPhotos.removeAt(entry.key),
                                    ),
                              icon: const Icon(Icons.close, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...List.generate(
                    selectedPhotos.length,
                    (i) => SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              selectedPhotos[i].bytes,
                              fit: BoxFit.cover,
                              errorBuilder: (_, error, stack) => const Center(
                                child: Text('Preview unavailable'),
                              ),
                            ),
                          ),
                          if (i == 0 && existingPhotos.isEmpty)
                            const Positioned(
                              bottom: 6,
                              left: 6,
                              child: Chip(label: Text('Cover')),
                            ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: IconButton.filled(
                              tooltip: 'Remove photo ${i + 1}',
                              onPressed: busy || picking
                                  ? null
                                  : () {
                                      DevLog.action('Remove listing photo');
                                      setState(
                                        () => selectedPhotos.removeAt(i),
                                      );
                                    },
                              icon: const Icon(Icons.close, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: busy || picking ? null : save,
                child: Text(
                  busy
                      ? uploadStatus ?? 'Saving…'
                      : widget.listing == null
                      ? 'Publish listing'
                      : 'Save changes',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class BookingScreen extends StatefulWidget {
  final String id;
  const BookingScreen({super.key, required this.id});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Map<String, dynamic>? booking;
  String? error;
  bool busy = false, loading = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    DevLog.screen('Booking details');
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
    timer = Timer.periodic(const Duration(seconds: 15), (_) => load());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    if (!mounted || loading) return;
    loading = true;
    try {
      final result = await context.read<AppStateProvider>().api.request(
        '/bookings/${widget.id}',
      );
      if (mounted) {
        setState(() {
          booking = Map<String, dynamic>.from(result);
          error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      loading = false;
    }
  }

  Future<void> action(
    String action, [
    Map<String, dynamic> data = const {},
  ]) async {
    if (busy) return;
    DevLog.action('Booking: $action');
    final state = context.read<AppStateProvider>();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await state.mutate('/bookings/${widget.id}/$action', data);
      await load();
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget button(String label, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: FilledButton(
      onPressed: busy
          ? null
          : () {
              DevLog.action(label);
              onTap();
            },
      child: Text(label),
    ),
  );
  Future<void> inspection(String kind) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: '$kind inspection'),
        builder: (_) => InspectionMediaScreen(
          bookingId: widget.id,
          kind: kind,
          pickupAt: booking == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  booking!['start_at'] * 1000,
                ),
        ),
      ),
    );
    if (saved == true && mounted) await load();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>(), b = booking;
    final owner = b?['owner_id'] == state.currentUser.id;
    final status = b?['status'];
    final disputes = state.disputeRows
        .where((d) => d['booking_id'] == widget.id)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental details'),
        actions: [
          IconButton(
            onPressed: load,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh booking',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (busy || b == null && error == null)
                const LinearProgressIndicator(),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (b != null) ...[
                Reveal(child: RentalProgress(status: b['status'])),
                const SizedBox(height: 24),
                Text(
                  b['listing']['title'],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Status: ${status.toString().replaceAll('_', ' ')}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  'Host: ${b['owner_name']}\nRenter: ${b['renter_name']}\n${when(b['start_at'])} → ${when(b['end_at'])}',
                ),
                const Divider(height: 36),
                Text(
                  'Rental ${rupees(b['rental_paise'])}\nPlatform fee ${rupees(b['fee_paise'])}\nRefundable deposit ${rupees(b['deposit_paise'])}',
                ),
                const SizedBox(height: 12),
                const Text(
                  'No payment has been collected. Payment services are not configured.',
                ),
                const SizedBox(height: 24),
                if (status == 'requested') ...[
                  Text(
                    owner
                        ? 'Review this request before approving.'
                        : 'Request sent. Waiting for the host to approve.',
                  ),
                  const SizedBox(height: 16),
                  if (owner) ...[
                    button('Approve request', () => action('approve')),
                    button('Decline request', () => action('reject')),
                  ],
                ],
                if (status == 'approved') ...[
                  Text(
                    'Agreement: host ${b['owner_signed'] == 1 ? 'signed' : 'pending'} · renter ${b['renter_signed'] == 1 ? 'signed' : 'pending'}',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'By acknowledging, you agree to return the item at the agreed time, document its condition, and submit any damage concerns for review. This records an account acknowledgement, not a legal e-signature.',
                  ),
                  const SizedBox(height: 16),
                  if (b[owner ? 'owner_signed' : 'renter_signed'] != 1)
                    button('Acknowledge rental terms', () => action('sign')),
                  if (owner &&
                      b['owner_signed'] == 1 &&
                      b['renter_signed'] == 1) ...[
                    if (b['pickup_available'] != true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Card(
                          color: warm,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Pickup inspection opens at ${when(b['start_at'])}. The booking will refresh automatically when it is time.',
                              style: const TextStyle(fontSize: 12, height: 1.6),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FilledButton(
                        onPressed: busy || b['pickup_available'] != true
                            ? null
                            : () => inspection('pickup'),
                        child: const Text('Record pickup inspection'),
                      ),
                    ),
                  ],
                ],
                if (['requested', 'approved'].contains(status) &&
                    DateTime.now().millisecondsSinceEpoch ~/ 1000 <
                        b['start_at'])
                  button('Cancel booking', () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Cancel this booking?'),
                        content: const Text(
                          'The reserved dates will become available again.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Keep booking'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Cancel booking'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) action('cancel');
                  }),
                if (status == 'active' && owner)
                  button(
                    'Record return inspection',
                    () => inspection('return'),
                  ),
                if (status == 'return_review' && owner) ...[
                  button(
                    'Complete return without a claim',
                    () => action('complete'),
                  ),
                  button('Report damage', () async {
                    final data = await editFields(context, 'Damage claim', {
                      'description': '',
                      'amount_in_rupees': '',
                    });
                    if (data == null || !mounted) return;
                    final amount = double.tryParse(data['amount_in_rupees']);
                    if (amount == null || !amount.isFinite) {
                      setState(() => error = 'Enter a valid claim amount.');
                      return;
                    }
                    await action('claim', {
                      'description': data['description'],
                      'claim_paise': (amount * 100).round(),
                    });
                  }),
                ],
                ...disputes.map(
                  (d) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Damage claim · ${d['status']}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${rupees(d['claim_paise'])} · ${d['description']}',
                          ),
                          if (d['response'] != null)
                            Text('Renter response: ${d['response']}'),
                          if (d['notes'] != null)
                            Text(
                              'Admin decision: ${d['notes']}\nSettlement ${rupees(d['settlement_paise'])}',
                            ),
                          if (!owner && d['status'] == 'open')
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () async {
                                      final data = await editFields(
                                        context,
                                        'Respond to claim',
                                        {'response': ''},
                                      );
                                      if (data == null || !mounted) return;
                                      setState(() => busy = true);
                                      try {
                                        await state.mutate(
                                          '/disputes/${d['id']}/response',
                                          data,
                                        );
                                        await load();
                                      } catch (e) {
                                        if (mounted) {
                                          setState(() => error = e.toString());
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() => busy = false);
                                        }
                                      }
                                    },
                              child: const Text('Send your response'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Inspection history',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                ...(b['inspections'] as List).map(
                  (inspection) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${inspection['kind']} · ${when(inspection['created_at'])}',
                          ),
                          Text(inspection['notes']),
                          ...((inspection['videos'] as List?) ?? []).map(
                            (video) => Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: EvidenceVideo(url: video),
                            ),
                          ),
                          ...(inspection['photos'] as List).map(
                            (photo) => Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Image.network(
                                state.api.mediaUrl(photo),
                                headers: {
                                  if (state.api.token != null)
                                    'Authorization':
                                        'Bearer ${state.api.token}',
                                },
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (_, error, stack) =>
                                    const Text('Evidence image unavailable'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ListingPhoto {
  final Uint8List bytes;
  String? url;
  _ListingPhoto(this.bytes);
}
