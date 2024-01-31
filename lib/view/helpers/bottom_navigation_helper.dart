import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

navbarItems(icon, title, active) {
  return Column(
    children: [
      Icon(
        icon,
        color: active == '1' ? mainColor : blackColor.withOpacity(0.5),
      ),
      const SizedBox(height: 2),
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: active == '1' ? mainColor : blackColor.withOpacity(0.4),
        ),
      ),
    ],
  );
}
