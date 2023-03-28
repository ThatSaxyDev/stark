// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String profilePic;
  final String email;
  final bool isAdmin;
  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.email,
    required this.isAdmin,
  });

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? profilePic,
    String? email,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePic: profilePic ?? this.profilePic,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, firstName: $firstName, lastName: $lastName, profilePic: $profilePic, email: $email, isAdmin: $isAdmin)';
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
      other.isAdmin == isAdmin;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      profilePic.hashCode ^
      email.hashCode ^
      isAdmin.hashCode;
  }
}
