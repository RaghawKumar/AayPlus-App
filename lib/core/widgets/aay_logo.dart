import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AayLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool compact;

  const AayLogo({
    super.key,
    this.size = 40,
    this.showText = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Brand Mark
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primaryNavy,
            borderRadius: BorderRadius.circular(size * 0.28),
            border: Border.all(color: AppColors.borderNavy, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'A+',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.amberAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: size * 0.45,
                  ),
                ),
              );
            },
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.25),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Aay',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: compact ? size * 0.55 : size * 0.65,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Plus',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.amberDark,
                    fontSize: compact ? size * 0.55 : size * 0.65,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
