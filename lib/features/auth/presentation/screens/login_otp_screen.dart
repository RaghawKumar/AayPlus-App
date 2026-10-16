import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aay_plus/core/constants/app_colors.dart';
import 'package:aay_plus/features/connected/marketplace_widgets.dart';
import 'package:aay_plus/core/logging/dev_log.dart';
import 'package:provider/provider.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/widgets/aay_logo.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});
  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final phone = TextEditingController(),
      code = TextEditingController(),
      name = TextEditingController();
  bool sent = false, busy = false;
  String? error, developmentCode;
  String get normalizedPhone => '+91${phone.text.trim()}';
  @override
  void initState() {
    super.initState();
    DevLog.screen('Sign in');
  }

  Future<void> submit({bool resend = false}) async {
    DevLog.action(!sent || resend ? 'Request verification code' : 'Sign in');
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final state = context.read<AppStateProvider>();
      if (!sent || resend) {
        final result = await state.requestOtp(normalizedPhone);
        if (mounted)
          setState(() {
            sent = true;
            developmentCode = result['developmentCode'];
          });
      } else {
        await state.signIn(normalizedPhone, code.text.trim(), name.text.trim());
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    phone.dispose();
    code.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AayLogo(size: 42),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  child: Reveal(
                    key: ValueKey(sent),
                    child: FeatureBanner(
                      eyebrow: sent
                          ? 'One more step'
                          : 'Welcome to your community',
                      title: sent ? 'Check your code' : 'Make room for more.',
                      subtitle: sent
                          ? 'Enter the verification code for $normalizedPhone.'
                          : 'Rent something extraordinary. Share something useful. Start with your mobile number.',
                      icon: sent
                          ? Icons.mark_chat_read_outlined
                          : Icons.handshake_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderNavy),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sent ? 'Verify your number' : 'Sign in to AayPlus',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        sent
                            ? 'Enter your code to continue.'
                            : 'A little less ownership. A lot more possibility.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: phone,
                        enabled: !sent && !busy,
                        keyboardType: TextInputType.phone,
                        autofillHints: const [
                          AutofillHints.telephoneNumberNational,
                        ],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: 'Mobile number',
                          prefixText: '+91 ',
                        ),
                      ),
                      if (sent) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: code,
                          keyboardType: TextInputType.number,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(letterSpacing: 5),
                          maxLength: 6,
                          decoration: const InputDecoration(
                            labelText: 'Six-digit code',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: name,
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                            helperText: 'Required when creating an account',
                          ),
                        ),
                        if (developmentCode != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Development server · Code: $developmentCode\nSMS delivery is not configured.',
                            ),
                          ),
                      ],
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            error!,
                            style: const TextStyle(
                              color: AppColors.danger,
                              height: 1.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: busy ? null : submit,
                          child: Text(
                            busy
                                ? 'Please wait…'
                                : sent
                                ? 'Sign in'
                                : 'Send code',
                          ),
                        ),
                      ),
                      if (sent)
                        Wrap(
                          spacing: 4,
                          children: [
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () => setState(() {
                                      sent = false;
                                      code.clear();
                                      developmentCode = null;
                                    }),
                              child: const Text('Change number'),
                            ),
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () => submit(resend: true),
                              child: const Text('Resend code'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Made for sharing. Built around you.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
