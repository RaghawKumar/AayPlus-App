import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';

class AccountSection extends StatelessWidget {
  final AppStateProvider state;
  final bool busy;
  final VoidCallback onEdit, onSignOut;

  const AccountSection({
    super.key,
    required this.state,
    required this.busy,
    required this.onEdit,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final user = state.currentUser;
    final theme = Theme.of(context).textTheme;
    final name = user.name.trim().isEmpty ? 'AayPlus member' : user.name.trim();
    final initials = name
        .split(RegExp(r'\s+'))
        .take(2)
        .map((part) => part.characters.first)
        .join()
        .toUpperCase();
    final status = state.user?['kyc_status'] ?? 'unverified';
    final verified = status == 'verified';
    final rejected = status == 'rejected';
    final statusColor = verified
        ? AppColors.success
        : rejected
        ? AppColors.danger
        : AppColors.amberDeep;
    final statusLabel = verified
        ? 'Verified member'
        : rejected
        ? 'Review required'
        : 'Not yet verified';
    final ongoing = state.bookingRows
        .where(
          (row) => [
            'requested',
            'approved',
            'active',
            'return_review',
            'disputed',
          ].contains(row['status']),
        )
        .length;
    final activeListings = state.ownListingRows
        .where((row) => row['active'] == true)
        .length;

    return RefreshIndicator(
      onRefresh: state.refresh,
      child: ListView(
        key: const PageStorageKey('account'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .14),
                        ),
                      ),
                      child: Text(
                        initials,
                        style: theme.headlineSmall?.copyWith(
                          color: AppColors.amberGlow,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR AAYPLUS',
                            style: theme.labelSmall?.copyWith(
                              color: const Color(0xFFBDCBDD),
                              letterSpacing: 1.6,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            name,
                            style: theme.headlineSmall?.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ProfileBadge(
                      icon: verified
                          ? Icons.verified_rounded
                          : Icons.person_outline_rounded,
                      label: statusLabel,
                    ),
                    if (state.user?['role'] == 'admin')
                      const _ProfileBadge(
                        icon: Icons.admin_panel_settings_outlined,
                        label: 'Administrator',
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Your details, your rentals, your community.',
                  style: theme.bodySmall?.copyWith(
                    color: const Color(0xFFBDCBDD),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ProfileSurface(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActivityNumber(value: ongoing, label: 'Ongoing'),
                _ActivityNumber(
                  value: user.completedRentals,
                  label: 'Completed',
                ),
                _ActivityNumber(value: activeListings, label: 'Live listings'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Text('Personal details', style: theme.titleMedium),
              ),
              TextButton.icon(
                onPressed: busy ? null : onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit profile'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ProfileSurface(
            child: Column(
              children: [
                _ContactDetail(
                  icon: Icons.person_outline_rounded,
                  label: 'Full name',
                  value: name,
                ),
                const Divider(height: 28),
                _ContactDetail(
                  icon: Icons.phone_outlined,
                  label: 'Mobile number',
                  value: user.phone,
                ),
                const Divider(height: 28),
                _ContactDetail(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email address',
                  value: user.email.trim().isEmpty
                      ? 'Add an email address'
                      : user.email,
                  muted: user.email.trim().isEmpty,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Identity verification', style: theme.titleMedium),
          const SizedBox(height: 12),
          _ProfileSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        verified
                            ? Icons.verified_user_outlined
                            : Icons.fact_check_outlined,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            verified
                                ? 'You’re ready to rent and host'
                                : rejected
                                ? 'Your account needs another review'
                                : 'One step closer to your first rental',
                            style: theme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            verified
                                ? 'Your account has been approved by an administrator.'
                                : rejected
                                ? 'Your account was not approved. An administrator will need to review it again before you can rent or host.'
                                : 'An administrator needs to review your account before you can rent or host.',
                            style: theme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.labelMedium?.copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Account records', style: theme.titleMedium),
          const SizedBox(height: 12),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              key: const PageStorageKey('account-records'),
              shape: const Border(),
              collapsedShape: const Border(),
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              leading: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.textSecondary,
              ),
              title: Text('Rental accounting', style: theme.titleSmall),
              subtitle: Text(
                '${state.ledgerRows.length} ${state.ledgerRows.length == 1 ? 'entry' : 'entries'}',
                style: theme.bodySmall,
              ),
              children: [
                Text(
                  'These entries show amounts due. Payments and refunds have not been processed through AayPlus.',
                  style: theme.bodySmall,
                ),
                if (state.ledgerRows.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No account entries yet.',
                        style: theme.bodyMedium,
                      ),
                    ),
                  ),
                ...state.ledgerRows.map((row) {
                  final label = switch (row['kind']) {
                    'rental_due' => 'Rental amount due',
                    'damage_due' => 'Damage amount due',
                    'deposit_release_due' => 'Deposit release due',
                    _ => row['kind'].toString().replaceAll('_', ' '),
                  };
                  return Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: theme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(
                            locale: 'en_IN',
                            symbol: '₹',
                            decimalDigits: 2,
                          ).format((row['amount_paise'] as num) / 100),
                          style: theme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Booking ${row['booking_id']}',
                          style: theme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: busy ? null : onSignOut,
            icon: const Icon(Icons.logout_rounded, size: 19),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.dangerBorder),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSurface extends StatelessWidget {
  final Widget child;
  const _ProfileSurface({required this.child});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(20), child: child),
  );
}

class _ProfileBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ProfileBadge({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white.withValues(alpha: .12)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.amberGlow),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

class _ActivityNumber extends StatelessWidget {
  final int value;
  final String label;
  const _ActivityNumber({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text('$value', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

class _ContactDetail extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool muted;
  const _ContactDetail({
    required this.icon,
    required this.label,
    required this.value,
    this.muted = false,
  });
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.textMuted),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 5),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: muted ? FontWeight.w400 : FontWeight.w500,
                color: muted ? AppColors.textMuted : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
