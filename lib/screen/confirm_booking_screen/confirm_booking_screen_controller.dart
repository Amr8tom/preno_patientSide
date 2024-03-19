import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/model/appointment/coupon.dart';
import 'package:patient_flutter/model/custom/categories.dart';
import 'package:patient_flutter/model/custom/order_summary.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/model/global/taxes.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/screen/appointment_booked_screen/appointment_booked_screen.dart';
import 'package:patient_flutter/screen/coupon_sheet/coupon_sheet.dart';
import 'package:patient_flutter/screen/recharge_wallet_sheet/recharge_wallet_sheet.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/services/pref_service.dart';

class ConfirmBookingScreenController extends GetxController {
  PrefService prefService = PrefService();
  List<CouponData>? coupons;
  AppointmentDetail? detail;
  CouponData? selectedCoupon;
  Doctor? doctorData;
  num serviceAmount = 0;
  num discountAmount = 0;
  num subTotal = 0;
  num payableAmount = 0.round();
  List<Taxes> taxes = [];
  num totalTaxAmount = 0;
  RegistrationData? userData;
  int? numSlots;

  @override
  void onInit() {
    prefData();
    detail = Get.arguments[0];
    doctorData = Get.arguments[1];
    super.onInit();
  }

  void onCouponCancel() {
    selectedCoupon = null;
    discountAmount = 0;
    _taxCalculation(detail?.serviceAmount ?? 0);
  }

  void onApplyCouponTap() {
    Get.bottomSheet(
      CouponSheet(onCouponTap: onCouponTap),
      isScrollControlled: true,
    );
  }

  void onCouponTap(CouponData? couponData) {
    Get.back();
    selectedCoupon = couponData;
    double? couponAmount =
        (serviceAmount * (couponData?.percentage ?? 0)) / 100;
    if (couponAmount > (couponData?.maxDiscountAmount ?? 0)) {
      discountAmount = (couponData?.maxDiscountAmount ?? 0);
    } else {
      discountAmount = couponAmount.round();
    }
    subTotal = serviceAmount - discountAmount;
    _taxCalculation(subTotal);
  }

  void prefData() async {
    await prefService.init();
    userData = prefService.getRegistrationData();
    taxes = prefService.getSettings()?.taxes ?? [];
    serviceAmount = (detail?.serviceAmount ?? 0);
    _taxCalculation(detail?.serviceAmount ?? 0);
  }

  void _taxCalculation(num taxableAmount) {
    subTotal = taxableAmount;
    totalTaxAmount = 0;
    if (taxes.isNotEmpty) {
      for (int i = 0; i < taxes.length; i++) {
        taxes[i].calculateTaxAmount(taxableAmount);
        totalTaxAmount += taxes[i].taxAmount ?? 0;
      }
    }
    payableAmount = (subTotal + totalTaxAmount).round();
    update();
  }

  void onPayNow() {
    OrderSummary orderSummary = OrderSummary(
      discountAmount: discountAmount,
      coupon: selectedCoupon,
      couponApply: selectedCoupon == null ? 0 : 1,
      payableAmount: payableAmount.round(),
      serviceAmount: serviceAmount,
      subtotal: subTotal,
      totalTaxAmount: num.parse(totalTaxAmount.toStringAsFixed(2)),
      taxes: taxes,
    );
    if ((userData?.wallet ?? 0) >= (payableAmount)) {
      CustomUi.loader();
      ApiService.instance
          .addAppointment(
              startTime: detail!.startTime,
              doctorId: doctorData?.id,
              problem: detail?.problem ?? '',
              date: detail?.date ?? '',
              time: detail?.time ?? '',
              patientId: detail?.patientId,
              orderSummary: orderSummary,
              payableAmount: payableAmount,
              documents: detail?.documents,
              type: detail?.type,
              isCouponApplied: selectedCoupon == null ? 0 : 1,
              discountAmount: discountAmount,
              totalTaxAmount: totalTaxAmount,
              serviceAmount: serviceAmount,
              subTotal: subTotal)
          .then((value) {
        Get.back();
        if (value.status == true) {
          CustomUi.snackBar(
              iconData: Icons.done_outline,
              positive: true,
              message: value.message);
          Get.offAll(() => const AppointmentBookedScreen(),
              arguments: value.data);
        } else {
          CustomUi.snackBar(
              iconData: Icons.done_outline, message: value.message);
        }
      });
    } else {
      // String value = '';
      // value = (payableAmount - (userData?.wallet ?? 0)).round().toString();
      Get.bottomSheet(
        const RechargeWalletSheet(
          screenType: 2,
        ),
        isScrollControlled: true,
        settings: RouteSettings(arguments: userData?.wallet.toString()),
      ).then(
        (value) async {
          userData = prefService.getRegistrationData();
          update();
        },
      );
    }
  }

  void onPayLater() {
    OrderSummary orderSummary = OrderSummary(
      discountAmount: discountAmount,
      coupon: selectedCoupon,
      couponApply: selectedCoupon == null ? 0 : 1,
      payableAmount: payableAmount.round(),
      serviceAmount: serviceAmount,
      subtotal: subTotal,
      totalTaxAmount: num.parse(totalTaxAmount.toStringAsFixed(2)),
      taxes: taxes,
    );
    CustomUi.loader();
    ApiService.instance
        .addAppointment(
            startTime: detail!.startTime,
            doctorId: doctorData?.id,
            problem: detail?.problem ?? '',
            date: detail?.date ?? '',
            time: detail?.time ?? '',
            patientId: detail?.patientId,
            f: orderSummary,
            payableAmount: 0,
            documents: detail?.documents,
            type: detail?.type,
            isCouponApplied: selectedCoupon == null ? 0 : 1,
            discountAmount: discountAmount,
            totalTaxAmount: totalTaxAmount,
            serviceAmount: serviceAmount,
            subTotal: subTotal)
        .then((value) {
      Get.back();
      if (value.status == true) {
        CustomUi.snackBar(
            iconData: Icons.done_outline,
            positive: true,
            message: value.message);
        Get.offAll(() => const AppointmentBookedScreen(),
            arguments: value.data);
      } else {
        CustomUi.snackBar(iconData: Icons.done_outline, message: value.message);
      }
    });
  }
}
