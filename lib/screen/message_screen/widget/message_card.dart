import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/common/common_fun.dart';
import 'package:patient_flutter/common/custom_ui.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/chat/chat.dart';
import 'package:patient_flutter/model/user/registration.dart';
import 'package:patient_flutter/screen/message_chat_screen/message_chat_screen.dart';
import 'package:patient_flutter/utils/color_res.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/font_res.dart';
import 'package:patient_flutter/utils/my_text_style.dart';

class MessageCard extends StatelessWidget {
  final Conversation? conversation;
  final RegistrationData? userData;
  final Function(Conversation? user) onLongPress;

  const MessageCard(
      {Key? key,
      required this.conversation,
      this.userData,
      required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const MessageChatScreen(),
            arguments: [conversation, userData]);
      },
      onLongPress: () => onLongPress(conversation),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: const BoxDecoration(
          color: ColorRes.whiteSmoke,
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: '${ConstRes.itemBaseURL}${conversation?.user?.image}',
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return CustomUi.doctorPlaceHolder(
                      height: 70,
                      gender:
                          conversation?.user?.gender == S.current.male ? 1 : 0);
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
                    conversation?.user?.username ?? S.current.unKnown,
                    style: MyTextStyle.montserratExtraBold(
                        size: 16, color: ColorRes.charcoalGrey),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    conversation?.lastMsg ?? '',
                    style: MyTextStyle.montserratLight(
                        size: 14, color: ColorRes.charcoalGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  CommonFun.timeAgo(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(conversation?.time ?? ''))),
                  style: MyTextStyle.montserratMedium(
                      size: 12, color: ColorRes.silverChalice),
                ),
                const SizedBox(
                  height: 5,
                ),
                conversation?.user?.msgCount == 0
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                      )
                    : Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: MyTextStyle.linearTopGradient),
                        alignment: Alignment.center,
                        child: Text(
                          conversation?.user?.msgCount?.toString() ?? '0',
                          style: const TextStyle(
                              fontFamily: FontRes.bold,
                              fontSize: 12,
                              color: ColorRes.white),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
