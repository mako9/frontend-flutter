import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/widget/community/community_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CommunityService mockCommunityService;
  late CommunityCubit communityCubit;
  final response = DataResponse<DataPage<Community>>(
      data: DataPage(
        content: [Community(
          uuid: 'uuid',
          name: 'name',
          radius: 10,
        )],
        isFirstPage: true,
        isLastPage: true,
        pageNumber: 1,
        pageSize: 1,
        totalElements: 1,
        totalPages: 1,
      ),
      errorMessage: null
  );

  setUpAll(() async {
    getServices();
    mockCommunityService = MockCommunityService();
    await getIt.unregister<CommunityService>();
    getIt.registerLazySingleton<CommunityService>(() => mockCommunityService);
    communityCubit = CommunityCubit(DataResponse.empty());
  });

  test('when loading all communities with success, then state is set to data response', () async {
    when(mockCommunityService.getAllCommunities()).thenAnswer((_) async => response);
    await communityCubit.loadAllCommunities();

    expect(communityCubit.state, response);
  });

  test('when loading my communities with success, then state is communityPage', () async {
    when(mockCommunityService.getMyCommunities()).thenAnswer((_) async => response);
    await communityCubit.loadMyCommunities();

    expect(communityCubit.state, response);
  });
}