// void _saveMessageToMessageSubcollection({
//     required String recieverUserId,
//     required String text,
//     required DateTime timeSent,
//     required String messageId,
//     required String username,
//     required MessageEnum messageType,
//     required MessageReply? messageReply,
//     required String senderUsername,
//     required String? recieverUserName,
//     required bool isGroupChat,
//   }) async {
//     final message = Message(
//       senderId: auth.currentUser!.uid,
//       recieverid: recieverUserId,
//       text: text,
//       type: messageType,
//       timeSent: timeSent,
//       messageId: messageId,
//       isSeen: false,
//       repliedMessage: messageReply == null ? '' : messageReply.message,
//       repliedTo: messageReply == null
//           ? ''
//           : messageReply.isMe
//               ? senderUsername
//               : recieverUserName ?? '',
//       repliedMessageType:
//           messageReply == null ? MessageEnum.text : messageReply.messageEnum,
//     );
//     if (isGroupChat) {
//       // groups -> group id -> chat -> message
//       await firestore
//           .collection('groups')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(messageId)
//           .set(
//             message.toMap(),c
//           );
//     } else {
//       // users -> sender id -> reciever id -> messages -> message id -> store message
//       await firestore
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('chats')
//           .doc(recieverUserId)
//           .collection('messages')
//           .doc(messageId)
//           .set(
//             message.toMap(),
//           );
//       // users -> eciever id  -> sender id -> messages -> message id -> store message
//       await firestore
//           .collection('users')
//           .doc(recieverUserId)
//           .collection('chats')
//           .doc(auth.currentUser!.uid)
//           .collection('messages')
//           .doc(messageId)
//           .set(
//             message.toMap(),
//           );
//     }
//   }