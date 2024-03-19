import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/common/text_button_custom.dart';
import 'package:patient_flutter/common/top_bar_area.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:patient_flutter/utils/asset_res.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileScreenController());
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: GetBuilder(
        init: controller,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarArea(title: S.current.editProfile),
              GetBuilder(
                  init: controller,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: controller.onImageTap,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: controller.imageFile != null
                                  ? Image.file(
                                      controller.imageFile!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : controller.userData?.profileImage != null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              '${ConstRes.itemBaseURL}${controller.userData?.profileImage}',
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return CustomUi.doctorPlaceHolder(
                                                gender: controller
                                                    .userData?.gender);
                                          },
                                        )
                                      : CustomUi.userPlaceHolder(
                                          height: 120,
                                          gender:
                                              controller.userData?.gender ?? 0,
                                        ),
                            ),
                            Container(
                              height: 28,
                              width: 28,
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: ColorRes.charcoalGrey,
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    child: Image.asset(
                                      AssetRes.messageEditBox,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(S.current.yourFullname,
                    style: MyTextStyle.montserratRegular(
                        size: 15, color: ColorRes.battleshipGrey)),
              ),
              GetBuilder(
                init: controller,
                builder: (context) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: ColorRes.silverChalice.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: controller.fullNameController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: InputBorder.none,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      style: MyTextStyle.montserratBold(
                          size: 17, color: ColorRes.charcoalGrey),
                      cursorColor: ColorRes.charcoalGrey,
                      cursorHeight: 17,
                    ),
                  );
                },
              ),
              const Spacer(),
              SafeArea(
                top: false,
                child: TextButtonCustom(
                    onPressed: controller.onContinueTap,
                    title: S.current.continueText,
                    titleColor: ColorRes.white,
                    backgroundColor: ColorRes.darkSkyBlue,
                    bottomMargin: 10),
              )
            ],
          );
        },
      ),
    );
  }
}
