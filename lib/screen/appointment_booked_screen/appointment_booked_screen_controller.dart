import 'package:get/get.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/services/api_service.dart';

class AppointmentBookedScreenController extends GetxController {
  AppointmentData? data;

  @override
  void onInit() {
    data = Get.arguments;
    fetchDoctorApiCall();
    super.onInit();
  }

  void fetchDoctorApiCall() {
    ApiService.instance.fetchMyUserDetails();
  }
}
