import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurahNameWidget extends StatelessWidget {
  const SurahNameWidget({
    super.key,
    required this.maxHieght,
    required this.surahName,
  });
  final double maxHieght;
  final String surahName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHieght,
      width: double.infinity,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/surah_header.png",
              color: Colors.black,
            ),
          ),
          Center(
            child: SizedBox(
              height: maxHieght - maxHieght / 2.5,
              child: FittedBox(
                child: Text(
                  surahName,
                  style: GoogleFonts.scheherazadeNew(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
