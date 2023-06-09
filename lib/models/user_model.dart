// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String profilePic;
  final String email;
  final bool isAdmin;
  final String organisation;
  final String role;
  final String phone;
  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.email,
    required this.isAdmin,
    required this.organisation,
    required this.role,
    required this.phone,
  });

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? profilePic,
    String? email,
    bool? isAdmin,
    String? organisation,
    String? role,
    String? phone,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePic: profilePic ?? this.profilePic,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      organisation: organisation ?? this.organisation,
      role: role ?? this.role,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'profilePic': profilePic,
      'email': email,
      'isAdmin': isAdmin,
      'organisation': organisation,
      'role': role,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map["uid"] ?? '') as String,
      firstName: (map["firstName"] ?? '') as String,
      lastName: (map["lastName"] ?? '') as String,
      profilePic: (map["profilePic"] ?? '') as String,
      email: (map["email"] ?? '') as String,
      isAdmin: (map["isAdmin"] ?? false) as bool,
      organisation: (map["organisation"] ?? '') as String,
      role: (map["role"] ?? '') as String,
      phone: (map["phone"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, firstName: $firstName, lastName: $lastName, profilePic: $profilePic, email: $email, isAdmin: $isAdmin, organisation: $organisation, role: $role, phone: $phone)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.profilePic == profilePic &&
      other.email == email &&
      other.isAdmin == isAdmin &&
      other.organisation == organisation &&
      other.role == role &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      profilePic.hashCode ^
      email.hashCode ^
      isAdmin.hashCode ^
      organisation.hashCode ^
      role.hashCode ^
      phone.hashCode;
  }
}
