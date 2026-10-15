import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isAmber;
  final bool isOutlined;
  final bool isDanger;
  final IconData? icon;
  final double? width;
  final double height;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isAmber = false,
    this.isOutlined = false,
    this.isDanger = false,
    this.icon,
    this.width,
    this.height = 52,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? border;
    List<BoxShadow> shadows = [];

    if (isDanger) {
      bg = AppColors.danger;
      fg = AppColors.white;
      shadows = [
        BoxShadow(
          color: AppColors.danger.withValues(alpha: 0.25),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];
    } else if (isOutlined) {
      bg = AppColors.white;
      fg = AppColors.primaryNavy;
      border = const BorderSide(color: AppColors.borderMedium, width: 1.5);
    } else if (isAmber) {
      bg = AppColors.amberAccent;
      fg = AppColors.primaryNavy;
      border = const BorderSide(color: AppColors.amberDark, width: 1);
      shadows = [
        BoxShadow(
          color: AppColors.amberDark.withValues(alpha: 0.28),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];
    } else if (isPrimary) {
      bg = AppColors.primaryNavy;
      fg = AppColors.white;
      shadows = [
        BoxShadow(
          color: AppColors.primaryNavy.withValues(alpha: 0.22),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    } else {
      bg = AppColors.elevatedNavy;
      fg = AppColors.primaryNavy;
      border = const BorderSide(color: AppColors.borderNavy, width: 1);
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: onPressed == null ? [] : shadows,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          side: border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: fg),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      text,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final int maxLines;
  final void Function(String)? onChanged;
  final String? helperText;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          onChanged: onChanged,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary, size: 20)
                : null,
            suffixIcon: suffix,
            helperText: helperText,
            helperStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // If it's amber, use the dedicated high-contrast amber tone
    final isAmberColor =
        color == AppColors.amberAccent || color == AppColors.warning;
    final badgeBg = isAmberColor
        ? AppColors.amberLight
        : color.withValues(alpha: 0.1);
    final badgeBorder = isAmberColor
        ? AppColors.amberBorder
        : color.withValues(alpha: 0.28);
    final badgeFg = isAmberColor ? AppColors.amberDeep : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: badgeFg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: badgeFg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationBadge extends StatelessWidget {
  final String label;
  final bool verified;

  const VerificationBadge({
    super.key,
    required this.label,
    this.verified = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = verified ? AppColors.success : AppColors.textMuted;
    final bg = verified ? AppColors.successLight : AppColors.elevatedNavy;
    final border = verified ? AppColors.successBorder : AppColors.borderMedium;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.check_circle_rounded : Icons.pending_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  // Keep long forms readable on tablets and desktop.
  final double maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 720,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
