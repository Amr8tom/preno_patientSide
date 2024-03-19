import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/confirmation_dialog.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/chat/chat.dart';
import 'package:patient_flutter/screen/message_chat_screen/message_chat_screen_controller.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

import 'bottom_selected_item_bar.dart';

class MessageChatTopBar extends StatelessWidget {
  final Conversation conversation;
  final MessageChatScreenController controller;

  const MessageChatTopBar(
      {Key? key, required this.conversation, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorRes.whiteSmoke,
      padding: const EdgeInsets.all(10),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: controller.timeStamp.isEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 25,
                      color: ColorRes.davyGrey,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorRes.tuftsBlue, width: 2.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${ConstRes.itemBaseURL}${conversation.user?.image}',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Container(
                            color: ColorRes.iceberg,
                          );
                        },
                      ),
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
                          conversation.user?.username ?? S.current.unKnown,
                          style: MyTextStyle.montserratExtraBold(
                            size: 17,
                            color: ColorRes.davyGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          conversation.user?.designation ?? '',
                          style: MyTextStyle.montserratMedium(
                              size: 13, color: ColorRes.havelockBlue),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: controller.timeStamp.isNotEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Visibility(
                visible: controller.timeStamp.isNotEmpty,
                child: BottomSelectedItemBar(
                  onBackTap: controller.onMsgDeleteBackTap,
                  selectedItemCount: controller.timeStamp.length,
                  onItemDelete: () {
                    Get.dialog(
                      ConfirmationDialog(
                        onPositiveBtn: controller.onChatItemDelete,
                        title: controller.timeStamp.length == 1
                            ? '${S.current.deleteMessage}?'
                            : '${S.current.delete} ${controller.timeStamp.length} ${S.current.messages}?',
                        positiveText: S.current.deleteForMe,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
