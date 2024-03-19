import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/confirmation_dialog.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/model/custom/order_summary.dart';
import 'package:patient_flutter/screen/appointment_detail_screen/widget/rating_sheet.dart';
import 'package:patient_flutter/screen/select_date_time_screen/select_date_time_screen.dart';
import 'package:patient_flutter/services/api_service.dart';

class AppointmentDetailScreenController extends GetxController {
  int? appointmentId;
  TextEditingController ratingController = TextEditingController();
  AppointmentData? appointmentData;
  OrderSummary? orderSummary;
  bool isLoading = false;
  double? ratingCount;
  bool isExpanded = false;

  @override
  void onInit() {
    appointmentId = Get.arguments;
    fetchAppointmentDetailsApiCall();
    super.onInit();
  }

  void onRatingTap(AppointmentDetailScreenController controller) {
    Get.bottomSheet(
            RatingSheet(
              controller: controller,
              onRatingTap: (rating) {
                ratingCount = rating;
              },
              onRatingSubmit: () {
                if (ratingCount == null) {
                  return CustomUi.snackBar(
                      message: S.current.pleaseAtLeastRatingAdd,
                      iconData: Icons.star_rate_rounded);
                }
                if (ratingController.text.isEmpty) {
                  return CustomUi.snackBar(
                      message: S.current.pleaseAddComment,
                      iconData: Icons.comment_bank_rounded);
                }
                ApiService.instance
                    .addRating(
                        appointmentId: appointmentId,
                        comment: ratingController.text,
                        rating: ratingCount?.toInt(),
                        userId: appointmentData?.userId)
                    .then(
                  (value) {
                    if (value.status == true) {
                      Get.back();
                      CustomUi.snackBar(
                          iconData: Icons.star_rate_rounded,
                          message: value.message,
                          positive: true);
                      appointmentData = value.data;
                      update();
                    } else {
                      CustomUi.snackBar(
                          message: value.message ?? '',
                          iconData: Icons.star_rate_rounded);
                    }
                  },
                );
              },
            ),
            isScrollControlled: true)
        .then((value) {
      ratingCount = null;
      ratingController.text = '';
    });
  }

  void onRatingChange(String value) {
    update();
  }

  void onExpandTap(bool value) {
    isExpanded = value;
    update();
  }

  void fetchAppointmentDetailsApiCall() {
    isLoading = true;
    ApiService.instance
        .fetchAppointmentDetails(appointmentId: appointmentId)
        .then((value) {
      appointmentData = value.data;
      isLoading = false;
      update();
    });
  }

  void onRescheduleTap(AppointmentData? data) {
    Get.to(() => const SelectDateTimeScreen(addAppointment: 1),
        arguments: [data?.doctor, data])?.then((value) {
      fetchAppointmentDetailsApiCall();
    });
  }

  onCancelBtnClick(AppointmentData? data) {
    Get.dialog(ConfirmationDialog(
      onPositiveBtn: () {
        Get.back();
        CustomUi.loader();
        ApiService.instance
            .cancelAppointment(appointmentId: data?.id, userId: data?.userId)
            .then((value) {
          Get.back();
          if (value.status == true) {
            appointmentData = value.data;
            CustomUi.snackBar(
                message: value.message ?? '',
                iconData: Icons.cancel_rounded,
                positive: true);
            update();
          } else {
            CustomUi.snackBar(
                message: value.message ?? '', iconData: Icons.cancel_rounded);
          }
        });
      },
      title: S.current.areYouSure,
      title2: S.current.doYouWantToCancelThisAppointment,
      positiveText: S.current.cancel,
      negativeText: S.current.back,
      aspectRatio: 1 / 0.6,
    ));
  }
}
