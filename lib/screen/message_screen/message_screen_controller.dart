import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/confirmation_dialog.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/chat/chat.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:patient_flutter/utils/firebase_res.dart';

class MessageScreenController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Conversation?> userList = [];
  bool isLoading = false;
  StreamSubscription<QuerySnapshot<Conversation>>? subscription;
  PrefService prefService = PrefService();
  RegistrationData? userData;

  @override
  void onInit() {
    getChatUsers();
    super.onInit();
  }

  void getChatUsers() async {
    await prefService.init();
    userData = prefService.getRegistrationData();
    isLoading = true;
    subscription = db
        .collection(FirebaseRes.userChatList)
        .doc('${userData?.id}')
        .collection(FirebaseRes.userList)
        .orderBy(FirebaseRes.time, descending: true)
        .where(FirebaseRes.isDeleted, isEqualTo: false)
        .withConverter(
            fromFirestore: Conversation.fromFirestore,
            toFirestore: (Conversation value, options) => value.toFirestore())
        .snapshots()
        .listen((element) {
      userList = [];
      for (int i = 0; i < element.docs.length; i++) {
        userList.add(element.docs[i].data());
      }
      isLoading = false;
      update();
    });
  }

  void onLongPress(Conversation? conversation) {
    HapticFeedback.vibrate();
    Get.dialog(
      ConfirmationDialog(
        aspectRatio: 1 / 0.6,
        positiveText: S.current.deleteChat,
        title: S.current.messageWillOnlyBeRemovedEtc,
        onPositiveBtn: () {
          Get.back();
          db
              .collection(FirebaseRes.userChatList)
              .doc('${userData?.id}')
              .collection(FirebaseRes.userList)
              .doc('${conversation?.user?.userid}')
              .update({
            FirebaseRes.isDeleted: true,
            FirebaseRes.deletedId: '${DateTime.now().millisecondsSinceEpoch}',
          });
        },
      ),
    );
    update();
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }
}
