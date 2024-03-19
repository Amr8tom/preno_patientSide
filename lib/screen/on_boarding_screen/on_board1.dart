import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

class on_board1 extends StatelessWidget {
  const on_board1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // SizedBox(width: 60,),
        Container(
          child: Lottie.asset(
            'assets/json/onboardingBed.json',
            // Replace with the actual path to your Lottie JSON file
            // width: 300,
            // height: 300,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          "Consult only with a doctor\nyou trust",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 54, 186, 192)),
        ),
        // Spacer(),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 25),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         height: MediaQuery.of(context).size.height * 0.2,
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(12),
        //           gradient: LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: [
        //               Color.fromARGB(255, 247, 247, 247),
        //               const Color.fromARGB(255, 255, 255, 255),
        //             ],
        //           ),
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.all(25),
        //           child: Text(
        //             "Consult only with a doctor\nyou trust",
        //             style: GoogleFonts.inter(
        //                 fontSize: 18.sp,
        //                 fontWeight: FontWeight.bold,
        //                 color: const Color.fromARGB(255, 37, 37, 37)),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ]),
    );
    return Container(
      color: Colors.white,
      child: Column(children: [
        // SizedBox(width: 60,),

        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.8,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         alignment: Alignment.bottomCenter,
          //         image: AssetImage(
          //           "images/doctor2.png",
          //         ),
          //         filterQuality: FilterQuality.high)),
          child: Center(
            child: Lottie.asset(
              'lotties/Animation - 1707117224166.json',
              // Replace with the actual path to your Lottie JSON file
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 150,
        ),
        Text(
          "Consult only with a doctor\nyou trust",
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 37, 37, 37)),
        ),
        Spacer(),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 25),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         height: MediaQuery.of(context).size.height * 0.2,
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(12),
        //           gradient: LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: [
        //               Color.fromARGB(255, 247, 247, 247),
        //               const Color.fromARGB(255, 255, 255, 255),
        //             ],
        //           ),
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.all(25),
        //           child: Text(
        //             "Consult only with a doctor\nyou trust",
        //             style: GoogleFonts.inter(
        //                 fontSize: 18.sp,
        //                 fontWeight: FontWeight.bold,
        //                 color: const Color.fromARGB(255, 37, 37, 37)),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ]),
    );
  }
}
