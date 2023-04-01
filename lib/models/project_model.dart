// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProjectModel {
  final String organisationName;
  final String managerId;
  final String name;
  final List<dynamic> employeeIds;
  final List<dynamic> taskIds;
  final String status;
  final String type;
  final DateTime endDateTime;
  final DateTime startDateTime;
  const ProjectModel({
    required this.organisationName,
    required this.managerId,
    required this.name,
    required this.employeeIds,
    required this.taskIds,
    required this.status,
    required this.type,
    required this.endDateTime,
    required this.startDateTime,
  });

  ProjectModel copyWith({
    String? organisationName,
    String? managerId,
    String? name,
    List<dynamic>? employeeIds,
    List<dynamic>? taskIds,
    String? status,
    String? type,
    DateTime? endDateTime,
    DateTime? startDateTime,
  }) {
    return ProjectModel(
      organisationName: organisationName ?? this.organisationName,
      managerId: managerId ?? this.managerId,
      name: name ?? this.name,
      employeeIds: employeeIds ?? this.employeeIds,
      taskIds: taskIds ?? this.taskIds,
      status: status ?? this.status,
      type: type ?? this.type,
      endDateTime: endDateTime ?? this.endDateTime,
      startDateTime: startDateTime ?? this.startDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'organisationName': organisationName,
      'managerId': managerId,
      'name': name,
      'employeeIds': employeeIds,
      'taskIds': taskIds,
      'status': status,
      'type': type,
      'endDateTime': endDateTime.millisecondsSinceEpoch,
      'startDateTime': startDateTime.millisecondsSinceEpoch,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      organisationName: (map["organisationName"] ?? '') as String,
      managerId: (map["managerId"] ?? '') as String,
      name: (map["name"] ?? '') as String,
      employeeIds: List<dynamic>.from(((map['employeeIds'] ?? const <dynamic>[]) as List<dynamic>),),
      taskIds: List<dynamic>.from(((map['taskIds'] ?? const <dynamic>[]) as List<dynamic>),),
      status: (map["status"] ?? '') as String,
      type: (map["type"] ?? '') as String,
      endDateTime: DateTime.fromMillisecondsSinceEpoch((map["endDateTime"]??0) as int),
      startDateTime: DateTime.fromMillisecondsSinceEpoch((map["startDateTime"]??0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) => ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(organisationName: $organisationName, managerId: $managerId, name: $name, employeeIds: $employeeIds, taskIds: $taskIds, status: $status, type: $type, endDateTime: $endDateTime, startDateTime: $startDateTime)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.organisationName == organisationName &&
      other.managerId == managerId &&
      other.name == name &&
      listEquals(other.employeeIds, employeeIds) &&
      listEquals(other.taskIds, taskIds) &&
      other.status == status &&
      other.type == type &&
      other.endDateTime == endDateTime &&
      other.startDateTime == startDateTime;
  }

  @override
  int get hashCode {
    return organisationName.hashCode ^
      managerId.hashCode ^
      name.hashCode ^
      employeeIds.hashCode ^
      taskIds.hashCode ^
      status.hashCode ^
      type.hashCode ^
      endDateTime.hashCode ^
      startDateTime.hashCode;
  }
}
