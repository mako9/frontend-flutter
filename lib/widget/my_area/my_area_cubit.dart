import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/item.dart';

import '../../di/service_locator.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../../service/community_service.dart';
import '../../service/item_service.dart';

class MyAreaCubit extends Cubit<DataResponse<MyAreaState>> {
  final CommunityService _communityService = getIt.get<CommunityService>();
  final ItemService _itemService = getIt.get<ItemService>();

  MyAreaCubit(super.initialState) {
    loadInitialData();
  }

  factory MyAreaCubit.ofInitialState() {
    return MyAreaCubit(DataResponse.empty());
  }

  Future<void> loadInitialData() async {
    final communityDataResponse = await _communityService.getCommunitiesOwnedByMe(pageNumber: 0);
    final itemDataResponse = await _itemService.getItemsOwnedByMe(pageNumber: 0);
    emit(DataResponse(data:
    MyAreaState(
        communities: communityDataResponse.data,
        items: ItemService.getGroupedItems(itemDataResponse.data)
    ),
        errorMessage: communityDataResponse.errorMessage ?? itemDataResponse.errorMessage));
  }

  Future<void> loadCommunitiesOwnedByMe({int pageNumber = 0}) async {
    final communityDataResponse = await _communityService.getCommunitiesOwnedByMe(pageNumber: pageNumber);
    emit(DataResponse(data:
      MyAreaState(
        communities: communityDataResponse.data,
        items: state.data?.items
      ),
        errorMessage: communityDataResponse.errorMessage));
  }

  Future<void> loadItemsOwnedByMe({int pageNumber = 0}) async {
    final itemDataResponse = await _itemService.getItemsOwnedByMe(pageNumber: pageNumber);
    emit(DataResponse(data:
    MyAreaState(
        communities: state.data?.communities,
        items: ItemService.getGroupedItems(itemDataResponse.data)
    ),
        errorMessage: itemDataResponse.errorMessage));
  }
}

class MyAreaState {
  DataPage<Community>? communities;
  Map<ItemCategory, List<Item>>? items;

  MyAreaState({this.communities, this.items});
}