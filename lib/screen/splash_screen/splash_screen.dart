import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/splash_top_bar.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/splash_screen/splash_screen_controller.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashScreenController());
    controller.init();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SplashTopBar(),
          _bottomArea(controller),
        ],
      ),
    );
  }

  Widget _bottomArea(SplashScreenController controller) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              ConstRes.appName.toUpperCase(),
              style: MyTextStyle.montserratBlack(
                  color: ColorRes.charcoalGrey, size: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.current.findDoctorsBookAppointmentEtc,
              style: MyTextStyle.montserratLight(
                  color: ColorRes.charcoalGrey, size: 15),
            ),
            const Spacer(),
            GetBuilder(
                init: controller,
                builder: (context) {
                  return controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox();
                }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
