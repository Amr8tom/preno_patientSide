import 'package:get/get.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/model/home/home.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/screen/doctor_profile_screen/doctor_profile_screen.dart';
import 'package:patient_flutter/screen/specialists_detail_screen/specialists_detail_screen.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:patient_flutter/utils/extention.dart';
import 'package:patient_flutter/utils/update_res.dart';

class HomeScreenController extends GetxController {
  PrefService prefService = PrefService();
  bool isLoading = false;
  List<Categories>? categories = [];
  List<AppointmentData>? appointments = [];
  RegistrationData? userData;

  @override
  void onInit() {
    prefData();
    fetchHomePageDataApiCall();
    super.onInit();
  }

  void prefData() async {
    await prefService.init();
    userData = prefService.getRegistrationData();
    update();
  }

  void fetchHomePageDataApiCall() async {
    isLoading = true;
    ApiService.instance
        .fetchHomePageData(date: DateTime.now().formatDateTime(yyyyMMDd))
        .then((value) {
      appointments = value.appointments;
      categories = value.categories;
      isLoading = false;
      update();
    });
  }

  onSpecialistsDetailScreenNavigate(Categories? categories) {
    Get.to(() => const SpecialistsDetailScreen(), arguments: categories);
  }

  onDoctorCardTap(Doctor? d) {
    Get.to(() => const DoctorProfileScreen(), arguments: d);
  }
}
