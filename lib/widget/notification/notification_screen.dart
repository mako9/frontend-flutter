import 'package:flutter/material.dart';
import 'package:frontend_flutter/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/app_notification.dart';
import 'package:frontend_flutter/service/notification_service.dart';
import 'package:frontend_flutter/di/service_locator.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService =
      getIt.get<NotificationService>();
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _notificationService.markAllRead();
    final response = await _notificationService.getNotifications();
    setState(() {
      _notifications = response.data?.content ?? [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(AppLocalizations.of(context)!.notificationScreen_title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!.emptyList))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final n = _notifications[index];
                    return ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(_notificationLabel(context, n.type)),
                      subtitle: n.createdAt != null
                          ? Text(n.createdAt!
                              .toLocal()
                              .toString()
                              .substring(0, 16))
                          : null,
                    );
                  },
                ),
    );
  }

  String _notificationLabel(BuildContext context, String? type) {
    switch (type) {
      case 'BOOKING_REQUEST':
        return AppLocalizations.of(context)!.notification_bookingRequest;
      case 'BOOKING_CONFIRMED':
        return AppLocalizations.of(context)!.notification_bookingConfirmed;
      case 'BOOKING_DECLINED':
        return AppLocalizations.of(context)!.notification_bookingDeclined;
      case 'BOOKING_CANCELLED':
        return AppLocalizations.of(context)!.notification_bookingCancelled;
      default:
        return type ?? '-';
    }
  }
}
