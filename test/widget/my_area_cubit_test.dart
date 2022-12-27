import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/item.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/service/item_service.dart';
import 'package:frontend_flutter/widget/my_area/my_area_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ItemService mockItemService;
  late CommunityService mockCommunityService;
  late MyAreaCubit myAreaCubit;

  final itemList = [
    Item(uuid: 'uuid', name: 'name', itemCategories: [ItemCategory.tool, ItemCategory.other]),
    Item(uuid: 'uuidTwo', name: 'nameTwo', itemCategories: [ItemCategory.other])
  ];
  final itemPage = DataPage(
      content: itemList,
      isFirstPage: true,
      isLastPage: true,
      pageNumber: 1,
      pageSize: 1,
      totalElements: 2,
      totalPages: 1
  );
  final itemResponse = DataResponse<DataPage<Item>>(
      data: itemPage,
      errorMessage: null
  );
  final communityPage = DataPage(
      content: [Community(uuid: 'uuid')],
      isFirstPage: true,
      isLastPage: true,
      pageNumber: 1,
      pageSize: 1,
      totalElements: 1,
      totalPages: 1
  );
  final communityResponse = DataResponse<DataPage<Community>>(
      data: communityPage,
      errorMessage: null
  );
  final state = MyAreaState(
      communities: communityPage,
      items: Map.fromEntries([
        MapEntry(ItemCategory.tool, [itemList[0]]),
        MapEntry(ItemCategory.other, itemList),
      ])
  );

  setUpAll(() async {
    getServices();
    mockItemService = MockItemService();
    await getIt.unregister<ItemService>();
    getIt.registerLazySingleton<ItemService>(() => mockItemService);
    mockCommunityService = MockCommunityService();
    await getIt.unregister<CommunityService>();
    getIt.registerLazySingleton<CommunityService>(() => mockCommunityService);
    when(mockItemService.getItemsOwnedByMe()).thenAnswer((_) async => itemResponse);
    when(mockCommunityService.getCommunitiesOwnedByMe()).thenAnswer((_) async => communityResponse);

    myAreaCubit = MyAreaCubit(DataResponse.empty());
  });

  test('when getting initial state, then state is set to data response', () async {
    expect(myAreaCubit.state.data?.items, state.items);
    expect(myAreaCubit.state.data?.communities, state.communities);
  });

  test('when getting items owned with success, then state is set to data response', () async {
    await myAreaCubit.loadItemsOwnedByMe();

    expect(myAreaCubit.state.data?.items, state.items);
  });

  test('when getting communities owned with success, then state is set to data response', () async {
    await myAreaCubit.loadCommunitiesOwnedByMe();

    expect(myAreaCubit.state.data?.communities, state.communities);
  });
}