import 'package:flutter/material.dart';
import 'package:patient_flutter/common/dashboard_top_bar_title.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/appointment_screen/appointment_screen_controller.dart';
import 'package:patient_flutter/screen/appointment_screen/widget/appointments.dart';
import 'package:patient_flutter/utils/color_res.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AppointmentScreenController();
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        children: [
          DashboardTopBarTitle(title: S.current.appointments),
          Appointments(controller: controller)
        ],
      ),
    );
  }
}
