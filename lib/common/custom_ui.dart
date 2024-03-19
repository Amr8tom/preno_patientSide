import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/utils/asset_res.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';
import 'package:patient_flutter/utils/update_res.dart';

class CustomUi {
  static void snackBar({
    String? message,
    bool positive = false,
    required IconData iconData,
  }) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        messageText: Text(
          message ?? '',
          style: MyTextStyle.montserratMedium(
              color: positive ? ColorRes.white : ColorRes.lightRed, size: 14),
        ),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        icon: Icon(
          iconData,
          color: positive ? ColorRes.white : ColorRes.lightRed,
          size: 24,
        ),
        backgroundColor: positive ? ColorRes.havelockBlue : ColorRes.pinkLace,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      );
    }
  }

  static void infoSnackBar(
    String msg,
  ) {
    snackBar(message: msg, iconData: Icons.info_rounded, positive: false);
  }

  static Future<void> loader() {
    return showDialog(
      context: Get.context!,
      // barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: ColorRes.havelockBlue,
          ),
        );
      },
    );
  }

  static Widget loaderWidget() {
    return Center(
      // child: CircularProgressIndicator(color: ColorRes.havelockBlue),
      child: Lottie.asset(AssetRes.lottieLoad, height: 130),
    );
  }

  static Widget userPlaceHolder({int gender = 0, double height = 100}) {
    return Container(
      height: height,
      width: height,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ColorRes.darkSkyBlue.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(
        gender == 0 ? AssetRes.female : AssetRes.male,
        color: ColorRes.grey,
      ),
    );
  }

  static Widget ratingIndicator(
      {required double rating, required double ratingSize}) {
    return RatingBarIndicator(
      itemCount: 5,
      itemSize: ratingSize,
      rating: rating,
      itemBuilder: (context, index) {
        return Icon(
          Icons.star_rate_rounded,
          color: ColorRes.mangoOrange,
          size: ratingSize,
        );
      },
    );
  }

  static Widget doctorPlaceHolder(
      {int? gender = 0, double height = 100, double radius = 10}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        color: ColorRes.darkSkyBlue.withOpacity(0.4),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Image.asset(
        gender == 0 ? AssetRes.dFemale : AssetRes.dMale,
        color: ColorRes.grey,
      ),
    );
  }

  static String convert24HoursInto12Hours(String? value) {
    DateTime dateTime = DateTime(
      DateTime.now().year,
      1,
      1,
      int.parse(value?.substring(0, 2) ?? '0'),
      int.parse(value?.substring(2, 4) ?? '0'),
    );
    return DateFormat(hhMmA, 'en').format(dateTime);
  }

  static String startAndEndTimeWork(String? startTime, String? endTime) {
    print(endTime);
    print(startTime);
    String start = convert24HoursInto12Hours(startTime);
    String end = convert24HoursInto12Hours(endTime);
    return "$start\n$end";
  }

  // static String convert24HoursInto12Hours(String? value) {
  //   DateTime dateTime = DateTime(
  //     DateTime.now().year,
  //     1,
  //     1,
  //     int.parse(value?.substring(0, 2) ?? '0'),
  //     int.parse(value?.substring(2, 4) ?? '0'),
  //   );
  //   return DateFormat(hhMmA, 'en').format(dateTime);
  // }

  static String dateFormat(String? date) {
    DateTime parseDate = DateFormat(yyyyMMDd, 'en').parse(date ?? '');
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat(ddMMMYyyy, 'en');
    String outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static Widget noData({String? title}) {
    return Center(
      child: Text(
        title ?? S.current.noData,
        style: MyTextStyle.montserratMedium(
            color: ColorRes.battleshipGrey, size: 16),
      ),
    );
  }
}
