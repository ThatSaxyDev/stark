// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrgMessagingModel {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final DateTime timeSent;
  const OrgMessagingModel({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeSent,
  });

  OrgMessagingModel copyWith({
    String? senderId,
    String? name,
    String? groupId,
    String? lastMessage,
    String? groupPic,
    List<String>? membersUid,
    DateTime? timeSent,
  }) {
    return OrgMessagingModel(
      senderId: senderId ?? this.senderId,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      lastMessage: lastMessage ?? this.lastMessage,
      groupPic: groupPic ?? this.groupPic,
      membersUid: membersUid ?? this.membersUid,
      timeSent: timeSent ?? this.timeSent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory OrgMessagingModel.fromMap(Map<String, dynamic> map) {
    return OrgMessagingModel(
     senderId: map['senderId'] ?? '',
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrgMessagingModel.fromJson(String source) => OrgMessagingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrgMessagingModel(senderId: $senderId, name: $name, groupId: $groupId, lastMessage: $lastMessage, groupPic: $groupPic, membersUid: $membersUid, timeSent: $timeSent)';
  }

  @override
  bool operator ==(covariant OrgMessagingModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.senderId == senderId &&
      other.name == name &&
      other.groupId == groupId &&
      other.lastMessage == lastMessage &&
      other.groupPic == groupPic &&
      listEquals(other.membersUid, membersUid) &&
      other.timeSent == timeSent;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
      name.hashCode ^
      groupId.hashCode ^
      lastMessage.hashCode ^
      groupPic.hashCode ^
      membersUid.hashCode ^
      timeSent.hashCode;
  }
}
