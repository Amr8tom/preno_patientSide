import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/splash_top_bar.dart';
import 'package:patient_flutter/common/text_button_custom.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/login_screen/login_screen_controller.dart';
import 'package:patient_flutter/screen/registration_screen/registration_screen.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginScreenController();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SplashTopBar(),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder(
                    init: controller,
                    builder: (controller) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            TextWithTextField(
                                title: S.of(context).email,
                                controller: controller.emailController,
                                keyboardType: TextInputType.emailAddress),
                            TextWithTextField(
                                title: S.of(context).password,
                                controller: controller.passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                onChangedPasswordVisibility:
                                    controller.onChangePassword,
                                isSuffixVisible: true,
                                obSecure: controller.isPasswordVisible,
                                passwordVisible: controller.isPasswordVisible),
                            TextButtonCustom(
                              onPressed: controller.onLoginClick,
                              title: S.of(context).login,
                              titleColor: ColorRes.darkSkyBlue,
                              backgroundColor:
                                  ColorRes.darkSkyBlue.withOpacity(0.2),
                              bottomSafeArea: false,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: controller.onForgotPasswordClick,
                                child: Text(
                                  S.of(context).forgetPassword,
                                  style: MyTextStyle.montserratBold(
                                      size: 16, color: ColorRes.charcoalGrey),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                const PolicyText(),
                SizedBox(
                  height: AppBar().preferredSize.height / 3,
                )
              ],
            ),
          ),
          SafeArea(
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.arrow_back,
                  color: ColorRes.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
