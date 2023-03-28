// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InviteModel {
  final String organisationName;
  final String receiverId;
  final String managerId;
  final DateTime sentAt;
  final DateTime actionAt;
  final String status; 
  const InviteModel({
    required this.organisationName,
    required this.receiverId,
    required this.managerId,
    required this.sentAt,
    required this.actionAt,
    required this.status,
  });

  InviteModel copyWith({
    String? organisationName,
    String? receiverId,
    String? managerId,
    DateTime? sentAt,
    DateTime? actionAt,
    String? status,
  }) {
    return InviteModel(
      organisationName: organisationName ?? this.organisationName,
      receiverId: receiverId ?? this.receiverId,
      managerId: managerId ?? this.managerId,
      sentAt: sentAt ?? this.sentAt,
      actionAt: actionAt ?? this.actionAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'organisationName': organisationName,
      'receiverId': receiverId,
      'managerId': managerId,
      'sentAt': sentAt.millisecondsSinceEpoch,
      'actionAt': actionAt.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory InviteModel.fromMap(Map<String, dynamic> map) {
    return InviteModel(
      organisationName: (map["organisationName"] ?? '') as String,
      receiverId: (map["receiverId"] ?? '') as String,
      managerId: (map["managerId"] ?? '') as String,
      sentAt: DateTime.fromMillisecondsSinceEpoch((map["sentAt"]??0) as int),
      actionAt: DateTime.fromMillisecondsSinceEpoch((map["actionAt"]??0) as int),
      status: (map["status"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InviteModel.fromJson(String source) => InviteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InviteModel(organisationName: $organisationName, receiverId: $receiverId, managerId: $managerId, sentAt: $sentAt, actionAt: $actionAt, status: $status)';
  }

  @override
  bool operator ==(covariant InviteModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.organisationName == organisationName &&
      other.receiverId == receiverId &&
      other.managerId == managerId &&
      other.sentAt == sentAt &&
      other.actionAt == actionAt &&
      other.status == status;
  }

  @override
  int get hashCode {
    return organisationName.hashCode ^
      receiverId.hashCode ^
      managerId.hashCode ^
      sentAt.hashCode ^
      actionAt.hashCode ^
      status.hashCode;
  }
}
