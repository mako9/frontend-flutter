import 'package:flutter/cupertino.dart';
import 'package:frontend_flutter/model/listable_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Item implements ListableModel {
  final String? uuid;
  final String? name;
  final List<ItemCategory>? itemCategories;
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final String? city;
  final double? latitude;
  final double? longitude;
  final bool? isActive;
  final String? communityUuid;
  final String? userUuid;
  final String? availability;
  final String? description;

  Item({
    this.uuid,
    this.name,
    this.itemCategories,
    this.street,
    this.houseNumber,
    this.postalCode,
    this.city,
    this.latitude,
    this.longitude,
    this.isActive,
    this.communityUuid,
    this.userUuid,
    this.availability,
    this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    List<dynamic>? jsonCategories = json['categories'];
    final List<ItemCategory>? categories = jsonCategories?.map((e) => ItemCategory.fromJson(e)).toList();
    return Item(
      uuid: json['uuid'],
      name: json['name'],
      itemCategories: categories,
      street: json['street'],
      houseNumber: json['houseNumber'],
      postalCode: json['postalCode'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isActive: json['active'],
      communityUuid: json['communityUuid'],
      userUuid: json['userUuid'],
      availability: json['availability'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'itemCategories': itemCategories,
    'street': street,
    'houseNumber': houseNumber,
    'postalCode': postalCode,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
    'isActive': isActive,
    'communityUuid': communityUuid,
    'availability': availability,
    'description': description,
  };

  @override
  String title() {
    return name ?? 'Unknown';
  }

  @override
  bool isSelected = false;
}

enum ItemCategory {
  housekeeping,
  gardening,
  tool,
  electric_device,
  other;

  factory ItemCategory.fromJson(dynamic value) {
    final stringValue = value.toString();
    try {
      return ItemCategory.values.firstWhere((element) => element.name == stringValue.toLowerCase());
    } catch (_) {
      // default category is other
      return ItemCategory.other;
    }
  }

  String getName(BuildContext context) {
    switch(this) {
      case ItemCategory.housekeeping:
        return AppLocalizations.of(context)!.itemCategory_housekeeping;
      case ItemCategory.gardening:
        return AppLocalizations.of(context)!.itemCategory_gardening;
      case ItemCategory.tool:
        return AppLocalizations.of(context)!.itemCategory_tool;
      case ItemCategory.electric_device:
        return AppLocalizations.of(context)!.itemCategory_electric_device;
      case ItemCategory.other:
        return AppLocalizations.of(context)!.itemCategory_other;
    }
  }
}