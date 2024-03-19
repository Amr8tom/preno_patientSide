import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/screen/notification_screen/notification_screen.dart';
import 'package:patient_flutter/screen/search_screen/search_screen.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class HomeTopArea extends StatelessWidget {
  final RegistrationData? userData;

  const HomeTopArea({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 3.9,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: MyTextStyle.linearBottomGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${S.current.hello}, ${userData?.fullname ?? S.current.unKnown}',
                        style: MyTextStyle.montserratExtraBold(
                            size: 21, color: ColorRes.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        S.current.howAreYouEtc,
                        style: MyTextStyle.montserratLight(
                            size: 15, color: ColorRes.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const NotificationScreen());
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        color: ColorRes.white.withOpacity(0.10),
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: ColorRes.white,
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Get.to(() => const SearchScreen());
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: ColorRes.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: ColorRes.white.withOpacity(0.30), width: 2.5)),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: ColorRes.white.withOpacity(0.75),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        S.current.searchForDoctorEtc,
                        style: MyTextStyle.montserratSemiBold(
                          size: 15,
                          color: ColorRes.white.withOpacity(0.75),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
