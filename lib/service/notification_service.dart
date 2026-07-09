import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/model/app_notification.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/model/data_response.dart';
import 'package:frontend_flutter/service/request_service.dart';
import 'package:frontend_flutter/util/http_helper.dart';

class NotificationService {
  final RequestService _requestService = getIt.get<RequestService>();
  final String _path = 'user/notification';

  Future<DataResponse<DataPage<AppNotification>>> getNotifications(
      {int pageNumber = 0}) async {
    final response = await _requestService.request(
      '$_path/',
      queryParameters: {
        'pageSize': '20',
        'pageNumber': pageNumber.toString()
      },
    );
    final json = response.getData();
    DataPage<AppNotification>? page;
    if (json != null) page = DataPage.fromJson(json, AppNotification.fromJson);
    return DataResponse.fromHttpResponse(page, response);
  }

  Future<int> getUnreadCount() async {
    final response =
        await _requestService.request('$_path/unread-count');
    final json = response.getData();
    if (json == null) return 0;
    return (json['count'] as int?) ?? 0;
  }

  Future<void> markRead(String uuid) async {
    await _requestService.request('$_path/$uuid/read',
        method: HttpMethod.patch);
  }

  Future<void> markAllRead() async {
    await _requestService.request('$_path/read-all', method: HttpMethod.patch);
  }
}
