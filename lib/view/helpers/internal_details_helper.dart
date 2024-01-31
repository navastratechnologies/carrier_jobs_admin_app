import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

internalDetailsMethod(icon, heading, detail) {
  return Row(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: mainColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(
              heading,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: blackColor.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(width: 20),
      Text(
        ': ',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: blackColor.withOpacity(0.6),
        ),
      ),
      Text(
        detail,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: blackColor.withOpacity(0.6),
        ),
      ),
    ],
  );
}
