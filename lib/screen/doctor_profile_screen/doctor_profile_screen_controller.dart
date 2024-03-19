import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/common_fun.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/chat/chat.dart';
import 'package:patient_flutter/model/doctor/doctor_review.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/screen/message_chat_screen/message_chat_screen.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfileScreenController extends GetxController {
  List<String> list = [
    S.current.details,
    S.current.reviews,
    S.current.education,
    S.current.experience,
    S.current.awards,
  ];
  int selectedCategoryIndex = 0;
  int start = 0;
  ScrollController scrollController = ScrollController();
  double maxExtent = 300.0;
  double currentExtent = 300.0;
  bool isExpertiseShowMore = false;
  bool isServiceShowMore = false;
  bool isPosition = false;
  bool isLoading = false;
  List<DoctorReviewData>? review;
  Doctor? doctorData;
  PrefService prefService = PrefService();
  RegistrationData? userData;
  bool isFavouriteId = false;
  bool isBackFavDoc = false;

  @override
  void onInit() {
    doctorData = Get.arguments;
    prefData();
    getDoctorProfile();
    initScrollController();
    fetchScrollData();
    super.onInit();
  }

  Future<void> getDoctorProfile() async {
    isLoading = true;
    await ApiService.instance
        .fetchDoctorProfile(doctorId: doctorData?.id)
        .then((value) {
      doctorData = value.data;
      isLoading = false;
      update();
    });
    fetchDoctorReviewsApiCall();
  }

  void fetchDoctorReviewsApiCall() {
    ApiService.instance
        .fetchDoctorReviews(doctorId: doctorData?.id, start: start)
        .then(
      (value) {
        if (start == 0) {
          review = value.data;
        } else {
          review?.addAll(value.data!);
        }
        start += review!.length;
        update();
      },
    );
  }

  void fetchScrollData() {
    scrollController.addListener(
      () {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          fetchDoctorReviewsApiCall();
        }
      },
    );
  }

  void onExpertiseShowMoreTap() {
    isExpertiseShowMore = !isExpertiseShowMore;
  }

  void onServicesShowMoreTap() {
    isServiceShowMore = !isServiceShowMore;
  }

  void onCategoryChange(int index) {
    selectedCategoryIndex = index;
    update();
  }

  void initScrollController() {
    scrollController.addListener(() {
      currentExtent = maxExtent - scrollController.offset;
      if (currentExtent < 0) currentExtent = 0.0;
      if (currentExtent > maxExtent) currentExtent = maxExtent;
      update();
    });
  }

  void prefData() async {
    await prefService.init();
    userData = prefService.getRegistrationData();
    isFavouriteId =
        userData?.favouriteDoctors?.contains('${doctorData?.id}') ?? false;
    update();
  }

  void updateProfileApiCall() {
    isFavouriteId = !isFavouriteId;
    String? savedProfile = userData?.favouriteDoctors;
    List<String> savedId = [];
    if (savedProfile == null || savedProfile.isEmpty) {
      savedProfile = doctorData?.id.toString();
    } else {
      savedId = savedProfile.split(',');
      if (savedProfile.contains('${doctorData?.id}')) {
        savedId.remove(doctorData?.id.toString());
      } else {
        savedId.add(doctorData?.id.toString() ?? '-1');
      }
      savedProfile = savedId.join(',');
    }

    ApiService.instance
        .updateUserDetails(favouriteDoctors: savedProfile)
        .then((value) {
      userData = value.data;
      isFavouriteId = value.data?.favouriteDoctors
              ?.contains(doctorData?.id.toString() ?? '-1') ??
          false;
      isBackFavDoc = true;
      update();
    });
  }

  void onChatBtnTap() {
    ChatUser chatUser = ChatUser(
        image: doctorData?.image,
        designation: doctorData?.designation,
        msgCount: 0,
        userid: doctorData?.id,
        userIdentity: doctorData?.identity,
        username: doctorData?.name);
    Conversation conversation = Conversation(
        time: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: CommonFun.getConversationId(
            patient: userData?.id, doctorId: doctorData?.id),
        deletedId: '',
        isDeleted: false,
        lastMsg: '',
        newMsg: '',
        user: chatUser);
    Get.to(() => const MessageChatScreen(),
        arguments: [conversation, userData]);
  }

  void onCallBtnTap() {
    launchUrl(
        Uri.parse('tel:${doctorData?.mobileNumber?.split(' ')[0] ?? ''}'));
  }
}
