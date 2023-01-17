import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/service_locator.dart';
import '../../model/data_response.dart';
import '../../model/item.dart';
import '../../service/item_service.dart';

class ItemDetailCubit extends Cubit<DataResponse<Item>> {
  final ItemService _itemService = getIt.get<ItemService>();

  ItemDetailCubit(super.initialState) {
    final uuid = state.data?.uuid;
    if (uuid != null) {
      getItem(uuid);
      _getItemImage(uuid);
    }
  }

  factory ItemDetailCubit.ofInitialState({Item? item}) {
    return ItemDetailCubit(DataResponse(data: item, errorMessage: null));
  }

  Future<void> getItem(String uuid) async {
    final itemDataResponse = await _itemService.getItem(uuid);
    emit(itemDataResponse);
  }

  Future<void> _getItemImage(String uuid) async {
    final itemImageDataResponse = await _itemService.getItemImage(uuid);
    state.data?.imageData = itemImageDataResponse.data;
    final newState = DataResponse(
        data: state.data,
        errorMessage: state.errorMessage ?? itemImageDataResponse.errorMessage
    );
    emit(newState);
  }
}
