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
    final itemDataResponse = await _itemService.getMyItems(pageNumber: pageNumber);
    final groupedItems = ItemService.getGroupedItems(itemDataResponse.data);
    emit(DataResponse(data: groupedItems, errorMessage: itemDataResponse.errorMessage));
  }

  Future<void> loadMyItems({int pageNumber = 0}) async {
    final itemDataResponse = await _itemService.getMyItems(pageNumber: pageNumber);
    final groupedItems = ItemService.getGroupedItems(itemDataResponse.data);
    emit(DataResponse(data: groupedItems, errorMessage: itemDataResponse.errorMessage));
  }
}