import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/home/home.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class CategoryCard extends StatelessWidget {
  final Categories? categories;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    this.categories,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ColorRes.silver.withOpacity(0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              CachedNetworkImage(
                imageUrl: '${ConstRes.itemBaseURL}${categories?.image ?? ' '}',
                width: 40,
                height: 40,
                color: ColorRes.havelockBlue,
                errorWidget: (context, url, error) {
                  return Container();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                (categories?.title ?? S.current.unKnown).toUpperCase(),
                style: MyTextStyle.montserratSemiBold(
                    size: 12, color: ColorRes.havelockBlue),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
