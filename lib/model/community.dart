class Community {
  final String? uuid;
  final String? name;
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final String? city;
  final int? radius;

  const Community({
    this.uuid,
    this.name,
    this.street,
    this.houseNumber,
    this.postalCode,
    this.city,
    this.radius,
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
    );
  }

  Map toJson() => {
    'name': name,
    'street': street,
    'houseNumber': houseNumber,
    'postalCode': postalCode,
    'city': city,
  };
}