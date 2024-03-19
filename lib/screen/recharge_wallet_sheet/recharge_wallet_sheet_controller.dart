import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/global/global_setting.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/screen/confirm_booking_screen/widget/transaction_complete_sheet.dart';
import 'package:patient_flutter/screen/recharge_wallet_sheet/widget/payment_gateway.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:patient_flutter/utils/update_res.dart';

class RechargeWalletSheetController extends GetxController {
  List<String> list = [
    '50',
    '100',
    '150',
    '200',
    otherCap,
  ];
  String selectedAmount = '0';
  int? selectedAmountIndex;
  TextEditingController amountController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();
  PrefService prefService = PrefService();
  GlobalSettingData? settings;
  RegistrationData? user;

  @override
  void onInit() {
    prefData();
    selectedAmount = Get.arguments ?? '0';
    amountController.text = Get.arguments ?? '0';
    super.onInit();
  }

  void onCategoryChange(int categoryIndex) {
    selectedAmountIndex = categoryIndex;
    if (list[selectedAmountIndex!] == otherCap) {
      amountFocusNode.requestFocus();
    } else {
      selectedAmount = list[selectedAmountIndex!];
      amountFocusNode.unfocus();
      amountController.clear();
    }
    update();
  }

  void onTextChange(String value) {
    selectedAmount =
        amountController.text.isEmpty ? '0' : amountController.text;
    update();
  }

  void onContinueTap(int type) {
    amountFocusNode.unfocus();

    if (settings?.paymentGateway == 1) {
      CustomUi.loader();
      StripePayment().makePayment(
        amount: selectedAmount,
        currency: settings?.stripeCurrencyCode ?? '',
        user: user,
        authKey: settings?.stripeSecret ?? '',
        onError: (error) {
          Get.back();
          CustomUi.infoSnackBar(S.current.paymentFailed);
        },
        onSuccess: (value) {
          Get.back();
          apiCall(type,
              paymentGateway: 1,
              transactionId: value['id'],
              transactionSummary: jsonEncode(value));
        },
      );
    } else if (settings?.paymentGateway == 3) {
      /// card Payment :- 4111 1111 1111 1111
      RazorPayPayment().makePayment(
        amount: selectedAmount,
        authKey: settings?.razorpayKey ?? '',
        currency: settings?.razorpayCurrencyCode ?? '',
        user: user,
        handleExternalWalletSelected: (response) {
          CustomUi.infoSnackBar(response.toString());
        },
        handlePaymentErrorResponse: (response) {
          CustomUi.infoSnackBar(response.message.toString());
        },
        handlePaymentSuccessResponse: (response) {
          Map<String, dynamic> map = {};
          map["razorpay_payment_id"] = response.paymentId;
          map["razorpay_signature"] = response.signature;
          map["razorpay_order_id"] = response.orderId;

          String data = jsonEncode(map);
          apiCall(type,
              paymentGateway: 3,
              transactionSummary: data,
              transactionId: response.paymentId.toString());
        },
      );
    } else if (settings?.paymentGateway == 4) {
      ///Test card:- 4084084084084081
      ///03/24
      ///408
      PaystackPayment().makePayment(
        user: user,
        amount: selectedAmount,
        publicKey: settings?.paystackPublicKey ?? '',
        authKey: settings?.paystackSecretKey ?? '',
        currency: settings?.paystackCurrencyCode ?? '',
        onSuccess: (response) {
          if (jsonDecode(response)['status'] == true) {
            apiCall(type,
                paymentGateway: 4,
                transactionId: jsonDecode(response)['data']['reference'] ??
                    'No TransactionId',
                transactionSummary: jsonEncode(response));
          } else {
            CustomUi.infoSnackBar(S.current.paymentCancelled);
          }
        },
      );
    } else if (settings?.paymentGateway == 5) {
      /// Card Type: Visa
      /// Card Number: 4032 0323 7188 0367
      /// Expiration Date: 01/2024
      /// CVV: 571
      PaypalPayment().makePayment(
        user: user,
        amount: selectedAmount,
        currency: settings?.paypalCurrencyCode ?? 'USD',
        authKey: settings?.paypalSecretKey ?? '',
        clientId: settings?.paypalClientId ?? '',
        onSuccess: (param) {
          apiCall(type,
              paymentGateway: 5,
              transactionId: param['paymentId'],
              transactionSummary: jsonEncode(param));
        },
        onError: (error) {
          CustomUi.infoSnackBar(S.current.somethingWentWrong);
        },
        onCancel: (param) {
          CustomUi.infoSnackBar(S.current.paymentCancelled);
        },
      );
    } else if (settings?.paymentGateway == 6) {
      /// 'Card number' = 5531 8866 5214 2950
      /// 'Expiry' = 09 / 32
      /// 'CVV' = 564
      /// 'OTP' = 12345
      /// 'PIN' = 3310
      FlutterwavePayment().makePayment(
        user: user,
        amount: selectedAmount,
        publishKey: settings?.flutterwavePublicKey ?? '',
        currency: settings?.flutterwaveCurrencyCode ?? 'USD',
        onError: (error) {
          CustomUi.infoSnackBar(error);
        },
        onSuccess: (param) {
          // apiCall(
          //   type,
          //   paymentGateway: 6,
          //   transactionId: param.transactionId ?? '',
          //   transactionSummary: jsonEncode(param),
          // );
        },
      );
    }
  }

  void apiCall(int type,
      {required int paymentGateway,
      required String transactionId,
      required String transactionSummary}) {
    if (type == 1) {
      addMoneyApiCall(
          paymentGateway: paymentGateway,
          transactionSummary: transactionSummary,
          transactionId: transactionId);
    } else {
      addMoneyApiCall(
              paymentGateway: paymentGateway,
              transactionSummary: transactionSummary,
              transactionId: transactionId)
          .then((value) {
        Get.bottomSheet(const TransactionCompleteSheet(),
            isScrollControlled: true);
      });
    }
  }

  Future<void> addMoneyApiCall(
      {required int paymentGateway,
      required String transactionId,
      required String transactionSummary}) async {
    CustomUi.loader();
    await ApiService.instance
        .addMoneyToUserWallet(
            amount: num.parse(selectedAmount),
            paymentGateway: paymentGateway,
            transactionId: transactionId,
            transactionSummary: transactionSummary)
        .then((value) {
      Get.back();
      Get.back();
      if (value.status == true) {
        CustomUi.snackBar(
            iconData: Icons.wallet, positive: true, message: value.message);
      } else {
        CustomUi.snackBar(iconData: Icons.wallet, message: value.message);
      }
    });
  }

  void prefData() async {
    await prefService.init();
    settings = prefService.getSettings();
    user = prefService.getRegistrationData();
    // Stripe.publishableKey = settings?.stripePublishableKey ?? '';
    update();
  }
}
