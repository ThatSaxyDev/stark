// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AttendanceRecordModel {
  final DateTime day;
  final String organisationName;
  final List<dynamic> early;
  final List<dynamic> late;
  final List<dynamic> present;
  final List<dynamic> absent;
  const AttendanceRecordModel({
    required this.day,
    required this.organisationName,
    required this.early,
    required this.late,
    required this.present,
    required this.absent,
  });

  AttendanceRecordModel copyWith({
    DateTime? day,
    String? organisationName,
    List<dynamic>? early,
    List<dynamic>? late,
    List<dynamic>? present,
    List<dynamic>? absent,
  }) {
    return AttendanceRecordModel(
      day: day ?? this.day,
      organisationName: organisationName ?? this.organisationName,
      early: early ?? this.early,
      late: late ?? this.late,
      present: present ?? this.present,
      absent: absent ?? this.absent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day': day.millisecondsSinceEpoch,
      'organisationName': organisationName,
      'early': early,
      'late': late,
      'present': present,
      'absent': absent,
    };
  }

  factory AttendanceRecordModel.fromMap(Map<String, dynamic> map) {
    return AttendanceRecordModel(
      day: DateTime.fromMillisecondsSinceEpoch((map["day"]??0) as int),
      organisationName: (map["organisationName"] ?? '') as String,
      early: List<dynamic>.from(((map['early'] ?? const <dynamic>[]) as List<dynamic>),),
      late: List<dynamic>.from(((map['late'] ?? const <dynamic>[]) as List<dynamic>),),
      present: List<dynamic>.from(((map['present'] ?? const <dynamic>[]) as List<dynamic>),),
      absent: List<dynamic>.from(((map['absent'] ?? const <dynamic>[]) as List<dynamic>),),
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceRecordModel.fromJson(String source) => AttendanceRecordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceRecordModel(day: $day, organisationName: $organisationName, early: $early, late: $late, present: $present, absent: $absent)';
  }

  @override
  bool operator ==(covariant AttendanceRecordModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.day == day &&
      other.organisationName == organisationName &&
      listEquals(other.early, early) &&
      listEquals(other.late, late) &&
      listEquals(other.present, present) &&
      listEquals(other.absent, absent);
  }

  @override
  int get hashCode {
    return day.hashCode ^
      organisationName.hashCode ^
      early.hashCode ^
      late.hashCode ^
      present.hashCode ^
      absent.hashCode;
  }
}
