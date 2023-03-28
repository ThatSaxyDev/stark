// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrganisationModel {
  final String id;
  final String name;
  final String avatar;
  final String description;
  final List<String> managers;
  final List<String> employees;
  const OrganisationModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.description,
    required this.managers,
    required this.employees,
  });

  OrganisationModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? description,
    List<String>? managers,
    List<String>? employees,
  }) {
    return OrganisationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      managers: managers ?? this.managers,
      employees: employees ?? this.employees,
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
    };
  }

  factory OrganisationModel.fromMap(Map<String, dynamic> map) {
    return OrganisationModel(
      id: map["id"] ?? '',
      name: map["name"] ?? '',
      avatar: map["avatar"] ?? '',
      description: map["description"] ?? '',
      managers: List<String>.from(map['managers']),
      employees: List<String>.from(map['employees']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrganisationModel.fromJson(String source) =>
      OrganisationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrganisationModel(id: $id, name: $name, avatar: $avatar, description: $description, managers: $managers, employees: $employees)';
  }

  @override
  bool operator ==(covariant OrganisationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.description == description &&
        listEquals(other.managers, managers) &&
        listEquals(other.employees, employees);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        description.hashCode ^
        managers.hashCode ^
        employees.hashCode;
  }
}
