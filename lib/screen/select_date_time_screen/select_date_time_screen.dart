import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/common/top_bar_area.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/screen/select_date_time_screen/select_date_time_screen_controller.dart';
import 'package:patient_flutter/screen/select_date_time_screen/widget/date_builder.dart';
import 'package:patient_flutter/screen/select_date_time_screen/widget/doctor_profile_card.dart';
import 'package:patient_flutter/screen/select_date_time_screen/widget/select_month_dialog.dart';
import 'package:patient_flutter/services/pref_service.dart';
import 'package:patient_flutter/utils/asset_res.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';
import 'package:patient_flutter/utils/update_res.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDateTimeScreen extends StatelessWidget {
  final int addAppointment;

  const SelectDateTimeScreen({Key? key, required this.addAppointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectDateTimeScreenController());
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        children: [
          TopBarArea(title: S.current.selectDateAndTime),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorProfileCard(
                  doctor: controller.doctorData,
                ),
                _topBarTitle(
                    title: S.current.selectDate,
                    isDateVisible: true,
                    topPadding: 0,
                    controller: controller),
                GetBuilder(
                  init: controller,
                  id: kSelectDate,
                  builder: (controller) {
                    return TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.utc(
                          controller.year,
                          controller.month,
                          DateTimeRange(
                                  start: DateTime(
                                      controller.year, controller.month),
                                  end: DateTime(
                                      controller.year, controller.month + 1))
                              .duration
                              .inDays),
                      focusedDay: DateTime.utc(
                          controller.year, controller.month, controller.day),
                      currentDay: DateTime.utc(
                          controller.year, controller.month, controller.day),
                      pageJumpingEnabled: true,
                      pageAnimationCurve: Curves.linearToEaseOut,
                      pageAnimationEnabled: true,
                      pageAnimationDuration: const Duration(seconds: 1),
                      calendarFormat: CalendarFormat.week,
                      headerVisible: false,
                      shouldFillViewport: false,
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          return DateBuilder(
                            controller: controller,
                            day: day,
                            onTap: () {
                              controller.onSelectedDateClick(day);
                            },
                          );
                        },
                        todayBuilder: (context, day, focusedDay) {
                          return DateBuilder(
                            controller: controller,
                            day: day,
                            containerColor: ColorRes.havelockBlue,
                            elevation: 3,
                            onTap: () {},
                          );
                        },
                        disabledBuilder: (context, day, focusedDay) {
                          return DateBuilder(
                              controller: controller,
                              day: day,
                              onTap: () {
                                if (day.compareTo(controller.selectedDay) > 0) {
                                  controller.onSelectedDateClick(day);
                                } else {}
                              },
                              containerColor: ColorRes.whiteSmoke);
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return DateBuilder(
                              controller: controller,
                              day: day,
                              onTap: () {
                                if (day.compareTo(controller.selectedDay) > 0) {
                                  controller.onSelectedDateClick(day);
                                } else {}
                              },
                              containerColor: ColorRes.whiteSmoke);
                        },
                        outsideBuilder: (context, day, focusedDay) {
                          return DateBuilder(
                              controller: controller,
                              day: day,
                              onTap: () {
                                if (day.compareTo(controller.selectedDay) >=
                                    0) {
                                  controller.onSelectedDateClick(day);
                                } else {
                                  controller.onSelectedDateClick(day);
                                }
                              },
                              containerColor: ColorRes.whiteSmoke);
                        },
                        rangeEndBuilder: (context, day, focusedDay) {
                          return DateBuilder(
                              controller: controller,
                              day: day,
                              onTap: () {
                                if (day.compareTo(controller.selectedDay) > 0) {
                                  controller.onSelectedDateClick(day);
                                } else {}
                              },
                              containerColor: ColorRes.whiteSmoke);
                        },
                      ),
                      daysOfWeekVisible: false,
                    );
                  },
                ),
                _topBarTitle(
                  controller: controller,
                  title: S.current.selectTime,
                ),
                GetBuilder(
                  init: controller,
                  id: kSelectTime,
                  builder: (controller) {
                    return SizedBox(
                      height: 75,
                      // color: Colors.red.withOpacity(0.2),
                      child: controller.slotTime == null ||
                              controller.slotTime!.isEmpty
                          ? Center(
                              child: Text(
                                S.current.noSlotAvailable,
                                style: MyTextStyle.montserratBold(
                                    color: ColorRes.grey, size: 12),
                              ),
                            )
                          : controller.isLoadAppointment
                              ? CustomUi.loaderWidget()
                              : ListView.builder(
                                  itemCount: controller.slotTime?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    Slots? slots = controller.slotTime?[index];

                                    var bookedSlots = controller
                                        .acceptPendingData
                                        .where((element) =>
                                            element.time == slots?.time)
                                        .toList();

                                    var bookedSlotCount = bookedSlots.length;
                                    var availableSlot =
                                        (slots?.bookingLimit ?? 0) -
                                            bookedSlotCount;
                                    return InkWell(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        if (bookedSlots.indexWhere((element) =>
                                                element.userId ==
                                                PrefService.userId) ==
                                            -1) {
                                          (availableSlot) <= 0
                                              ? CustomUi.snackBar(
                                                  iconData: Icons
                                                      .calendar_month_rounded,
                                                  message: S
                                                      .of(context)
                                                      .slotNotAvailable)
                                              : controller.onTimeTap(
                                                  controller.slotTime?[index],
                                                  index);
                                        } else {
                                          (availableSlot) <= 0
                                              ? () {}
                                              : CustomUi.snackBar(
                                                  iconData: Icons
                                                      .calendar_month_rounded,
                                                  message: S
                                                      .of(context)
                                                      .youHaveAlreadyBookedThisSlot);
                                        }
                                      },
                                      child: Card(
                                        elevation:
                                            controller.selectedSlot == slots
                                                ? 0
                                                : 0,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color:
                                                    controller.selectedSlot ==
                                                            slots
                                                        ? ColorRes.havelockBlue
                                                        : ColorRes.softPeach,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                // CustomUi
                                                //     .convert24HoursInto12Hours(
                                                //         slots?.time),
                                                CustomUi.startAndEndTimeWork(
                                                    slots?.time,
                                                    slots?.endTime),
                                                style: MyTextStyle.montserratSemiBold(
                                                    color: (availableSlot) <= 0
                                                        ? ColorRes.nobel
                                                        : (controller
                                                                    .selectedSlot ==
                                                                slots
                                                            ? ColorRes.white
                                                            : ColorRes
                                                                .charcoalGrey),
                                                    size: 16),
                                              ),
                                            ),
                                            // const SizedBox(
                                            //   height: 3,
                                            // ),
                                            // Text(
                                            //   availableSlot <= 0
                                            //       ? S.of(context).notAvailable
                                            //       : '$availableSlot ${S.of(context).slotsAvailable}',
                                            //   style: TextStyle(
                                            //       color: (availableSlot) <= 0
                                            //           ? ColorRes.nobel
                                            //           : ColorRes.mediumGreen,
                                            //       fontFamily: FontRes.medium,
                                            //       fontSize: 12),
                                            // )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    );
                  },
                ),
                _topBarTitle(
                  controller: controller,
                  title: S.current.appointmentType,
                ),
                GetBuilder(
                  init: controller,
                  id: kAppointmentType,
                  builder: (controller) {
                    return Row(
                      children: [
                        _appointmentTypeCard(
                            controller: controller,
                            index: 0,
                            title: S.current.atHome,
                            isVisible:
                                controller.doctorData?.onlineConsultation == 1
                                    ? true
                                    : false),
                        _appointmentTypeCard(
                            controller: controller,
                            index: 1,
                            title: S.current.clinic,
                            isVisible:
                                controller.doctorData?.clinicConsultation == 1
                                    ? true
                                    : false)
                      ],
                    );
                  },
                ),
                _topBarTitle(title: S.current.patient, controller: controller),
                GetBuilder(
                  init: controller,
                  builder: (controller) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      alignment: addAppointment == 1
                          ? Alignment.centerLeft
                          : Alignment.center,
                      decoration:
                          const BoxDecoration(color: ColorRes.whiteSmoke),
                      child: addAppointment == 1
                          ? Text(
                              controller.selectedPatient?.fullname ?? '',
                              style: MyTextStyle.montserratMedium(
                                  size: 15, color: ColorRes.battleshipGrey),
                            )
                          : DropdownButton<Patient>(
                              isDense: true,
                              value: controller.selectedPatient,
                              isExpanded: true,
                              alignment: Alignment.centerLeft,
                              onChanged: (value) {
                                addAppointment == 0
                                    ? controller.onPatientChange(value)
                                    : () {};
                              },
                              iconSize: 30,
                              hint: Text(
                                mySelf,
                                style: MyTextStyle.montserratMedium(
                                    size: 15, color: ColorRes.battleshipGrey),
                              ),
                              items: controller.patientList
                                  .map<DropdownMenuItem<Patient>>((Patient?
                                          value) =>
                                      DropdownMenuItem<Patient>(
                                        value: value,
                                        child: Text(
                                          value?.fullname ?? '',
                                          style: MyTextStyle.montserratMedium(
                                              size: 15,
                                              color: ColorRes.battleshipGrey),
                                        ),
                                      ))
                                  .toList(),
                              underline: const SizedBox(),
                            ),
                    );
                  },
                ),
                _topBarTitle(
                    title: S.current.explainYourProblemBriefly,
                    controller: controller),
                GetBuilder(
                  init: controller,
                  builder: (context) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: ColorRes.whiteSmoke,
                      child: addAppointment == 1
                          ? Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                controller.problemController.text,
                                style: MyTextStyle.montserratMedium(
                                  size: 15,
                                  color: ColorRes.battleshipGrey,
                                ),
                              ),
                            )
                          : TextField(
                              controller: controller.problemController,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(15),
                                hintText: S.current.enterHere,
                                hintStyle: MyTextStyle.montserratMedium(
                                  size: 15,
                                  color: ColorRes.grey.withOpacity(0.7),
                                ),
                              ),
                              cursorColor: ColorRes.battleshipGrey,
                              cursorHeight: 15,
                              style: MyTextStyle.montserratMedium(
                                size: 15,
                                color: ColorRes.battleshipGrey,
                              ),
                            ),
                    );
                  },
                ),
                Visibility(
                  visible: addAppointment == 1 &&
                      controller.appointmentData?.documents?.length.toInt() !=
                          0,
                  child: _topBarTitle(
                      title: S.current.attachPhoto, controller: controller),
                ),
                SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      Visibility(
                        visible: addAppointment == 0,
                        child: InkWell(
                          onTap: controller.onAttachDocument,
                          child: Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: ColorRes.whiteSmoke,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              AssetRes.messageAddBox,
                              color: ColorRes.darkJungleGreen,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: GetBuilder(
                            id: kAttachDocument,
                            init: controller,
                            builder: (context) {
                              return addAppointment == 1
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.appointmentData
                                              ?.documents?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '${ConstRes.itemBaseURL}${controller.appointmentData?.documents?[index].image}',
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                              errorWidget:
                                                  (context, url, error) {
                                                return Container();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : controller.imageFileList == null ||
                                          controller.imageFileList!.isEmpty
                                      ? const SizedBox()
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller
                                                  .imageFileList?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () => controller
                                                  .onImageDelete(controller
                                                      .imageFileList?[index]),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 2),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.file(
                                                        controller.imageFileList?[
                                                                index] ??
                                                            File(''),
                                                        fit: BoxFit.cover,
                                                        width: 100,
                                                        height: 100,
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.delete_rounded,
                                                    color: ColorRes.whiteSmoke,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
          InkWell(
            onTap: addAppointment == 1
                ? controller.onRescheduleTap
                : controller.onMakePaymentClick,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                gradient: MyTextStyle.linearTopGradient,
              ),
              alignment: Alignment.center,
              child: SafeArea(
                top: false,
                child: Text(
                  addAppointment == 0
                      ? S.current.makePayment
                      : S.current.reschedule,
                  style: MyTextStyle.montserratSemiBold(
                      size: 17, color: ColorRes.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _topBarTitle(
      {required String title,
      bool isDateVisible = false,
      double topPadding = 10,
      double bottomPadding = 10,
      required SelectDateTimeScreenController controller}) {
    return Container(
      padding: EdgeInsets.only(
          left: 15, right: 15, top: topPadding, bottom: bottomPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: MyTextStyle.montserratRegular(
                size: 15,
                color: ColorRes.battleshipGrey,
              ),
            ),
          ),
          Visibility(
            visible: isDateVisible,
            child: GetBuilder(
              id: kSelectDate,
              init: controller,
              builder: (controller) {
                return InkWell(
                  onTap: () {
                    Get.dialog(
                      SelectMonthDialog(
                        onDoneClick: controller.onDoneClick,
                        month: controller.month,
                        year: controller.year,
                      ),
                    );
                  },
                  child: Text(
                    '${DateFormat(mmmm).format(DateTime(controller.year, controller.month))} ${controller.year}',
                    style: MyTextStyle.montserratSemiBold(
                      size: 15,
                      color: ColorRes.charcoalGrey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentTypeCard(
      {required SelectDateTimeScreenController controller,
      required int index,
      required String title,
      required bool isVisible}) {
    return Visibility(
      visible: isVisible,
      child: InkWell(
        onTap: () {
          addAppointment == 0 ? controller.onAppointmentTypeTap(index) : () {};
        },
        child: Card(
          elevation: controller.selectedAppointmentType == index ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: controller.selectedAppointmentType == index
                  ? ColorRes.havelockBlue
                  : ColorRes.softPeach,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              title,
              style: MyTextStyle.montserratSemiBold(
                  color: controller.selectedAppointmentType == index
                      ? ColorRes.white
                      : ColorRes.charcoalGrey,
                  size: 16),
            ),
          ),
        ),
      ),
    );
  }
}
