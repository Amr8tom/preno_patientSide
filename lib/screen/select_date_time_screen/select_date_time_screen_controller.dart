import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/appointment/fetch_accept_pending_appointments.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/model/custom/categories.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/screen/confirm_booking_screen/confirm_booking_screen.dart';
import 'package:patient_flutter/screen/select_date_time_screen/select_spacific_date_time_screen.dart';
import 'package:patient_flutter/services/api_service.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:patient_flutter/utils/update_res.dart';

class SelectDateTimeScreenController extends GetxController {
  int year = DateTime
      .now()
      .year;
  int month = DateTime
      .now()
      .month;
  int day = DateTime
      .now()
      .day;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController problemController = TextEditingController();
  int? selectedAppointmentType;
  Doctor? doctorData;
  List<Patient?> patientList = [
    Patient(fullname: mySelf),
  ];
  Patient? selectedPatient;
  List<Slots>? slotTime = [];
  Slots? selectedSlot;
  int slotIndx = 0;
  String? selectedSpasificSlotTime;
  String? selectedStartSlotTime;
  List<File>? imageFileList = [];
  List<Documents>? documentList = [];
  PrefService prefService = PrefService();

  bool isLoadAppointment = false;
  List<FetchAcceptPendingAppointmentData> acceptPendingData = [];
  List<Patient>? patientData = [];
  AppointmentData? appointmentData;

  @override
  void onInit() {
    doctorData = Get.arguments[0];
    appointmentData = Get.arguments[1];
    fetchDoctorProfile();
    fetchPatientApiCall();

    super.onInit();
  }

  void onDoneClick(int month, int year) {
    this.year = year;
    this.month = month;
    if (DateTime
        .now()
        .month == month) {
      day = DateTime
          .now()
          .day;
    }
    update([kSelectDate]);
  }

  void onSelectedDateClick(DateTime dateTime) {
    selectedSlot = null;
    selectedDay = dateTime;
    initSlotList(dateTime);
    fetchAcceptedPendingAppointmentsOfDoctorByDate(
        DateFormat(yyyyMMDd).format(dateTime));
    year = dateTime.year;
    month = dateTime.month;
    day = dateTime.day;
    update([kSelectTime, kSelectDate]);
  }

  void fetchAcceptedPendingAppointmentsOfDoctorByDate(String date) async {
    isLoadAppointment = true;
    ApiService.instance
        .fetchAcceptedPendingAppointmentsOfDoctorByDate(
        doctorId: doctorData?.id ?? -1, date: date)
        .then((value) {
      isLoadAppointment = false;

      if (value.status == true) {
        print('true');
        acceptPendingData = value.data ?? [];
        update([kSelectTime]);
      } else {
        CustomUi.snackBar(
            iconData: Icons.calendar_month_rounded, message: value.message);
      }
    });
  }

  void fetchPatientApiCall() async {
    await prefService.init();
    String response = prefService.getString(key: kPatient) ?? '';
    if (response.isNotEmpty) {
      Iterable l = jsonDecode(response);
      patientData = List<Patient>.from(l.map((e) => Patient.fromJson(e)));
      patientList.addAll(patientData ?? []);
      update();
    }
  }

  void onPatientChange(Patient? onChange) {
    selectedPatient = onChange!;
    update();
  }

  // void onTimeTap(Slots? slots) {
  //   selectedSlot = slots;
  //   update([kSelectTime]);
  // }
  void onTimeTap(Slots? slots, int? index) {
    selectedSlot = slots;
    slotIndx = index!;
    selectedStartSlotTime = selectedSlot!.time;
    Get.to(SelectSpasificDateTimeScreen());
    update([kSelectTime]);
  }

  fetchSlotsTimes({@required index}) {
    String? jsonMap = selectedSlot!.slotsTimeJson;
    Map<String, dynamic> jsonBody = jsonDecode(jsonMap!);
    selectedSpasificSlotTime = jsonBody.keys.elementAt(index);
    if (jsonBody.values.elementAt(index) == true) {
      Get.back();
      CustomUi.snackBar(
          iconData: Icons.done, message: S.current.done, positive: true);
    } else {
      CustomUi.snackBar(iconData: Icons.error, message: S.current.noSpace);
    }
  }

