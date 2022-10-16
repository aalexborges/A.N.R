import 'package:A.N.R/models/download_notification.model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DownloadNotificationsService {
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  DownloadNotificationsService._() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _localNotificationsPlugin.initialize(const InitializationSettings(
      android: android,
    ));
  }

  static DownloadNotificationsService? _instance;
  static DownloadNotificationsService get instance {
    _instance ??= DownloadNotificationsService._();
    return _instance!;
  }

  static int get generateId {
    final now = DateTime.now().microsecondsSinceEpoch;
    return (now / 10000000000).round();
  }

  Future<void> start(DownloadNotification notification) async {
    final chapter = notification.chapter;
    final book = notification.book;

    await _localNotificationsPlugin.show(
      notification.id,
      'Iniciando download - ${chapter.name}',
      'Iniciando o download do ${chapter.name} do ${book.type?.toLowerCase() ?? 'livro'} ${book.name}.',
      NotificationDetails(android: _androidDetails(book.id)),
    );
  }

  Future<void> finished(DownloadNotification notification) async {
    final chapter = notification.chapter;
    final book = notification.book;

    await _localNotificationsPlugin.show(
      notification.id,
      'Download finalizado - ${chapter.name}',
      'O download do ${chapter.name} do ${book.type?.toLowerCase() ?? 'livro'} ${book.name} foi finalizado.',
      NotificationDetails(android: _androidFinishedDetails(book.id)),
    );
  }

  Future<void> progress(DownloadNotification notification, int progress) async {
    final chapter = notification.chapter;
    final book = notification.book;

    await _localNotificationsPlugin.show(
      notification.id,
      'Baixando o ${chapter.name} - ${book.name}',
      '${chapter.name} - ${book.type?.toLowerCase() ?? 'livro'} - ${book.name}',
      NotificationDetails(android: _androidProgressDetails(progress)),
    );
  }

  Future<void> remove(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  AndroidNotificationDetails _androidDetails(String groupKey) {
    return AndroidNotificationDetails(
      'download_notifications_channel',
      'Download Notifications',
      channelDescription: 'Notificação de downloads',
      enableLights: true,
      importance: Importance.max,
      priority: Priority.max,
      groupKey: groupKey,
      category: AndroidNotificationCategory.service,
      playSound: false,
      enableVibration: false,
    );
  }

  AndroidNotificationDetails _androidFinishedDetails(String groupKey) {
    return AndroidNotificationDetails(
      'download_finished_notifications_channel',
      'Download Finished Notifications',
      channelDescription: 'Downloads finalizados',
      enableLights: true,
      importance: Importance.max,
      priority: Priority.max,
      groupKey: groupKey,
      category: AndroidNotificationCategory.service,
      playSound: false,
      enableVibration: false,
    );
  }

  AndroidNotificationDetails _androidProgressDetails(int progress) {
    return AndroidNotificationDetails(
      'download_progress_notifications_channel',
      'Download Progress Notifications',
      channelDescription: 'Notificação do progresso do download',
      enableLights: true,
      importance: Importance.min,
      priority: Priority.min,
      progress: progress,
      maxProgress: 100,
      showProgress: true,
      category: AndroidNotificationCategory.progress,
      playSound: false,
      enableVibration: false,
    );
  }
}
