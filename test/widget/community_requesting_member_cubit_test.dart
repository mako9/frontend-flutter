import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/model/user.dart';
import 'package:frontend_flutter/service/community_service.dart';
import 'package:frontend_flutter/widget/community/community_requesting_member_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock.mocks.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const uuid = 'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8';
  late CommunityService mockCommunityService;
  late CommunityRequestingMemberCubit communityRequestingMemberCubit;

  final List<String> userUuids = [
    'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A8',
    'B5CEDBB7-0CAD-4638-8CA6-1FB283FDE5A9',
  ];

  final List<User> userList = [
    User(uuid: userUuids[0], firstName: '1', lastName: '1'),
    User(uuid: userUuids[1], firstName: '2', lastName: '2'),
  ];

  final DataPage<User> userPage = DataPage(
      content: userList,
      isFirstPage: true,
      isLastPage: true,
      pageNumber: 0,
      pageSize: 15,
      totalElements: 2,
      totalPages: 1);

  setUpAll(() async {
    getServices();
    mockCommunityService = MockCommunityService();
    await getIt.unregister<CommunityService>();
    getIt.registerLazySingleton<CommunityService>(() => mockCommunityService);
    communityRequestingMemberCubit = CommunityRequestingMemberCubit.ofInitialState(uuid);
  });

  test('when loading requesting member with success, then state is set to data response', () async {
    when(mockCommunityService.getRequestingMember(uuid)).thenAnswer((_) async => DataResponse(data: userPage, errorMessage: null));
    await communityRequestingMemberCubit.loadRequestingMember(uuid);

    expect(communityRequestingMemberCubit.state.data?.content, userPage.content);
    expect(communityRequestingMemberCubit.state.errorMessage, null);
  });

  test('when approving requesting member with success, then state is set to data response', () async {
    when(mockCommunityService.approveJoinRequests(uuid, userUuids)).thenAnswer((_) async => DataResponse(data: userList, errorMessage: null));
    when(mockCommunityService.getRequestingMember(uuid)).thenAnswer((_) async => DataResponse(data: userPage, errorMessage: null));
    await communityRequestingMemberCubit.approveRequests(uuid, userUuids);

    expect(communityRequestingMemberCubit.state.data?.content, userPage.content);
    expect(communityRequestingMemberCubit.state.errorMessage, null);
  });

  test('when declining requesting member with success, then state is set to data response', () async {
    when(mockCommunityService.declineJoinRequest(uuid, userUuids)).thenAnswer((_) async => DataResponse(data: userList, errorMessage: null));
    when(mockCommunityService.getRequestingMember(uuid)).thenAnswer((_) async => DataResponse(data: userPage, errorMessage: null));
    await communityRequestingMemberCubit.declineRequests(uuid, userUuids);

    expect(communityRequestingMemberCubit.state.data?.content, userPage.content);
    expect(communityRequestingMemberCubit.state.errorMessage, null);
  });
}