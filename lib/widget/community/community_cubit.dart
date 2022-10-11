import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/model/community.dart';

import '../../di/service_locator.dart';
import '../../model/data_page.dart';
import '../../service/community_service.dart';

class CommunityPageCubit extends Cubit<DataPage<Community>?> {
  final CommunityService _communityService = getIt.get<CommunityService>();

  CommunityPageCubit(super.initialState) {
    loadOwnCommunity(0);
  }

  Future<void> loadOwnCommunity(int pageNumber) async {
    final communityPage = await _communityService.getMyCommunities(pageNumber);
    emit(communityPage);
  }
}