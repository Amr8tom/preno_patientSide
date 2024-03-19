import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/appointment_booked_screen/appointment_booked_screen_controller.dart';
import 'package:patient_flutter/screen/dashboard_screen/dashboard_screen.dart';
import 'package:patient_flutter/utils/asset_res.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class AppointmentBookedScreen extends StatelessWidget {
  const AppointmentBookedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentBookedScreenController());
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        children: [
          Container(
            height: Get.height / 2.6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorRes.havelockBlue.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    S.current.appointmentBooked,
                    style: MyTextStyle.montserratBold(
                        size: 19, color: ColorRes.havelockBlue),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    AssetRes.icRoundVerifiedBig,
                    width: Get.width / 4,
                    height: Get.width / 4,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Text(
            S.current.appointmentID,
            style: MyTextStyle.montserratRegular(
              size: 17,
              color: ColorRes.havelockBlue,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '${controller.data?.appointmentNumber}'.toUpperCase(),
            style: MyTextStyle.montserratExtraBold(
              size: 19,
              color: ColorRes.havelockBlue,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Text(
            S.current.yourAppointmentHasEtc,
            textAlign: TextAlign.center,
            style: MyTextStyle.montserratBold(
              size: 20,
              color: ColorRes.davyGrey,
            ),
          ),
          const Spacer(),
          Text(
            S.current.checkAppointmentsEtc,
            textAlign: TextAlign.center,
            style: MyTextStyle.montserratRegular(
              color: ColorRes.battleshipGrey,
            ),
          ),
          const Spacer(
            flex: 5,
          ),
          InkWell(
            onTap: () {
              Get.offAll(() => const DashboardScreen());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              decoration:
                  const BoxDecoration(gradient: MyTextStyle.linearTopGradient),
              child: SafeArea(
                top: false,
                child: Text(
                  S.current.myAppointments,
                  style: MyTextStyle.montserratSemiBold(
                      size: 17, color: ColorRes.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
