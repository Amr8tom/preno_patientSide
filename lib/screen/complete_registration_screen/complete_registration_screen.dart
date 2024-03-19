import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:patient_flutter/common/drop_down_menu.dart';
import 'package:patient_flutter/common/text_button_custom.dart';
import 'package:patient_flutter/common/top_bar_area.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/complete_registration_screen/complete_registration_screen_controller.dart';
import 'package:patient_flutter/utils/asset_res.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';
import 'package:patient_flutter/utils/update_res.dart';

class CompleteRegistrationScreen extends StatelessWidget {
  final int screenType;

  const CompleteRegistrationScreen({Key? key, required this.screenType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(CompleteRegistrationScreenController(screenType));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBarArea(title: S.current.completeRegistration),
          CenterArea(controller: controller),
          SafeArea(
            top: false,
            child: TextButtonCustom(
                onPressed: controller.onSubmitBtnClick,
                title: S.current.submit,
                titleColor: ColorRes.white,
                backgroundColor: ColorRes.darkSkyBlue),
          ),
          SizedBox(
            height: AppBar().preferredSize.height,
          )
        ],
      ),
    );
  }
}

class CenterArea extends StatelessWidget {
  final CompleteRegistrationScreenController controller;

  const CenterArea({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                S.of(context).mobileNumber,
                style: MyTextStyle.montserratRegular(
                    size: 15, color: ColorRes.battleshipGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorRes.silverChalice.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: Get.width / 4,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: ColorRes.charcoalGrey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        controller.phoneNumber = number;
                      },
                      countrySelectorScrollControlled: true,
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        leadingPadding: 7,
                        trailingSpace: true,
                        showFlags: true,
                        useEmoji: true,
                      ),
                      selectorTextStyle: MyTextStyle.montserratSemiBold(
                              color: ColorRes.white, size: 18)
                          .copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                      textStyle: MyTextStyle.montserratBold(
                        color: ColorRes.charcoalGrey,
                      ),
                      cursorColor: ColorRes.battleshipGrey,
                      keyboardAction: TextInputAction.done,
                      initialValue: PhoneNumber(isoCode: "IN"),
                      formatInput: true,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: false),
                      inputDecoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.only(left: 5),
                        hintText: S.current.enterMobileNumber,
                        hintStyle: MyTextStyle.montserratMedium(
                            color: ColorRes.battleshipGrey.withOpacity(0.5),
                            size: 14),
                        isCollapsed: false,
                        counterText: "",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                S.current.selectCountry,
                style: MyTextStyle.montserratRegular(
                    size: 15, color: ColorRes.battleshipGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              GetBuilder(
                init: controller,
                builder: (context) {
                  return InkWell(
                    onTap: controller.countryBottomSheet,
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: ColorRes.whiteSmoke,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            controller.countryName,
                            style: MyTextStyle.montserratBold(
                                size: 15, color: ColorRes.charcoalGrey),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: ColorRes.charcoalGrey,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                S.current.selectGender,
                style: MyTextStyle.montserratRegular(
                    size: 15, color: ColorRes.battleshipGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              GetBuilder(
                init: controller,
                builder: (controller) => DropDownMenu(
                    items: controller.genders,
                    initialValue: controller.selectGender,
                    onChange: controller.onGenderChange),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                S.current.dateOfBirth,
                style: MyTextStyle.montserratRegular(
                    size: 15, color: ColorRes.battleshipGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => controller.selectDate(Get.context!),
                child: Container(
                  height: 47,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: ColorRes.whiteSmoke,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      GetBuilder(
                          id: kChangeDate,
                          init: controller,
                          builder: (context) {
                            return Expanded(
                              child: Text(
                                controller.dateController.text,
                                style: MyTextStyle.montserratBold(
                                    size: 17, color: ColorRes.charcoalGrey),
                              ),
                            );
                          }),
                      Image.asset(
                        AssetRes.calender,
                        width: 20,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
