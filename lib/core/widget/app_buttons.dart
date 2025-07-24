import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'svg_icon.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double? height;
  final VoidCallback? onPressed;
  final bool filled;
  final bool disabled;
  final Color? bg;
  final Color? textColor;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.filled = true,
    this.disabled = false,
    this.isLoading = false,
    this.bg,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: filled ? Color(0xFF8F07E7) : Colors.white,
          foregroundColor: filled ? Colors.white : Color(0xFF8F07E7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child:
            isLoading
                ? CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                )
                : Text(
                  text,
                  style: GoogleFonts.figtree(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final String text;
  final double? height;
  final VoidCallback? onPressed;
  final bool filled;
  final bool disabled;
  final Color? textColor;
  final bool isLoading;
  final String? iconPath;

  const AppOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.filled = false, // Outline button will not be filled by default
    this.disabled = false,
    this.isLoading = false,
    this.textColor,
    this.iconPath,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: OutlinedButton(
        onPressed: disabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Color(0xFF8F07E7), // Primary color border
            width: 1.5, // Border width
          ),
          backgroundColor:
              Colors.transparent, // No background color for outline button
          foregroundColor:
              textColor ?? Color(0xFF8F07E7), // Primary color for text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Rounded corners
          ),
        ),
        child:
            isLoading
                ? CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.figtree(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (iconPath != null) ...[
                      SizedBox(width: 10),
                      //   SvgIcon(path: iconPath!),
                    ],
                  ],
                ),
      ),
    );
  }
}
