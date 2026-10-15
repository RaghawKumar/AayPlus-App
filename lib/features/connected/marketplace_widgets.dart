import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aay_plus/core/constants/app_colors.dart';

const ink = Color(0xFF12243A);
const warm = Color(0xFFFFF4DD);

class Reveal extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const Reveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(
      begin: MediaQuery.disableAnimationsOf(context) ? 1 : 0,
      end: 1,
    ),
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration,
    curve: Curves.easeOutCubic,
    child: child,
    builder: (_, value, child) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 18 * (1 - value)),
        child: child,
      ),
    ),
  );
}

class FeatureBanner extends StatelessWidget {
  final String eyebrow, title, subtitle;
  final IconData icon;
  final Widget? action;
  const FeatureBanner({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.icon = Icons.explore_outlined,
    this.action,
  });
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: ink,
      borderRadius: BorderRadius.circular(26),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -30,
          top: -40,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: .07),
                width: 26,
              ),
            ),
          ),
        ),
        Positioned(
          right: 14,
          bottom: -18,
          child: Icon(
            icon,
            size: 110,
            color: Colors.white.withValues(alpha: .05),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFFFCC76),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.8,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFC2CFDE),
                  fontSize: 13,
                  height: 1.7,
                ),
              ),
              if (action != null) ...[const SizedBox(height: 18), action!],
            ],
          ),
        ),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String title, subtitle;
  const SectionTitle(this.title, this.subtitle, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}

IconData categoryIcon(String category) => switch (category) {
  'Bikes' => Icons.two_wheeler_rounded,
  'Cameras' => Icons.camera_alt_outlined,
  'Electronics' => Icons.devices_rounded,
  'Parking' => Icons.local_parking_rounded,
  _ => Icons.grid_view_rounded,
};

