import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark/features/messaging/widgets/bottom_chat_field.dart';
import 'package:stark/features/messaging/widgets/messages_list_view.dart';
import 'package:stark/utils/app_bar.dart';

class MessagingView extends ConsumerWidget {
  const MessagingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Messages',
      ),
      body: Column(
        children: const [
          Expanded(
            child: MessagesListView(),
          ),
          BottomChatField(),
        ],
      ),
    );
  }
}
