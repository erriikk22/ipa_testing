import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmileMarketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smile Market',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Aquí va el mercado de Smile Market.',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
