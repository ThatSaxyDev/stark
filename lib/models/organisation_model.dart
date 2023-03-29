// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrganisationModel {
  final String id;
  final String name;
  final String avatar;
  final String description;
  final List<dynamic> managers;
  final List<dynamic> employees;
  final List<dynamic> prospectiveEmployees;
  const OrganisationModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.description,
    required this.managers,
    required this.employees,
    required this.prospectiveEmployees,
  });

  OrganisationModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? description,
    List<dynamic>? managers,
    List<dynamic>? employees,
    List<dynamic>? prospectiveEmployees,
  }) {
    return OrganisationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      managers: managers ?? this.managers,
      employees: employees ?? this.employees,
      prospectiveEmployees: prospectiveEmployees ?? this.prospectiveEmployees,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'description': description,
      'managers': managers,
      'employees': employees,
      'prospectiveEmployees': prospectiveEmployees,
    };
  }

  factory OrganisationModel.fromMap(Map<String, dynamic> map) {
    return OrganisationModel(
      id: (map["id"] ?? '') as String,
      name: (map["name"] ?? '') as String,
      avatar: (map["avatar"] ?? '') as String,
      description: (map["description"] ?? '') as String,
      managers: List<dynamic>.from(((map['managers'] ?? const <dynamic>[]) as List<dynamic>),),
      employees: List<dynamic>.from(((map['employees'] ?? const <dynamic>[]) as List<dynamic>),),
      prospectiveEmployees: List<dynamic>.from(((map['prospectiveEmployees'] ?? const <dynamic>[]) as List<dynamic>),),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrganisationModel.fromJson(String source) =>
      OrganisationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrganisationModel(id: $id, name: $name, avatar: $avatar, description: $description, managers: $managers, employees: $employees, prospectiveEmployees: $prospectiveEmployees)';
  }

  @override
  bool operator ==(covariant OrganisationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.description == description &&
        listEquals(other.managers, managers) &&
        listEquals(other.employees, employees) &&
        listEquals(other.prospectiveEmployees, prospectiveEmployees);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        description.hashCode ^
        managers.hashCode ^
        employees.hashCode ^
        prospectiveEmployees.hashCode;
  }
}
