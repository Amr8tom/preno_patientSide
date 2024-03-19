import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class TopBarArea extends StatelessWidget {
  final String title;
  final Function()? onQrCodeTap;
  final bool isQrCodeVisible;

  const TopBarArea({
    Key? key,
    required this.title,
    this.isQrCodeVisible = false,
    this.onQrCodeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorRes.whiteSmoke,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Directionality.of(context) == TextDirection.rtl
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.only(
                      right: Directionality.of(context) == TextDirection.rtl
                          ? 10
                          : 0,
                      left: Directionality.of(context) == TextDirection.rtl
                          ? 0
                          : 10),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: MyTextStyle.montserratBold(
                size: 17,
                color: ColorRes.charcoalGrey,
              ),
            ),
            Visibility(
              visible: isQrCodeVisible,
              child: Align(
                alignment: Directionality.of(context) == TextDirection.rtl
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: InkWell(
                  onTap: onQrCodeTap,
                  child: Container(
                    height: 36,
                    width: 36,
                    margin: EdgeInsets.only(
                        right: Directionality.of(context) == TextDirection.rtl
                            ? 0
                            : 10,
                        left: Directionality.of(context) == TextDirection.rtl
                            ? 0
                            : 10),
                    decoration: BoxDecoration(
                        color: ColorRes.silver.withOpacity(0.21),
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.qr_code_2,
                      color: ColorRes.charcoalGrey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
