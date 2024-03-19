import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/custom/countries.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/screen/complete_registration_screen/complete_registration_screen.dart';
import 'package:patient_flutter/screen/dashboard_screen/dashboard_screen.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:patient_flutter/utils/asset_res.dart';
import 'package:patient_flutter/utils/update_res.dart';

import '../on_boarding_screen/on_boarding.dart';

class SplashScreenController extends GetxController {
  PrefService prefService = PrefService();
  RegistrationData? userData;
  Countries? country;
  bool isLoading = false;
  bool isLogin = false;

  void init() {
    prefData();
  }

  void prefData() async {
    await prefService.init();
    await countryData();
    isLogin = prefService.getBool(key: kLogin) ?? false;
    userData = prefService.getRegistrationData();
    PrefService.userId = userData?.id ?? -1;
    PrefService.identity = userData?.identity ?? '';

    update();
    navigateRoot();
  }

  Future<void> countryData() async {
    String response = await rootBundle.loadString(AssetRes.countryJson);
    country = Countries.fromJson(jsonDecode(response));
    String encode = jsonEncode(country?.toJson());
    prefService.saveString(key: kCountries, value: encode);
  }

  void navigateRoot() async {
    // isLoading = true;
    update();

    ApiService.instance.fetchGlobalSettings().then((value) {
      if (value.status == true) {
        dollar = value.data?.currency ?? '\$';
        if (PrefService.userId == -1) {
          // Get.off(() => const AuthScreen());
          Get.off(() => const on_boarding());
        } else {
          isLoading = false;
          ApiService.instance.fetchMyUserDetails().then((profile) {
            if (profile.status == true) {
              PrefService.userId = profile.data?.id ?? -1;
              PrefService.identity = profile.data?.identity ?? '';
              if (profile.data?.phoneNumber == null ||
                  profile.data!.phoneNumber!.isEmpty) {
                if (isLogin) {
                  Get.off(
                      () => const CompleteRegistrationScreen(screenType: 1));
                } else {
                  Get.off(
                      () => const CompleteRegistrationScreen(screenType: 0));
                }
              } else {
                Get.off(() => const DashboardScreen());
              }
            }
          });
        }
      } else {
        isLoading = false;
        CustomUi.snackBar(
            iconData: Icons.error, message: S.current.somethingWentWrong);
      }
    });
    update();
  }
}
