// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskModel {
  final String taskName;
  final String projectName;
  final String employeeId;
  final String description;
  final String organisationName;
  final String status;
  final String managerId;
  const TaskModel({
    required this.taskName,
    required this.projectName,
    required this.employeeId,
    required this.description,
    required this.organisationName,
    required this.status,
    required this.managerId,
  });

  TaskModel copyWith({
    String? taskName,
    String? projectName,
    String? employeeId,
    String? description,
    String? organisationName,
    String? status,
    String? managerId,
  }) {
    return TaskModel(
      taskName: taskName ?? this.taskName,
      projectName: projectName ?? this.projectName,
      employeeId: employeeId ?? this.employeeId,
      description: description ?? this.description,
      organisationName: organisationName ?? this.organisationName,
      status: status ?? this.status,
      managerId: managerId ?? this.managerId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskName': taskName,
      'projectName': projectName,
      'employeeId': employeeId,
      'description': description,
      'organisationName': organisationName,
      'status': status,
      'managerId': managerId,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskName: (map["taskName"] ?? '') as String,
      projectName: (map["projectName"] ?? '') as String,
      employeeId: (map["employeeId"] ?? '') as String,
      description: (map["description"] ?? '') as String,
      organisationName: (map["organisationName"] ?? '') as String,
      status: (map["status"] ?? '') as String,
      managerId: (map["managerId"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(taskName: $taskName, projectName: $projectName, employeeId: $employeeId, description: $description, organisationName: $organisationName, status: $status, managerId: $managerId)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.taskName == taskName &&
      other.projectName == projectName &&
      other.employeeId == employeeId &&
      other.description == description &&
      other.organisationName == organisationName &&
      other.status == status &&
      other.managerId == managerId;
  }

  @override
  int get hashCode {
    return taskName.hashCode ^
      projectName.hashCode ^
      employeeId.hashCode ^
      description.hashCode ^
      organisationName.hashCode ^
      status.hashCode ^
      managerId.hashCode;
  }
}
