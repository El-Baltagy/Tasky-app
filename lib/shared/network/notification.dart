import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rxdart/rxdart.dart';
class NotificationApi {
  static final notification = FlutterLocalNotificationsPlugin();
  static final sound = "notification.wav";
  static final onNotification = BehaviorSubject<String?>();

  static Future init({bool initscaudled = false}) async {
    final android = AndroidInitializationSettings('logo');
    final ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await notification.initialize(
      settings,

    );
  }

  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
        sound: RawResourceAndroidNotificationSound(sound.split(".").first),
            importance: Importance.max),
        iOS: DarwinNotificationDetails(sound: sound));
  }

  static Future showNotfication(
      {int? id, String? title, String? msg, String? payload}) async {
    notification.show(id!, title, msg, await notificationDetails(),
        payload: payload);
  }

  static Future schdNotfication(
      {required int? id,
      String? title,
      String? msg,
      String? payload,
      required DateTime time}) async {
    notification.zonedSchedule(id!, title, msg,
        tz.TZDateTime.from(time, tz.local), await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
