import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/text_button_custom.dart';
import 'package:patient_flutter/common/top_bar_area.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/registration_screen/registration_screen_controller.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RegistrationScreenController();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBarArea(title: S.of(context).registration),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: GetBuilder(
                    init: controller,
                    builder: (controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            S
                                .of(context)
                                .pleaseFillYourDetailsAndCompleteRegistrationToStartFind,
                            style: MyTextStyle.montserratRegular(
                                color: ColorRes.battleshipGrey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextWithTextField(
                            title: S.of(context).fullname,
                            controller: controller.fullNameController,
                            isError: controller.fullnameError,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          TextWithTextField(
                            title: S.of(context).email,
                            controller: controller.emailController,
                            isError: controller.emailError,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextWithTextField(
                              title: S.of(context).password,
                              controller: controller.passwordController,
                              isError: controller.passwordError,
                              keyboardType: TextInputType.visiblePassword,
                              onChangedPasswordVisibility:
                                  controller.onChangePassword,
                              isSuffixVisible: true,
                              obSecure: controller.isPasswordVisible,
                              passwordVisible: controller.isPasswordVisible),
                          TextWithTextField(
                            title: S.of(context).retypePassword,
                            controller: controller.reTypePasswordController,
                            isError: controller.reTypePasswordError,
                            keyboardType: TextInputType.visiblePassword,
                            onChangedPasswordVisibility:
                                controller.onChangedReTypePassword,
                            isSuffixVisible: true,
                            obSecure: controller.isReTypePasswordVisible,
                            passwordVisible: controller.isReTypePasswordVisible,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextButtonCustom(
                              onPressed: controller.onRegisterClick,
                              title: S.of(context).register,
                              titleColor: ColorRes.darkSkyBlue,
                              backgroundColor:
                                  ColorRes.darkSkyBlue.withOpacity(0.2)),
                          const SizedBox(
                            height: 20,
                          ),
                          const PolicyText(),
                          SizedBox(
                            height: AppBar().preferredSize.height / 3,
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextWithTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isError;
  final bool obSecure;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final bool isSuffixVisible;
  final bool passwordVisible;
  final VoidCallback? onChangedPasswordVisibility;

  const TextWithTextField(
      {super.key,
      required this.title,
      required this.controller,
      this.isError = false,
      this.obSecure = false,
      this.textCapitalization = TextCapitalization.none,
      this.keyboardType,
      this.isSuffixVisible = false,
      this.passwordVisible = false,
      this.onChangedPasswordVisibility});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: Text(
            title,
            style: MyTextStyle.montserratRegular(
                color: ColorRes.battleshipGrey, size: 16),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isError ? ColorRes.ferrariRed : ColorRes.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: ColorRes.aquaHaze,
                filled: true,
                suffixIconConstraints: const BoxConstraints(minWidth: 10),
                suffixIconColor: ColorRes.tuftsBlue,
                suffixIcon: !isSuffixVisible
                    ? const SizedBox()
                    : IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: onChangedPasswordVisibility,
                      ),
              ),
              obscureText: obSecure,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              cursorColor: ColorRes.darkJungleGreen,
            ),
          ),
        )
      ],
    );
  }
}

class PolicyText extends StatelessWidget {
  const PolicyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: S.of(context).byProceedingForwardYouAgreeToThen,
          style: MyTextStyle.montserratRegular(
              size: 12, color: ColorRes.battleshipGrey),
          children: [
            TextSpan(
                text: S.of(context).privacyPolicy,
                style: MyTextStyle.montserratBold(
                    size: 12, color: ColorRes.charcoalGrey),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrl(Uri.parse(ConstRes.privacyPolicy))) {
                      throw Exception('Could not launch');
                    }
                  }),
            TextSpan(
              text: ' ${S.of(context).and} ',
              style: MyTextStyle.montserratRegular(
                  size: 12, color: ColorRes.battleshipGrey),
            ),
            TextSpan(
                text: S.of(context).termsConditions,
                style: MyTextStyle.montserratBold(
                    size: 12, color: ColorRes.charcoalGrey),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrl(Uri.parse(ConstRes.termsOfUse))) {
                      throw Exception('Could not launch');
                    }
                  }),
          ],
        ),
      ),
    );
  }
}
