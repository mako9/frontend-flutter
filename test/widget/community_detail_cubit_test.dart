import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/community.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/user.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/widget/community/community_detail_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const uuid = 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8';
  late CommunityService mockCommunityService;
  late CommunityDetailCubit communityDetailCubit;
  const communityResponse = DataResponse<Community>(data: Community(
    uuid: uuid,
    name: 'name',
    radius: 10,
  ), errorMessage: null);
  const memberResponse = DataResponse<DataPage<User>>(data: DataPage(
    content: [
      User(uuid: 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8', firstName: 'test', lastName: 'test')
    ],
    isFirstPage: true,
    isLastPage: true,
    pageNumber: 0,
    pageSize: 1,
    totalElements: 1,
    totalPages: 1,),
    errorMessage: null);

  setUpAll(() async {
    getServices();
    mockCommunityService = MockCommunityService();
    await getIt.unregister<CommunityService>();
    getIt.registerLazySingleton<CommunityService>(() => mockCommunityService);
    communityDetailCubit = CommunityDetailCubit(DataResponse.empty());
  });

  test('when loading detailed community with success, then state is set to data response', () async {
    when(mockCommunityService.getCommunity(uuid)).thenAnswer((_) async => communityResponse);
    when(mockCommunityService.getCommunityMember(uuid)).thenAnswer((_) async => memberResponse);
    await communityDetailCubit.getCommunityWithMember(uuid);

    expect(communityDetailCubit.state.data?.community?.uuid, uuid);
    expect(communityDetailCubit.state.data?.community?.name, communityResponse.data?.name);
    expect(communityDetailCubit.state.data?.communityMember?.content.length, 1);
    expect(communityDetailCubit.state.data?.communityMember?.pageNumber, 0);
    expect(communityDetailCubit.state.data?.communityMember?.totalElements, 1);
  });
}