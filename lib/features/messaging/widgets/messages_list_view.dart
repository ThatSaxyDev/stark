import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stark/core/enums/enums.dart';
import 'package:stark/core/providers/message_reply_provider.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/messaging/controllers/messaging_controller.dart';
import 'package:stark/features/messaging/widgets/my_message_card.dart';
import 'package:stark/features/messaging/widgets/sender_message_card.dart';
import 'package:stark/models/message_model.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';

class MessagesListView extends ConsumerStatefulWidget {
  const MessagesListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MessagesListViewState();
}

class _MessagesListViewState extends ConsumerState<MessagesListView> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final messagesStream = ref.watch(getGroupChatStreamProvider);
    return messagesStream.when(
      data: (messages) {
        if (messages.isEmpty) {
          return Center(
            child: Text(
              'No messages',
              style: TextStyle(
                color: Pallete.blackTint,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   messageController.jumpTo(messageController.position.maxScrollExtent);
        // });

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: messageController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            MessageModel message = messages[index];
            var timeSent = DateFormat.Hm().format(message.timeSent);

            if (message.senderId == user.uid) {
              return MyMessageCard(
                message: message.text,
                date: timeSent,
                type: message.type,
                onLeftSwipe: () => onMessageSwipe(
                  message.text,
                  true,
                  message.type,
                ),
                repliedText: message.repliedMessage,
                username: message.repliedTo,
                repliedMessageType: message.repliedMessageType,
              );
            }

            return SenderMessageCard(
              message: message.text,
              date: timeSent,
              type: message.type,
              onRightSwipe: () => onMessageSwipe(
                message.text,
                false,
                message.type,
              ),
              repliedText: message.repliedMessage,
              username: message.senderId,
              repliedMessageType: message.repliedMessageType,
            );
          },
        );
      },
      error: (error, stactrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
