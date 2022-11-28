import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/service/item_service.dart';

import '../../di/service_locator.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../../model/item.dart';

class ItemCubit extends Cubit<DataResponse<Map<ItemCategory, List<Item>>>> {
  final ItemService _itemService = getIt.get<ItemService>();

  ItemCubit(super.initialState) {
    loadItemsOfMyCommunities();
  }

  factory ItemCubit.ofInitialState() {
    return ItemCubit(DataResponse.empty());
  }

  Future<void> loadItemsOfMyCommunities({int pageNumber = 0}) async {
    final itemDataResponse = await _itemService.getItemsOfMyCommunities(pageNumber: pageNumber);
    final groupedItems = _getGroupedItems(itemDataResponse.data);
    emit(DataResponse(data: groupedItems, errorMessage: itemDataResponse.errorMessage));
  }

  Future<void> loadMyItems({int pageNumber = 0}) async {
    final itemDataResponse = await _itemService.getMyItems(pageNumber: pageNumber);
    final groupedItems = _getGroupedItems(itemDataResponse.data);
    emit(DataResponse(data: groupedItems, errorMessage: itemDataResponse.errorMessage));
  }

  Map<ItemCategory, List<Item>>? _getGroupedItems(DataPage<Item>? page) {
    if (page == null || page.content.isEmpty) return null;
    Map<ItemCategory, List<Item>> map = {};
    for (var element in ItemCategory.values) {
      map[element] = List.empty();
    }
    for (var element in page.content) {
      final categories = element.itemCategories;
      if (categories == null) continue;
      for (var category in categories)  {
        map[category] = [...?map[category], element];
      }
    }
    map.removeWhere((key, value) => value.isEmpty);
    return map;
  }
}