import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/model/wallet/wallet_statement.dart';
import 'package:patient_flutter/screen/recharge_wallet_sheet/recharge_wallet_sheet.dart';
import 'package:patient_flutter/screen/withdraw_request_screen/withdraw_request_screen.dart';
import 'package:patient_flutter/services/api_service.dart';

class WalletScreenController extends GetxController {
  RegistrationData? userData;
  int? start = 0;
  List<WalletStatementData>? walletData;
  bool isLoading = false;
  ScrollController statementController = ScrollController();

  @override
  void onInit() {
    fetchPatientData();
    fetchWalletStatementDataApiCall();
    fetchScrollData();
    super.onInit();
  }

  void onAddBtnClick() {
    Get.bottomSheet(
      const RechargeWalletSheet(
        screenType: 1,
      ),
      isScrollControlled: true,
    ).then((value) {
      start = 0;
      fetchPatientData();
      fetchWalletStatementDataApiCall();
    });
  }

  void fetchPatientData() {
    ApiService.instance.fetchMyUserDetails().then((value) {
      userData = value.data;
      update();
    });
  }

  void fetchWalletStatementDataApiCall() {
    isLoading = true;
    ApiService.instance.fetchWalletStatement(start: start).then((value) {
      if (start == 0) {
        walletData = value.data;
      } else {
        walletData?.addAll(value.data!);
      }
      start = walletData?.length;
      isLoading = false;
      update();
    });
  }

  void onWithdrawTap(RegistrationData? data) {
    ((data?.wallet ?? 0) > 99)
        ? Get.to(() => const WithdrawRequestScreen(),
                arguments: data?.wallet ?? 0)
            ?.then((value) {
            start = 0;
            fetchPatientData();
            fetchWalletStatementDataApiCall();
          })
        : CustomUi.snackBar(
            message: S.current.notEnoughBalanceToWithdraw,
            iconData: Icons.wallet_rounded);
  }

  void fetchScrollData() {
    statementController.addListener(
      () {
        if (statementController.offset ==
            statementController.position.maxScrollExtent) {
          if (!isLoading) {
            fetchWalletStatementDataApiCall();
          }
        }
      },
    );
  }
}
