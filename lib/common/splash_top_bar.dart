import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/utils/asset_res.dart';
import 'package:patient_flutter/utils/color_res.dart';

class SplashTopBar extends StatelessWidget {
  final bool isBackArrowVisible;

  const SplashTopBar({Key? key, this.isBackArrowVisible = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 1.6,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorRes.crystalBlue,
                  ColorRes.tuftsBlue100,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Image(
            image: const AssetImage(
              AssetRes.dMale,
            ),
            height: Get.height / 2.2,
            fit: BoxFit.fitHeight,
          ),
          Visibility(
            visible: isBackArrowVisible,
            child: Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.arrow_back,
                      color: ColorRes.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
