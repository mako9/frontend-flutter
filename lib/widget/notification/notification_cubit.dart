import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/di/service_locator.dart';
import 'package:frontend_flutter/service/notification_service.dart';

class NotificationCubit extends Cubit<int> {
  final NotificationService _notificationService =
      getIt.get<NotificationService>();

  NotificationCubit() : super(0) {
    loadUnreadCount();
  }

  Future<void> loadUnreadCount() async {
    final count = await _notificationService.getUnreadCount();
    emit(count);
  }
}
