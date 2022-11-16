import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/service_locator.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../../model/user.dart';
import '../../service/community_service.dart';

class CommunityRequestingMemberCubit extends Cubit<DataResponse<DataPage<User>>> {
  final CommunityService _communityService = getIt.get<CommunityService>();

  int _pageNumber = 0;

  CommunityRequestingMemberCubit(super.initialState, String communityUuid) {
    loadRequestingMember(communityUuid);
  }

  factory CommunityRequestingMemberCubit.ofInitialState(String communityUuid) {
    return CommunityRequestingMemberCubit(DataResponse.empty(), communityUuid);
  }

  Future<void> loadRequestingMember(String communityUuid, {int pageNumber = 0}) async {
    _pageNumber = pageNumber;
    final communityDataResponse = await _communityService.getRequestingMember(communityUuid, pageNumber: pageNumber);
    emit(communityDataResponse);
  }

  Future<void> approveRequests(String communityUuid, List<String> userUuids) async {
    await _communityService.approveJoinRequests(communityUuid, userUuids);
    await loadRequestingMember(communityUuid, pageNumber: _pageNumber);
  }

  Future<void> declineRequests(String communityUuid, List<String> userUuids) async {
    await _communityService.declineJoinRequest(communityUuid, userUuids);
    await loadRequestingMember(communityUuid, pageNumber: _pageNumber);
  }
}