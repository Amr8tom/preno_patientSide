import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/top_bar_area.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/appointment_screen/appointment_screen_controller.dart';
import 'package:patient_flutter/screen/appointment_screen/widget/appointments.dart';
import 'package:patient_flutter/utils/color_res.dart';

class AppointmentsProfileScreen extends StatelessWidget {
  const AppointmentsProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentScreenController());
    controller.onInit();
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        children: [
          TopBarArea(title: S.current.appointments),
          Appointments(controller: controller),
          SizedBox(
            height: AppBar().preferredSize.height,
          )
        ],
      ),
    );
  }
}
