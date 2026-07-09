import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/listable_model.dart';
import 'package:frontend_flutter/util/json_util.dart';

class Item implements ListableModel {
  final String? uuid;
  final String? name;
  final List<ItemCategory>? itemCategories;
  final String? street;
  final String? houseNumber;
  final String? postalCode;
  final String? city;
  final bool? isActive;
  final String? communityUuid;
  final String? userUuid;
  final String? availability;
  final DateTime? availableUntil;
  final String? description;
  final bool isOwner;
  final bool requiresApproval;
  Uint8List? imageData;

  Item({
    this.uuid,
    this.name,
    this.itemCategories,
    this.street,
    this.houseNumber,
    this.postalCode,
    this.city,
    this.isActive,
    this.communityUuid,
    this.userUuid,
    this.availability,
    this.availableUntil,
    this.description,
    this.isOwner = false,
    this.requiresApproval = false,
    this.imageData,
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
      isActive: json['active'],
      communityUuid: json['communityUuid'],
      userUuid: json['userUuid'],
      availability: json['availability'],
      availableUntil: JsonUtil.parseDateString(json['availableUntil']),
      description: json['description'],
      isOwner: json['owner'] ?? false,
      requiresApproval: json['requiresApproval'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'categories': itemCategories?.map((e) => e.apiName).toList(),
    'street': street,
    'houseNumber': houseNumber,
    'postalCode': postalCode,
    'city': city,
    'isActive': isActive,
    'communityUuid': communityUuid,
    'availability': availability,
    'availableUntil': JsonUtil.parseDateTime(availableUntil),
    'description': description,
    'requiresApproval': requiresApproval,
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
  electricDevice,
  other;

  String get apiName {
    final buffer = StringBuffer();
    for (var i = 0; i < name.length; i++) {
      final char = name[i];
      if (char != char.toLowerCase()) {
        buffer.write('_');
      }
      buffer.write(char.toUpperCase());
    }
    return buffer.toString();
  }

  factory ItemCategory.fromJson(dynamic value) {
    final stringValue = value.toString().toLowerCase().replaceAll('_', '');
    try {
      return ItemCategory.values.firstWhere(
          (element) => element.name.toLowerCase() == stringValue);
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
      case ItemCategory.electricDevice:
        return AppLocalizations.of(context)!.itemCategory_electricDevice;
      case ItemCategory.other:
        return AppLocalizations.of(context)!.itemCategory_other;
    }
  }
}