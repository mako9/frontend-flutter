import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/community.dart';

import '../../di/service_locator.dart';
import '../../model/data_page.dart';
import '../../model/data_response.dart';
import '../../service/community_service.dart';

class CommunityCubit extends Cubit<DataResponse<DataPage<Community>>> {
  final CommunityService _communityService = getIt.get<CommunityService>();

  CommunityCubit(super.initialState) {
    loadMyCommunities();
  }

  factory CommunityCubit.ofInitialState() {
    return CommunityCubit(DataResponse.empty());
  }

  Future<void> loadAllCommunities({int pageNumber = 0}) async {
    final communityDataResponse = await _communityService.getAllCommunities(pageNumber: pageNumber);
    emit(communityDataResponse);
  }

  Future<void> loadMyCommunities({int pageNumber = 0}) async {
    final communityDataResponse = await _communityService.getMyCommunities(pageNumber: pageNumber);
    emit(communityDataResponse);
  }
}