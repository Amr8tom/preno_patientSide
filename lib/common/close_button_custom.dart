import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/utils/color_res.dart';

class CloseButtonCustom extends StatelessWidget {
  const CloseButtonCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        height: 37,
        width: 37,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorRes.havelockBlue.withOpacity(0.1)),
        child: const Icon(
          Icons.close_rounded,
          color: ColorRes.charcoalGrey,
          size: 18,
        ),
      ),
    );
  }
}
