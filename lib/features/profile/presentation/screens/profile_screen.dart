import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/core/models/models.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/custom_widgets.dart';
import 'package:aay_plus/features/auth/presentation/screens/kyc_verification_screen.dart';
import 'package:aay_plus/features/settlement/presentation/screens/cancellation_policy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final user = state.currentUser;
    final hosting = state.currentRole == UserRoleMode.owner;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Your account')),
      body: ResponsiveContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.amberLight,
                      child: Text(
                        user.name.substring(0, 1),
                        style: text.headlineMedium?.copyWith(
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(user.email, style: text.bodySmall),
                    const SizedBox(height: 16),
                    Chip(
                      avatar: Icon(
                        user.identityVerified
                            ? Icons.verified_outlined
                            : Icons.pending_outlined,
                        size: 18,
                      ),
                      label: Text(
                        user.identityVerified
                            ? 'Identity verified'
                            : 'Verification needed',
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${user.completedRentals}',
                              style: text.titleLarge,
                            ),
                            const Text('Rentals'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('${user.rating}', style: text.titleLarge),
                            const Text('Rating'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Manage your account',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('Identity & verification'),
                    subtitle: Text(
                      user.identityVerified
                          ? 'View your verification status'
                          : 'Complete your identity checks',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KycVerificationScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.policy_outlined),
                    title: const Text('Cancellation policy'),
                    subtitle: const Text('Understand refunds before booking'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CancellationPolicyScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryNavy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hosting
                        ? 'Find something for your next plan'
                        : 'Turn your things into possibilities',
                    style: text.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hosting
                        ? 'Explore rentals from people nearby.'
                        : 'List an item and manage your rentals in the host hub.',
                    style: text.bodySmall?.copyWith(
                      color: const Color(0xFFCBD5E1),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.amberLight,
                      foregroundColor: AppColors.primaryNavy,
                    ),
                    onPressed: () => state.toggleRole(),
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(
                      hosting ? 'Switch to renting' : 'Switch to hosting',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Demo account · Changes are kept for this session.',
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