  void back() {
    Get.back();
    update();
  }

  //   selectedSlot = slots;

  // void onStartTimeTap(Slots? slots, int? index) {
  //   slotIndx = index!;
  //   Get.to(SelectSpasificDateTimeScreen());
  //   update([kSelectTime]);
  // }

  void onAppointmentTypeTap(int index) {
    selectedAppointmentType = index;
    update([kAppointmentType]);
  }

  void initSlotList(DateTime time) {
    slotTime = [];
    if (doctorData?.holidays == null || doctorData!.holidays!.isEmpty) {
      for (int i = 0;
      i < int.parse(doctorData?.slots?.length.toString() ?? '0');
      i++) {
        if (time.weekday == doctorData?.slots?[i].weekday) {
          slotTime?.add(doctorData?.slots?[i] ?? Slots());
        }
      }
    } else {
      for (int j = 0;
      j < int.parse(doctorData?.holidays?.length.toString() ?? '0');
      j++) {
        if (DateFormat(yyyyMMDd).format(time) ==
            doctorData?.holidays?[j].date) {
          slotTime = [];
        } else {
          slotTime = [];
          for (int i = 0;
          i < int.parse(doctorData?.slots?.length.toString() ?? '0');
          i++) {
            if (time.weekday == doctorData?.slots?[i].weekday) {
              slotTime?.add(doctorData?.slots?[i] ?? Slots());
            }
          }
        }
      }
    }
    update([kSelectTime]);
  }

  void onAttachDocument() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 50,
    );
    if (images.isEmpty) return;
    if (images.isNotEmpty) {
      for (XFile image in images) {
        var i = File(image.path);
        imageFileList?.add(i);
      }
    }
    update([kAttachDocument]);
  }

  void onRescheduleTap() {
    if (selectedSlot?.time == null) {
      CustomUi.snackBar(
          message: S.current.pleaseSelectAppointmentTime,
          iconData: CupertinoIcons.time_solid);
      return;
    }
    CustomUi.loader();
    ApiService.instance
        .rescheduleAppointment(
        userId: appointmentData?.userId,
        appointmentId: appointmentData?.id,
        date: DateFormat(yyyyMMDd).format(selectedDay),
        time: selectedSlot?.time)
        .then((value) {
      if (value.status == true) {
        Get.back();
        Get.back();
        CustomUi.snackBar(
            message: value.message ?? '',
            iconData: Icons.event_repeat_rounded,
            positive: true);
      } else {
        CustomUi.snackBar(
            message: value.message ?? '', iconData: Icons.event_repeat_rounded);
      }
    });
  }

  void onMakePaymentClick() {
    if (selectedSlot?.time == null) {
      CustomUi.infoSnackBar(S.current.pleaseSelectAppointmentTime);
      return;
    } else if (selectedAppointmentType == null) {
      CustomUi.infoSnackBar(S.current.pleaseSelectAppointmentType);
      return;
    } else {
      AppointmentDetail detail = AppointmentDetail(
          date: DateFormat(yyyyMMDd, 'en').format(selectedDay),
          time: selectedSpasificSlotTime ?? selectedSlot?.time ?? '',
          startTime: selectedSlot?.time ?? '',
          problem: problemController.text ?? " empty data",
          type: selectedAppointmentType,
          patientId: selectedPatient?.id,
          documents: imageFileList,
          serviceAmount: doctorData?.consultationFee);
      Get.to(() => const ConfirmBookingScreen(),
          arguments: [detail, doctorData]);
    }
  }

  onImageDelete(File? imageFileList) {
    this.imageFileList?.remove(imageFileList);
    update([kAttachDocument]);
  }

  void fetchDoctorProfile() {
    ApiService.instance
        .fetchDoctorProfile(doctorId: doctorData?.id)
        .then((value) {
      doctorData = value.data;
      initSlotList(selectedDay);
      rescheduleAppointment();
      update();
    });
  }

  void rescheduleAppointment() {
    selectedAppointmentType = appointmentData?.type;
    selectedPatient = patientList.firstWhere((element) {
      return element?.id == appointmentData?.patientId;
    });
    problemController = TextEditingController(text: appointmentData?.problem);
    update();
    update([kAppointmentType]);
  }
}
