import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/screen/appointment_screen/widget/qr_code_screen.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/extention.dart';
import 'package:patient_flutter/utils/my_text_style.dart';
import 'package:patient_flutter/utils/update_res.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentData? appointmentData;

  const AppointmentCard({
    Key? key,
    this.appointmentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Doctor? doctor = appointmentData?.doctor;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.only(
            top: 5,
            left: 15,
            right: 15,
          ),
          decoration: const BoxDecoration(
            color: ColorRes.whiteSmoke,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: doctor?.image == null || doctor!.image!.isEmpty
                    ? CustomUi.userPlaceHolder(
                        gender: doctor?.gender ?? 0, height: 80)
                    : CachedNetworkImage(
                        imageUrl: '${ConstRes.itemBaseURL}${doctor.image}',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return CustomUi.userPlaceHolder(
                              gender: doctor.gender ?? 0, height: 80);
                        },
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor?.name ?? S.current.unKnown,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyTextStyle.montserratExtraBold(
                          size: 16, color: ColorRes.charcoalGrey),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      doctor?.designation ?? '',
                      style: MyTextStyle.montserratRegular(
                          size: 13, color: ColorRes.havelockBlue),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '${(appointmentData?.date ?? createdDate).dateParse(eeeMmmDdYyyy)} : ${CustomUi.convert24HoursInto12Hours(appointmentData?.time)}',
                      style: MyTextStyle.montserratMedium(
                          size: 13, color: ColorRes.battleshipGrey),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: appointmentData?.status == 0 ||
                    appointmentData?.status == 1,
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                        QrCodeSheet(appointmentId: appointmentData?.id),
                        isScrollControlled: true);
                  },
                  child: Container(
                    height: 47,
                    width: 47,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorRes.silver.withOpacity(0.20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.qr_code_2,
                      color: ColorRes.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: appointmentData?.status == 0
                ? ColorRes.havelockBlue.withOpacity(0.2)
                : appointmentData?.status == 1
                    ? ColorRes.mangoOrange.withOpacity(0.2)
                    : appointmentData?.status == 2
                        ? ColorRes.mediumGreen.withOpacity(0.2)
                        : appointmentData?.status == 3
                            ? ColorRes.charcoalGrey.withOpacity(0.2)
                            : ColorRes.lightRed.withOpacity(0.2),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          padding: const EdgeInsets.only(right: 15),
          margin: const EdgeInsets.only(
            bottom: 5,
            left: 15,
            right: 15,
          ),
          alignment: Alignment.centerRight,
          child: Text(
            appointmentData?.status == 0
                ? S.current.waitingForConfirmation
                : appointmentData?.status == 1
                    ? S.current.accepted
                    : appointmentData?.status == 2
                        ? S.current.completed
                        : appointmentData?.status == 3
                            ? S.current.declined
                            : S.current.cancelled,
            style: MyTextStyle.montserratMedium(
              color: appointmentData?.status == 0
                  ? ColorRes.havelockBlue
                  : appointmentData?.status == 1
                      ? ColorRes.mangoOrange
                      : appointmentData?.status == 2
                          ? ColorRes.mediumGreen
                          : appointmentData?.status == 3
                              ? ColorRes.charcoalGrey
                              : ColorRes.lightRed,
              size: 13,
            ),
          ),
        )
      ],
    );
  }
}
