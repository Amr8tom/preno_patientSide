import 'package:get/get.dart';
import 'package:patient_flutter/utils/color_res.dart';

class DashboardScreenController extends GetxController {
  int currentIndex = 0;
  final inactiveColor = ColorRes.grey;

  void onItemSelected(int value) {
    currentIndex = value;
    update();
  }
}
