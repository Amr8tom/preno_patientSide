import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/screen/select_date_time_screen/select_date_time_screen_controller.dart';
import 'package:patient_flutter/utils/color_res.dart';

import '../../generated/l10n.dart';

class SelectSpasificDateTimeScreen extends StatefulWidget {
  const SelectSpasificDateTimeScreen({Key? key}) : super(key: key);

  @override
  State<SelectSpasificDateTimeScreen> createState() =>
      _SelectSpasificDateTimeScreenState();
}

class _SelectSpasificDateTimeScreenState
    extends State<SelectSpasificDateTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectDateTimeScreenController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.blueLagoon,
        title: Text("${S.current.chooseSlotTime}"),
      ),
      body: Center(
        child: GetBuilder(
          init: controller,
          builder: (controller) {
            String? jsonMap = controller.selectedSlot!.slotsTimeJson;
            Map<String, dynamic> jsonBody = jsonDecode(jsonMap!);
            return Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: controller.slotTime?.length == 0
                    ? CustomUi.loaderWidget()
                    : GridView.builder(
                        // reverse: false,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 9,
                            crossAxisSpacing: 1,
                            childAspectRatio: 1.4),
                        itemCount: jsonBody.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        clipBehavior: Clip.hardEdge,
                        itemBuilder: (context, index) {
                          String slotTime = jsonBody.keys.elementAt(index);
                          // String slotKey = jsonBody.keys.elementAt(index);
                          return InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.black, width: 2.0),
                            ),
                            highlightColor: ColorRes.selectedBlue,
                            onTap: () {
                              controller.fetchSlotsTimes(index: index);
                            },
                            splashColor: ColorRes.silverChalice,
                            child: Card(
                              elevation: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color:
                                      jsonBody.values.elementAt(index) == true
                                          ? ColorRes.darkSkyBlue
                                          : ColorRes.greyShade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),

                                child: Text(
                                    "${CustomUi.convert24HoursInto12Hours(slotTime)}"),
                                // color: Colors.black,
                              ),
                            ),
                          );
                        }),
              ),
            );
          },
        ),
      ),
    );
  }
}
