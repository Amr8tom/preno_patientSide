import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/common/fancy_button.dart';
import 'package:patient_flutter/common/image_send_sheet.dart';
import 'package:patient_flutter/common/video_upload_dialog.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/model/chat/appointment_chat.dart';
import 'package:patient_flutter/screen/video_call_screen/video_call_screen.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/firebase_res.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AppointmentChatScreenController extends GetxController {
  TextEditingController msgController = TextEditingController();
  TextEditingController sendMediaController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<AppointmentChat> chatData = [];
  int start = 15;
  AppointmentData? appointmentData;
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference? collection;
  bool isOpen = false;
  GlobalKey<FancyButtonState> key = GlobalKey<FancyButtonState>();
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;
  String? videoUrl;
  StreamSubscription<QuerySnapshot<AppointmentChat>>? chatCollectionStream;
  static String appointmentId = '';

  @override
  void onInit() {
    appointmentData = Get.arguments;
    appointmentId = appointmentData?.appointmentNumber ?? '';
    initFirebase();
    super.onInit();
  }

  void initFirebase() async {
    collection = db
        .collection(FirebaseRes.appointmentChat)
        .doc(appointmentData?.appointmentNumber ?? '')
        .collection(FirebaseRes.chat);
    getChat();
    scrollToFetchData();
  }

  void onSendTextMsg() {
    if (msgController.text.isNotEmpty) {
      chatMessage(msgType: FirebaseRes.text, msg: msgController.text.trim());
      msgController.clear();
    }
  }

  void chatMessage(
      {String? msg,
      required String msgType,
      String? image,
      String? video}) async {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    collection?.doc(time).set(
          AppointmentChat(
            id: time,
            image: image,
            msg: msg,
            msgType: msgType,
            video: video,
            videoCall: VideoCall(),
            senderUser: AppointmentUser(
              name: appointmentData?.user?.fullname ?? '',
              userId: appointmentData?.user?.id,
              image: appointmentData?.user?.profileImage,
              identity: appointmentData?.user?.identity,
              dob: appointmentData?.user?.dob,
            ),
          ).toJson(),
        );

    if (appointmentData?.doctor?.isNotification == 1) {
      ApiService().pushNotification(
          authorization: ConstRes.authorisationKey,
          title: appointmentData?.appointmentNumber ?? '',
          body: msgType == FirebaseRes.image
              ? '🖼️ ${FirebaseRes.image}'
              : msgType == FirebaseRes.video
                  ? '🎥 ${FirebaseRes.video}'
                  : '$msg',
          token: appointmentData?.doctor?.deviceToken ?? '',
          notificationType: '1',
          appointmentId: appointmentData?.appointmentNumber);
    }
  }

  void scrollToFetchData() {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getChat();
      }
    });
  }

  void getChat() async {
    chatCollectionStream = collection
        ?.orderBy(FirebaseRes.id, descending: true)
        .limit(start)
        .withConverter(
          fromFirestore: AppointmentChat.fromFireStore,
          toFirestore: (AppointmentChat value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen((event) {
      chatData = [];
      for (int i = 0; i < event.docs.length; i++) {
        chatData.add(event.docs[i].data());
      }
      start += 5;
      update();
    });
  }

  void onImageTap({required ImageSource source}) async {
    key.currentState?.animate();
    final XFile? galleryImage = await _picker.pickImage(
        source: source,
        imageQuality: ConstRes.imageQuality,
        maxHeight: ConstRes.maxHeight,
        maxWidth: ConstRes.maxWidth);
    if (galleryImage != null) {
      ApiService.instance
          .uploadFileGivePath(File(galleryImage.path))
          .then((value) {
        imageUrl = value.path;
      });
      Get.bottomSheet(
              ImageSendSheet(
                image: galleryImage.path,
                onSendMediaTap: (image) =>
                    onSendMediaTap(image: galleryImage.path, type: 0),
                sendMediaController: sendMediaController,
              ),
              isScrollControlled: true)
          .then((value) {
        sendMediaController.clear();
      });
    }
  }

  void onVideoTap() async {
    key.currentState?.animate();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      /// calculating file size
      final videoFile = File(video.path);
      int sizeInBytes = videoFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb <= 15) {
        CustomUi.loader();
        ApiService.instance.uploadFileGivePath(File(video.path)).then((value) {
          videoUrl = value.path;
        });
        VideoThumbnail.thumbnailFile(video: video.path).then((value) {
          ApiService.instance
              .uploadFileGivePath(File(value ?? ''))
              .then((value) {
            imageUrl = value.path;
          });
          Get.back();
          Get.bottomSheet(
                  ImageSendSheet(
                    image: value ?? '',
                    onSendMediaTap: (String image) => onSendMediaTap(
                        image: value ?? '', type: 1, video: videoFile.path),
                    sendMediaController: sendMediaController,
                  ),
                  isScrollControlled: true)
              .then((value) {
            sendMediaController.clear();
          });
        });
      } else {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return VideoUploadDialog(selectAnother: () {
              Get.back();
              onVideoTap();
            });
          },
        );
      }
    }
  }

  void onSendMediaTap(
      {required String image, required int type, String? video}) async {
    if (type == 0) {
      if (imageUrl == null) {
        await ApiService.instance.uploadFileGivePath(File(image)).then((value) {
          imageUrl = value.path;
        });
      }
      Get.back();
      chatMessage(
          msgType: FirebaseRes.image,
          msg: sendMediaController.text.trim(),
          image: imageUrl);
    } else {
      if (videoUrl == null) {
        await ApiService.instance
            .uploadFileGivePath(File(video ?? ''))
            .then((value) {
          videoUrl = value.path;
        });
      } else if (imageUrl == null) {
        await ApiService.instance.uploadFileGivePath(File(image)).then((value) {
          imageUrl = value.path;
        });
      }
      Get.back();
      chatMessage(
        msgType: FirebaseRes.video,
        msg: sendMediaController.text.trim(),
        image: imageUrl,
        video: videoUrl,
      );
    }
  }

  void allScreenTap() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (key.currentState?.isOpened == true) {
      key.currentState?.animate();
    }
  }

  void onTextFiledTap() {
    if (key.currentState?.isOpened == true) {
      key.currentState?.animate();
    }
  }

  onJoinMeeting(AppointmentChat data) {
    if (data.videoCall?.isStarted == true) {
      DateTime date1 = DateTime.fromMillisecondsSinceEpoch(
          int.parse(data.videoCall?.time ?? ''));
      DateTime now = DateTime.now();
      DateTime date2 =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      if (date1.isBefore(date2)) {
        VideoCall? call = data.videoCall;
        if (data.videoCall?.token == null || data.videoCall!.token!.isEmpty) {
          ApiService.instance
              .getAgoraToken(channelName: data.videoCall?.channelId ?? '')
              .then((t) {
            if (t.status == true) {
              call?.token = t.token;
              collection?.doc(data.id).update(
                  {FirebaseRes.videoCall: call?.toJson()}).then((value) {
                Get.to(() => VideoCallScreen(
                      appointmentChat: data,
                    ))?.then((value) {
                  endVideoStatusUpdate(value: value, data: data, call: call);
                });
              });
            } else {
              CustomUi.infoSnackBar(t.message ?? '');
            }
          });
        } else {
          Get.to(() => VideoCallScreen(appointmentChat: data))?.then((value) {
            endVideoStatusUpdate(value: value, data: data, call: call);
          });
        }
      } else {
        CustomUi.snackBar(
          message: S.current.pleaseWaitYourMeetingEtc,
          iconData: Icons.meeting_room_rounded,
        );
      }
    } else {
      CustomUi.snackBar(
        message: S.current.meetingEnd,
        iconData: Icons.no_meeting_room_rounded,
      );
    }
  }

  endVideoStatusUpdate(
      {VideoCall? call, required bool value, required AppointmentChat data}) {
    if (value == false) {
      call?.token = '';
      collection?.doc(data.id).update({FirebaseRes.videoCall: call?.toJson()});
    }
  }

  @override
  void onClose() {
    appointmentId = '';
    chatCollectionStream?.cancel();
    msgController.dispose();
    sendMediaController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
