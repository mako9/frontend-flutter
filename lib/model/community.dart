import 'package:frontend_flutter/model/listable_model.dart';

class Community implements ListableModel {
  final String? uuid;
  final String? name;
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final String? city;
  final int? radius;
  final double? latitude;
  final double? longitude;
  final bool? isAdmin;
  final String? adminUuid;
  final String? adminFirstName;
  final String? adminLastName;

  const Community({
    this.uuid,
    this.name,
    this.street,
    this.houseNumber,
    this.postalCode,
    this.city,
    this.radius,
    this.latitude,
    this.longitude,
    this.isAdmin,
    this.adminUuid,
    this.adminFirstName,
    this.adminLastName,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      uuid: json['uuid'],
      name: json['name'],
      street: json['street'],
      houseNumber: json['houseNumber'],
      postalCode: json['postalCode'],
      city: json['city'],
      radius: json['radius'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isAdmin: json['admin'],
      adminUuid: json['adminUuid'],
      adminFirstName: json['adminFirstName'],
      adminLastName: json['adminLastName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'street': street,
    'houseNumber': houseNumber,
    'postalCode': postalCode,
    'city': city,
    'radius': radius,
    'latitude': latitude,
    'longitude': longitude,
  };

  @override
  String title() {
    return name ?? 'Unknown';
  }
}