class ListingTile extends StatelessWidget {
  final Map<String, dynamic> row;
  final String Function(String) mediaUrl;
  final VoidCallback onTap;
  const ListingTile({
    super.key,
    required this.row,
    required this.mediaUrl,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final photos = row['photos'] as List;
    final price = NumberFormat('#,##0.##');
    final category = row['category'] as String;
    Widget fallback() => Container(
      color: warm,
      child: Center(
        child: Icon(
          categoryIcon(category),
          size: 64,
          color: const Color(0xFFB58B48),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.borderNavy),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.65,
                    child: photos.isEmpty
                        ? fallback()
                        : Image.network(
                            mediaUrl(photos.first),
                            fit: BoxFit.cover,
                            frameBuilder: (_, image, frame, sync) => sync
                                ? image
                                : AnimatedOpacity(
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(milliseconds: 300),
                                    child: image,
                                  ),
                            errorBuilder: (_, error, stack) => fallback(),
                          ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(categoryIcon(category), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (photos.isNotEmpty)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: ink.withValues(alpha: .8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${photos.length} ${photos.length == 1 ? 'photo' : 'photos'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            row['location'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      row['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.4,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      row['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        height: 1.6,
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
                                      text:
                                          '₹${price.format(row['hourly_paise'] / 100)}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: ink,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' / hour',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${price.format(row['daily_paise'] / 100)} per day',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: ink,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Refundable deposit ₹${price.format(row['deposit_paise'] / 100)}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
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

class RentalProgress extends StatelessWidget {
  final String status;
  const RentalProgress({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    final stage = switch (status) {
      'requested' => 0,
      'approved' => 1,
      'active' => 2,
      'return_review' || 'disputed' => 3,
      'completed' => 4,
      _ => -1,
    };
    final labels = ['Requested', 'Terms', 'Pickup', 'Return', 'Complete'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderNavy),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stage < 0
                ? 'Booking ${status.replaceAll('_', ' ')}'
                : 'Your rental journey',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(
              5,
              (i) => Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: i == 0
                                ? Colors.transparent
                                : i <= stage
                                ? ink
                                : AppColors.borderNavy,
                          ),
                        ),
                        AnimatedContainer(
                          duration: MediaQuery.disableAnimationsOf(context)
                              ? Duration.zero
                              : const Duration(milliseconds: 350),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: i <= stage ? ink : AppColors.elevatedNavy,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: i < stage
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 13,
                                  )
                                : Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: i <= stage
                                          ? Colors.white
                                          : AppColors.textMuted,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: i == 4
                                ? Colors.transparent
                                : i < stage
                                ? ink
                                : AppColors.borderNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: i == stage
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: i <= stage ? ink : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (status == 'disputed')
            const Padding(
              padding: EdgeInsets.only(top: 14),
              child: Text(
                'A damage claim is awaiting administrator review.',
                style: TextStyle(fontSize: 11, color: AppColors.amberDeep),
              ),
            ),
        ],
      ),
    );
  }
}

class RentalFlowScreen extends StatelessWidget {
  const RentalFlowScreen({super.key});
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('How AayPlus works'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Rent'),
            Tab(text: 'Host'),
            Tab(text: 'Review'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          _steps('A little planning. A lot of possibility.', const [
            (
              '01',
              'Sign in & verify',
              'Sign in with your mobile number. An administrator verifies the account before renting or hosting. Development verification is a test approval.',
            ),
            (
              '02',
              'Discover & compare',
              'Browse categories, view every photo, read the description and compare hourly, daily and weekly rates.',
            ),
            (
              '03',
              'Choose your dates',
              'Set pickup and return times. The server checks availability and calculates the best package, platform fee and deposit.',
            ),
            (
              '04',
              'Send a request',
              'Your host reviews the request. Follow its status in Rentals. Sending a request does not collect a payment.',
            ),
            (
              '05',
              'Agree & collect',
              'Both parties acknowledge rental terms. The host records pickup condition with inspection evidence once pickup time arrives.',
            ),
            (
              '06',
              'Return & close',
              'The host records a return inspection. A clean return completes the booking; you can respond to a damage claim before admin review.',
            ),
          ]),
          _steps('Give your things a second purpose.', const [
            (
              '01',
              'Verify your account',
              'Your account must be verified before you upload photos or publish a listing. View your status in Account.',
            ),
            (
              '02',
              'Create your listing',
              'Choose a category, title, description, pickup area, hourly/daily/weekly rates and refundable deposit. Add up to 12 photos from your library or camera.',
            ),
            (
              '03',
              'Review requests',
              'Open Rentals → Hosting. Approve or decline requests made by other accounts. Switching modes keeps your own identity.',
            ),
            (
              '04',
              'Prepare the handover',
              'Acknowledge the rental terms. Once both parties agree and pickup time arrives, record pickup evidence and notes.',
            ),
            (
              '05',
              'Inspect the return',
              'Record return condition. Complete without a claim or describe damage and an amount within the deposit.',
            ),
            (
              '06',
              'Follow the outcome',
              'Read the renter response and administrator decision. Archive or reactivate your inventory whenever needed.',
            ),
          ]),
          _steps('Keep every decision connected.', const [
            (
              '01',
              'Review members',
              'Administrators sign in through the separate web panel and review verification status.',
            ),
            (
              '02',
              'Manage the marketplace',
              'Shared listings, bookings, signatures and inspection evidence appear in the admin panel.',
            ),
            (
              '03',
              'Resolve a claim',
              'Review the host claim, renter response and evidence. Record a settlement from zero up to the claim amount with decision notes.',
            ),
            (
              '04',
              'Track the ledger',
              'Both parties see the updated booking and accounting intentions. Real payment collection and refunds are not configured.',
            ),
          ]),
        ],
      ),
    ),
  );
  Widget _steps(String title, List<(String, String, String)> steps) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      FeatureBanner(
        eyebrow: 'Your guide',
        title: title,
        subtitle: 'Know what happens next, at every step.',
        icon: Icons.route_outlined,
      ),
      const SizedBox(height: 24),
      ...steps.map(
        (step) => Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: warm,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  step.$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.amberDeep,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.$2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      step.$3,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.7,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class BookingSummaryCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool hosting;
  final VoidCallback onTap;
  const BookingSummaryCard({
    super.key,
    required this.booking,
    required this.hosting,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final status = booking['status'] as String;
    final date = DateFormat('d MMM, h:mm a');
    String time(String field) =>
        date.format(DateTime.fromMillisecondsSinceEpoch(booking[field] * 1000));
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: warm,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        categoryIcon(booking['listing']['category']),
                        color: ink,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: status == 'completed'
                              ? AppColors.successLight
                              : AppColors.elevatedNavy,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.replaceAll('_', ' '),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  booking['listing']['title'],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${hosting ? 'Rented by' : 'Hosted by'} ${hosting ? booking['renter_name'] : booking['owner_name']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const Divider(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PICKUP',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            time('start_at'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RETURN',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            time('end_at'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Follow your rental',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_outward, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
