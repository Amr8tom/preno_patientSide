import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

class on_board3 extends StatelessWidget {
  const on_board3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        // SizedBox(width: 60,),
        Container(
          child: Lottie.asset(
            'assets/json/an3.json',
            // Replace with the actual path to your Lottie JSON file
            // width: 300,
            // height: 300,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          " Exceptional Care ",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 54, 186, 192)),
        ),

      ]),
    );
  }
}
