import 'package:flutter/material.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/doctor_profile_screen/doctor_profile_screen_controller.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/font_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class ServiceLocation extends StatelessWidget {
  final DoctorProfileScreenController controller;

  const ServiceLocation({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.snowDrift,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              S.current.servicesLocation,
              style: MyTextStyle.montserratSemiBold(
                      size: 14, color: ColorRes.charcoalGrey)
                  .copyWith(letterSpacing: 1),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _serviceLocationCard(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _serviceLocationCard() {
    if (controller.doctorData?.serviceLocations == null ||
        controller.doctorData!.serviceLocations!.isEmpty) {
      return CustomUi.noData(title: S.current.noServiceLocation);
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.doctorData?.serviceLocations?.length ?? 0,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) => Container(
          color: index % 2 == 0 ? ColorRes.whiteSmoke : ColorRes.snowDrift,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.doctorData?.serviceLocations?[index].hospitalTitle ??
                    '',
                style: const TextStyle(
                    fontSize: 15,
                    fontFamily: FontRes.bold,
                    color: ColorRes.davyGrey,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                controller
                        .doctorData?.serviceLocations?[index].hospitalAddress ??
                    '',
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorRes.davyGrey,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      );
    }
  }
}
