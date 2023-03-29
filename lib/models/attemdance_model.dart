import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttendanceModel {
  final String employeeId;
  final DateTime? timeIn;
  final String status;
  final String organisationName;
  const AttendanceModel({
    required this.employeeId,
    required this.timeIn,
    required this.status,
    required this.organisationName,
  });

  AttendanceModel copyWith({
    String? employeeId,
    DateTime? timeIn,
    String? status,
    String? organisationName,
  }) {
    return AttendanceModel(
      employeeId: employeeId ?? this.employeeId,
      timeIn: timeIn ?? this.timeIn,
      status: status ?? this.status,
      organisationName: organisationName ?? this.organisationName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employeeId': employeeId,
      'timeIn': timeIn?.millisecondsSinceEpoch,
      'status': status,
      'organisationName': organisationName,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      employeeId: (map["employeeId"] ?? '') as String,
      timeIn: map['timeIn'] != null ? DateTime.fromMillisecondsSinceEpoch((map["timeIn"]??0) ?? 0 as int) : null,
      status: (map["status"] ?? '') as String,
      organisationName: (map["organisationName"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) => AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceModel(employeeId: $employeeId, timeIn: $timeIn, status: $status, organisationName: $organisationName)';
  }

  @override
  bool operator ==(covariant AttendanceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.employeeId == employeeId &&
      other.timeIn == timeIn &&
      other.status == status &&
      other.organisationName == organisationName;
  }

  @override
  int get hashCode {
    return employeeId.hashCode ^
      timeIn.hashCode ^
      status.hashCode ^
      organisationName.hashCode;
  }
}
