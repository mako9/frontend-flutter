import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/item_service.dart';

import '../../di/service_locator.dart';
import '../../model/data_response.dart';

class ItemEditCubit extends Cubit<DataResponse<Item>> {
  final ItemService _itemService = getIt.get<ItemService>();

  ItemEditCubit(super.initialState) {
    final uuid = state.data?.uuid;
    if (uuid != null) getItem(uuid);
  }

  factory ItemEditCubit.ofInitialState({Item? item}) {
    return ItemEditCubit(DataResponse(data: item, errorMessage: null));
  }

  Future<void> createItem(Item item) async {
    final itemDataResponse = await _itemService.createItem(item);
    emit(itemDataResponse);
  }

  Future<void> updateItem(Item item) async {
    final itemDataResponse = await _itemService.updateItem(item);
    emit(itemDataResponse);
  }

  Future<void> getItem(String uuid) async {
    final itemDataResponse = await _itemService.getItem(uuid);
    emit(itemDataResponse);
  }

  Future<void> deleteItem(Item item) async {
    await _itemService.deleteItem(item.uuid!);
  }
}