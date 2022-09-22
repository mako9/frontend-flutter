class User {
  final String uuid;
  final String firstName;
  final String lastName;
  final String mail;
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final String? city;
  final List<UserRole> roles;

  const User({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.mail,
    required this.street,
    required this.houseNumber,
    required this.postalCode,
    required this.city,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonRoles = json['roles'];
    final List<UserRole> roles = jsonRoles.map((e) => UserRole.fromJson(e)).toList();
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