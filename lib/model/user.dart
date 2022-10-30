import 'package:frontend_flutter/model/listable_model.dart';

class User implements ListableModel {
  final String? uuid;
  final String? firstName;
  final String? lastName;
  final String? mail;
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final String? city;
  final List<UserRole>? roles;

  const User({
    this.uuid,
    this.firstName,
    this.lastName,
    this.mail,
    this.street,
    this.houseNumber,
    this.postalCode,
    this.city,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic>? jsonRoles = json['roles'];
    final List<UserRole>? roles = jsonRoles?.map((e) => UserRole.fromJson(e)).toList();
    return User(
      uuid: json['uuid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mail: json['mail'],
      street: json['street'],
      houseNumber: json['houseNumber'],
      postalCode: json['postalCode'],
      city: json['city'],
      roles: roles,
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'street': street,
    'houseNumber': houseNumber,
    'postalCode': postalCode,
    'city': city,
  };

  @override
  String title() {
    return '$lastName, $firstName';
  }
}

enum UserRole {
  user,
  admin;

  factory UserRole.fromJson(dynamic value) {
    final stringValue = value.toString();
    try {
      return UserRole.values.firstWhere((element) => element.name == stringValue.toLowerCase());
    } catch (_) {
      // default role is user
      return UserRole.user;
    }
  }
}