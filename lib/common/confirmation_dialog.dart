import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onPositiveBtn;
  final String title;
  final String? title2;
  final String positiveText;
  final double aspectRatio;
  final Color positiveTextColor;
  final String? negativeText;

  const ConfirmationDialog({
    Key? key,
    required this.onPositiveBtn,
    required this.title,
    required this.positiveText,
    this.aspectRatio = 1 / 0.5,
    this.positiveTextColor = ColorRes.havelockBlue,
    this.negativeText,
    this.title2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: const ColorFilter.srgbToLinearGamma(),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 50),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  S.current.doctorIo,
                  style: MyTextStyle.montserratBlack(
                      color: ColorRes.charcoalGrey, size: 24),
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                      text: title,
                      style: MyTextStyle.montserratMedium(
                          color: ColorRes.davyGrey, size: 16),
                      children: [
                        TextSpan(
                            text: '\n${title2 ?? ''}',
                            style: MyTextStyle.montserratRegular(
                                color: ColorRes.battleshipGrey, size: 13)),
                      ]),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        negativeText ?? S.current.cancel,
                        style: MyTextStyle.montserratMedium(
                            color: ColorRes.havelockBlue, size: 13),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: onPositiveBtn,
                      child: Text(
                        positiveText,
                        style: MyTextStyle.montserratMedium(
                            color: positiveTextColor, size: 13),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
