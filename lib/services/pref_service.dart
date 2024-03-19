import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/chat/chat.dart';
import 'package:patient_flutter/model/custom/countries.dart';
import 'package:patient_flutter/model/global/global_setting.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/utils/firebase_res.dart';
import 'package:patient_flutter/utils/update_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  SharedPreferences? preferences;
  static int userId = -1;
  static String identity = '';

  Future init() async {
    preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<void> saveString({required String key, required String value}) async {
    await preferences?.setString(key, value);
    userId = getRegistrationData()?.id ?? -1;
    log('👉 $userId 👈');
    identity = getRegistrationData()?.identity ?? '';
  }

  Future<void> saveList(
      {required String key, required List<String> value}) async {
    await preferences?.setStringList(key, value);
  }

  String? getString({required String key}) {
    return preferences?.getString(key);
  }

  Future<void> setLogin({required String key, required bool value}) async {
    await preferences?.setBool(key, value);
  }

  bool? getBool({required String key}) {
    return preferences?.getBool(key);
  }

  RegistrationData? getRegistrationData() {
    if (getString(key: kRegistrationUser) == null) {
      return null;
    } else {
      return RegistrationData.fromJson(
          jsonDecode(getString(key: kRegistrationUser)!));
    }
  }

  GlobalSettingData? getSettings() {
    if (getString(key: kGlobalSetting) == null) return null;
    return GlobalSettingData.fromJson(
      jsonDecode(getString(key: kGlobalSetting)!),
    );
  }

  Countries? getCountries() {
    if (getString(key: kCountries) == null) return null;
    return Countries.fromJson(jsonDecode(getString(key: kCountries)!));
  }

  void updateFirebaseProfile() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    RegistrationData? userData = getRegistrationData();
    db
        .collection(FirebaseRes.userChatList)
        .doc('${userData?.id}')
        .collection(FirebaseRes.userList)
        .withConverter(
          fromFirestore: Conversation.fromFirestore,
          toFirestore: (Conversation value, options) {
            return value.toFirestore();
          },
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection(FirebaseRes.userChatList)
            .doc('${element.data().user?.userid}')
            .collection(FirebaseRes.userList)
            .doc('${userData?.id}')
            .withConverter(
              fromFirestore: Conversation.fromFirestore,
              toFirestore: (Conversation value, options) {
                return value.toFirestore();
              },
            )
            .get()
            .then((value) {
          ChatUser? user = value.data()?.user;
          user?.username = userData?.fullname ?? S.current.unKnown;
          user?.image = userData?.profileImage;
          user?.userid = userData?.id;
          db
              .collection(FirebaseRes.userChatList)
              .doc('${element.data().user?.userid}')
              .collection(FirebaseRes.userList)
              .doc('${userData?.id}')
              .update({FirebaseRes.user: user?.toJson()});
        });
      }
    });
  }
}
