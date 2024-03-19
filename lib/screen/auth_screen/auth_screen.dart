import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/splash_top_bar.dart';
import 'package:patient_flutter/common/text_button_custom.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/login_screen/login_screen.dart';
import 'package:patient_flutter/screen/registration_screen/registration_screen.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SplashTopBar(),
          const Spacer(),
          Text(
            S
                .of(context)
                .appointmentOnlineDiagnosticBookingManagementMultivendorApp,
            style: MyTextStyle.montserratBold(
                color: ColorRes.charcoalGrey, size: 16),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Text(
            S.current.findDoctorsBookAppointmentEtc,
            style: const TextStyle(color: ColorRes.charcoalGrey),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          TextButtonCustom(
            onPressed: () {
              Get.to(() => const RegistrationScreen());
            },
            title: S.of(context).register,
            titleColor: ColorRes.darkSkyBlue,
            backgroundColor: ColorRes.darkSkyBlue.withOpacity(0.20),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              text: S.of(context).alreadyHaveAnAccount,
              style: MyTextStyle.montserratLight(
                color: ColorRes.charcoalGrey,
              ),
              children: [
                TextSpan(
                    text: S.of(context).logIn,
                    style: MyTextStyle.montserratSemiBold(
                      color: ColorRes.charcoalGrey,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(() => const LoginScreen());
                      }),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
