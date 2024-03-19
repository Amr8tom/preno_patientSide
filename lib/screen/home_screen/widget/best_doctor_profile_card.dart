import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class BestDoctorProfileCard extends StatelessWidget {
  final Doctor? doctor;
  final Function(Doctor? doctor) onDoctorCardTap;

  const BestDoctorProfileCard(
      {Key? key, this.doctor, required this.onDoctorCardTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onDoctorCardTap(doctor);
      },
      child: AspectRatio(
        aspectRatio: 0.84,
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: '${ConstRes.itemBaseURL}${doctor?.image}',
                        fit: BoxFit.cover,
                        height: Get.width / 2.6,
                        width: double.infinity,
                        errorWidget: (context, url, error) {
                          return CustomUi.doctorPlaceHolder(
                              gender: doctor?.gender, height: Get.width / 2.6);
                        },
                      ),
                    ),
                    Visibility(
                      visible: doctor?.rating == null || doctor?.rating == 0.0
                          ? false
                          : true,
                      child: FittedBox(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Text(
                                  doctor?.rating
                                          ?.toStringAsFixed(1)
                                          .toString()
                                          .replaceAll('0.0', '0') ??
                                      '',
                                  style: MyTextStyle.montserratRegular(
                                      size: 14, color: ColorRes.pastelOrange),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                const Icon(
                                  Icons.star_rounded,
                                  color: ColorRes.pastelOrange,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  doctor?.name ?? S.current.unKnown,
                  style: MyTextStyle.montserratBold(
                    size: 13,
                    color: ColorRes.charcoalGrey,
                  ).copyWith(overflow: TextOverflow.ellipsis),
                ),
                const Spacer(),
                Text(
                  '${S.current.exp}: ${doctor?.experienceYear ?? 0} ${S.current.years}',
                  style: MyTextStyle.montserratLight(
                    size: 11,
                    color: ColorRes.charcoalGrey,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
