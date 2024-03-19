import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/complete_registration_screen/complete_registration_screen.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:patient_flutter/utils/update_res.dart';

class RegistrationScreenController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reTypePasswordController = TextEditingController();

  bool fullnameError = false;
  bool emailError = false;
  bool passwordError = false;
  bool reTypePasswordError = false;

  bool isPasswordVisible = false;
  bool isReTypePasswordVisible = false;

  String deviceToken = '';
  PrefService prefService = PrefService();

  @override
  void onInit() {
    initPrefService();
    FirebaseMessaging.instance.getToken().then((value) {
      deviceToken = value ?? '';
      log('📩  ${deviceToken.toString()}');
    });
    super.onInit();
  }

  void onRegisterClick() {
    fullnameError = false;
    emailError = false;
    passwordError = false;
    reTypePasswordError = false;
    if (fullNameController.text.trim().isEmpty) {
      fullnameError = true;
    }
    if (emailController.text.trim().isEmpty) {
      emailError = true;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError = true;
    }
    if (reTypePasswordController.text.trim().isEmpty) {
      reTypePasswordError = true;
    }
    update();
    if (fullnameError || emailError || passwordError || reTypePasswordError) {
      return;
    }
    log('message');
    if (!GetUtils.isEmail(emailController.text.trim())) {
      CustomUi.snackBar(
          iconData: Icons.email,
          positive: false,
          message: S.current.pleaseEnterValidEmail);
      return;
    }
    if (passwordController.text.trim() !=
        reTypePasswordController.text.trim()) {
      CustomUi.snackBar(
          iconData: Icons.password,
          positive: false,
          message: S.current.passwordDosentMatchEnterSamePassword);
      return;
    }
    CustomUi.loader();
    createUserWithEmailAndPassword();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (credential.user != null) {
        credential.user?.sendEmailVerification();
        registrationApi();
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'weak-password') {
        CustomUi.snackBar(
            iconData: Icons.error,
            message: S.current.thePasswordProvidedIsTooWeak,
            positive: false);
      } else if (e.code == 'email-already-in-use') {
        CustomUi.snackBar(
            iconData: Icons.error,
            message: S.current.theAccountAlreadyExistsForThatEmail,
            positive: false);
      }
    } catch (e) {
      Get.back();
    }
  }

  void registrationApi() {
    ApiService.instance
        .registration(
            passwordd: passwordController.text.trim(),
            identity: emailController.text.trim(),
            name: fullNameController.text.trim(),
            deviceToken: deviceToken,
            deviceType: Platform.isAndroid ? 1 : 2,
            loginType: 1)
        .then((value) async {
      if (value.status == true) {
        PrefService.userId = value.data?.id ?? -1;
        PrefService.identity = value.data?.identity ?? '';
        await prefService.saveString(
            key: kRegistrationUser, value: jsonEncode(value.data?.toJson()));
        Get.off(() => const CompleteRegistrationScreen(screenType: 0));
      } else {
        CustomUi.snackBar(
            iconData: Icons.app_registration,
            positive: false,
            message: value.message);
      }
    });
  }

  void initPrefService() async {
    await prefService.init();
  }

  void onChangePassword() {
    isPasswordVisible = !isPasswordVisible;
    print(isPasswordVisible);
    update();
  }

  void onChangedReTypePassword() {
    isReTypePasswordVisible = !isReTypePasswordVisible;

    update();
  }
}
