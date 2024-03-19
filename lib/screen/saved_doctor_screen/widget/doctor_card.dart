import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/doctor/fetch_doctor.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/extention.dart';
import 'package:patient_flutter/utils/my_text_style.dart';
import 'package:patient_flutter/utils/update_res.dart';

class DoctorCard extends StatelessWidget {
  final int index;
  final bool isBookMarkVisible;
  final Color color;
  final VoidCallback onTap;
  final Doctor? doctors;
  final bool? isBookMark;
  final Function(int? doctorId) onBookMarkTap;

  const DoctorCard({
    Key? key,
    required this.index,
    this.isBookMarkVisible = true,
    this.color = ColorRes.whiteSmoke,
    required this.onTap,
    this.doctors,
    required this.onBookMarkTap,
    this.isBookMark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: color,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: doctors?.image == null || doctors!.image!.isEmpty
                  ? CustomUi.userPlaceHolder(
                      gender: doctors?.gender == 0 ? 0 : 1, height: 80)
                  : CachedNetworkImage(
                      imageUrl:
                          '${ConstRes.itemBaseURL}${doctors?.image ?? ''}',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return CustomUi.doctorPlaceHolder(
                            height: 80, gender: doctors?.gender);
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          doctors?.name ?? S.current.unKnown,
                          style: MyTextStyle.montserratExtraBold(
                              size: 16, color: ColorRes.charcoalGrey),
                        ),
                      ),
                      Visibility(
                        visible:
                            doctors?.rating == null || doctors?.rating == 0.0
                                ? false
                                : true,
                        child: FittedBox(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: ColorRes.pastelOrange.withOpacity(0.1)),
                            child: Row(
                              children: [
                                Text(
                                  doctors?.rating
                                          ?.toStringAsFixed(1)
                                          .toString()
                                          .replaceAll('0.0', '0') ??
                                      '0',
                                  style: MyTextStyle.montserratMedium(
                                      size: 14, color: ColorRes.pastelOrange),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                const Icon(
                                  Icons.star_rounded,
                                  color: ColorRes.pastelOrange,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    doctors?.designation ?? '',
                    style: MyTextStyle.montserratRegular(
                        size: 13, color: ColorRes.havelockBlue),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Visibility(
                    visible: !isBookMarkVisible,
                    child: const SizedBox(
                      height: 3,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "${S.current.expShort} :",
                            style: MyTextStyle.montserratRegular(
                                size: 13, color: ColorRes.battleshipGrey),
                            children: [
                              TextSpan(
                                text:
                                    ' ${doctors?.experienceYear ?? 0} ${S.current.years}  ',
                                style: MyTextStyle.montserratSemiBold(
                                    size: 13, color: ColorRes.battleshipGrey),
                              ),
                              TextSpan(
                                text: '${S.current.fees} :',
                                style: MyTextStyle.montserratRegular(
                                    size: 13, color: ColorRes.battleshipGrey),
                              ),
                              TextSpan(
                                text:
                                    ' $dollar${(doctors?.consultationFee ?? 0).numFormat}',
                                style: MyTextStyle.montserratSemiBold(
                                    size: 13, color: ColorRes.battleshipGrey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isBookMarkVisible,
                        child: InkWell(
                          onTap: () => onBookMarkTap(doctors?.id),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: const Icon(Icons.bookmark,
                                // key: ValueKey<bool>(isBookMark!),
                                size: 20,
                                color: ColorRes.havelockBlue),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
