import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/appointment/fetch_appointment.dart';
import 'package:patient_flutter/screen/appointment_detail_screen/appointment_detail_screen.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class TodayAppointment extends StatelessWidget {
  final List<AppointmentData>? appointments;

  const TodayAppointment({
    Key? key,
    this.appointments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (appointments?.length ?? 0) > 0 ? true : false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              S.current.appointmentsForToday,
              style: MyTextStyle.montserratRegular(
                  size: 15, color: ColorRes.battleshipGrey),
            ),
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: appointments?.length,
            itemBuilder: (context, index) {
              AppointmentData? appointment = appointments?[index];
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const AppointmentDetailScreen(),
                            arguments: appointment?.id);
                      },
                      child: Card(
                        color: ColorRes.havelockBlue,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ConstRes.itemBaseURL}${appointment?.doctor?.image}',
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return CustomUi.doctorPlaceHolder(
                                        gender: appointment?.doctor?.gender,
                                        height: 90);
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
                                      appointment?.doctor?.name ??
                                          S.current.unKnown,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyTextStyle.montserratExtraBold(
                                          size: 16, color: ColorRes.white),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      (appointment?.doctor?.degrees ?? '')
                                          .toUpperCase(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyTextStyle.montserratRegular(
                                          size: 11, color: ColorRes.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                          color:
                                              ColorRes.white.withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text(
                                        CustomUi.convert24HoursInto12Hours(
                                                appointment?.time)
                                            .toUpperCase(),
                                        style: MyTextStyle.montserratMedium(
                                            size: 13, color: ColorRes.white),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
