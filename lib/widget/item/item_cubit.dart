import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/service/item_service.dart';

import '../../di/service_locator.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../../model/item.dart';

class ItemCubit extends Cubit<DataResponse<Map<ItemCategory, List<Item>>>> {
  final ItemService _itemService = getIt.get<ItemService>();
  DataPage<Item>? _currentItems;

  ItemCubit(super.initialState) {
    loadItemsOfMyCommunities();
  }

  factory ItemCubit.ofInitialState() {
    return ItemCubit(DataResponse.empty());
  }

  Future<void> loadItemsOfMyCommunities({int pageNumber = 0}) async {
    final itemDataResponse = await _itemService.getMyItems(pageNumber: pageNumber);
    _currentItems = itemDataResponse.data;
    _getItemImages();
    final groupedItems = ItemService.getGroupedItems(itemDataResponse.data);
    emit(DataResponse(data: groupedItems, errorMessage: itemDataResponse.errorMessage));
  }

  Future<void> loadMyItems({int pageNumber = 0}) async {
    final itemDataResponse = await _itemService.getMyItems(pageNumber: pageNumber);
    _currentItems = itemDataResponse.data;
    _getItemImages();
    final groupedItems = ItemService.getGroupedItems(itemDataResponse.data);
    emit(DataResponse(data: groupedItems, errorMessage: itemDataResponse.errorMessage));
  }

  Future<void> _getItemImages() async {
    final itemUuids = _currentItems?.content.map((e) => e.uuid) ?? [];
    for (var uuid in itemUuids) {
      if (uuid == null) continue;
      final itemImageDataResponse = await _itemService.getItemImage(uuid);
      if (itemImageDataResponse.data == null) continue;
      _currentItems?.content.firstWhere((e) => e.uuid == uuid).imageData = itemImageDataResponse.data;
    }
    final groupedItems = ItemService.getGroupedItems(_currentItems);
    emit(DataResponse(data: groupedItems, errorMessage: state.errorMessage));
  }
}