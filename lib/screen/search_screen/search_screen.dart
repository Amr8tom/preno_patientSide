import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/common/top_bar_area.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/screen/saved_doctor_screen/widget/doctor_card.dart';
import 'package:patient_flutter/screen/search_screen/search_screen_controller.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchScreenController());
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBarArea(title: S.current.searchDoctor),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: ColorRes.whiteSmoke,
              borderRadius: BorderRadius.circular(30),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.keywordController,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(right: 15),
                      hintText: S.current.search,
                      hintStyle:
                          MyTextStyle.montserratMedium(color: ColorRes.nobel),
                    ),
                    style: MyTextStyle.montserratMedium(
                        color: ColorRes.charcoalGrey),
                    cursorColor: ColorRes.charcoalGrey,
                    onChanged: controller.onKeyWordChange,
                    cursorHeight: 16,
                  ),
                ),
                InkWell(
                  onTap: () => controller.onFilterSheetOpen(controller),
                  child: const Icon(
                    Icons.filter_list,
                    color: ColorRes.charcoalGrey,
                  ),
                )
              ],
            ),
          ),
          GetBuilder(
            init: controller,
            builder: (context) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    controller.selectedGender != null
                        ? _addFilter(
                            controller.selectedGender == 0
                                ? S.current.female
                                : controller.selectedGender == 1
                                    ? S.current.male
                                    : S.current.both,
                            controller.onRemoveGender)
                        : const SizedBox(),
                    controller.selectedSortBy != null
                        ? _addFilter(
                            controller.selectedSortBy == 0
                                ? S.current.feesLow
                                : controller.selectedSortBy == 1
                                    ? S.current.feesHigh
                                    : S.current.rating,
                            controller.onRemoveSortList)
                        : const SizedBox(),
                    controller.catId != null
                        ? _addFilter(controller.catId?.title ?? '',
                            controller.onRemoveCategory)
                        : const SizedBox(),
                  ],
                ),
              );
            },
          ),
          GetBuilder(
            init: controller,
            builder: (context) {
              return Expanded(
                child: controller.isLoading
                    ? CustomUi.loaderWidget()
                    : ListView.builder(
                        controller: controller.scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: controller.doctors.length,
                        itemBuilder: (context, index) {
                          return DoctorCard(
                            doctors: controller.doctors[index],
                            index: index,
                            isBookMarkVisible: false,
                            color: ColorRes.snowDrift,
                            onTap: () => controller
                                .onDoctorCardTap(controller.doctors[index]),
                            onBookMarkTap: (doctorId) {},
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _addFilter(String value, VoidCallback onTap) {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(left: 10, top: 2, bottom: 2),
      decoration: BoxDecoration(
          color: ColorRes.havelockBlue.withOpacity(0.10),
          borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.only(left: 10, right: 5),
      child: Row(
        children: [
          Text(
            value.toUpperCase(),
            style: MyTextStyle.montserratSemiBold(
                    color: ColorRes.havelockBlue, size: 11)
                .copyWith(letterSpacing: 0.5),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorRes.crystalBlue.withOpacity(0.20),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: ColorRes.havelockBlue,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
