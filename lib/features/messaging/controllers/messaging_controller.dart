import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark/core/providers/message_reply_provider.dart';
import 'package:stark/core/providers/storage_repository_provider.dart';
import 'package:stark/features/auth/controllers/auth_controller.dart';
import 'package:stark/features/messaging/repositories/messaging_repository.dart';
import 'package:stark/features/organisation/controllers/organisation_controller.dart';
import 'package:stark/models/message_model.dart';

//! get messages stream provider
final getGroupChatStreamProvider = StreamProvider.autoDispose((ref) {
  final messagingController = ref.watch(messagingControllerProvider.notifier);
  return messagingController.getGroupChatStream();
});

//! the messaging controller provider
final messagingControllerProvider =
    StateNotifierProvider<MessagingController, bool>((ref) {
  final messagingRepository = ref.watch(messagingRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return MessagingController(
    messagingRepository: messagingRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

//! messaging state notifier
class MessagingController extends StateNotifier<bool> {
  final MessagingRepository _messagingRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  MessagingController({
    required MessagingRepository messagingRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _messagingRepository = messagingRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  //! get message streams
  Stream<List<MessageModel>> getGroupChatStream() {
    final user = _ref.read(userProvider)!;
    return _messagingRepository.getGroupChatStream(user.organisation);
  }

  //! send text message (manager)
  void sendTextMessageManager({
    required BuildContext context,
    required String text,
    required,
  }) async {
    final messageReply = _ref.read(messageReplyProvider);
    final user = _ref.read(userProvider)!;
    state = true;

    _messagingRepository.sendTextMessage(
      text: text,
      orgName: user.organisation,
      senderUserName: '${user.firstName} ${user.lastName}',
      messageReply: messageReply,
      senderProfilePic: user.profilePic,
    );

    state = false;
  }
}
