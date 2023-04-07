import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stark/features/messaging/controllers/messaging_controller.dart';
import 'package:stark/features/messaging/widgets/bottom_chat_field.dart';
import 'package:stark/features/messaging/widgets/messages_list_view.dart';
import 'package:stark/theme/palette.dart';
import 'package:stark/utils/app_bar.dart';
import 'package:stark/utils/error_text.dart';
import 'package:stark/utils/loader.dart';

class MessagingView extends ConsumerWidget {
  const MessagingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesStream = ref.watch(getGroupChatStreamProvider);
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Messages',
      ),
      body: messagesStream.when(
        data: (data) {
          return Column(
            children: const [
              Expanded(
                child: MessagesListView(),
              ),
              BottomChatField(),
            ],
          );
        },
        error: (error, stactrace) => Center(
          child: Text(
            'No messages',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Pallete.blackish,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}
