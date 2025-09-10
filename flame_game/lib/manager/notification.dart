import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

///建一個Service類別來管理
class LocalNotificationService {
  /// 初始化套件

  ///第幾則通知
  var id = 0;

   static Future<void> initialize() async {
    ///初始化在Android上的通知設定
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    ///初始化在iOS上的通知設定
    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    ///設定組合
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        ///收到通知要做的事

      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

  }



  ///跳出通知
  ///(自定的部份，如果你有用到Firebase來發送訊息，要和Firebase設定的一樣，不然不會有投頭顯示)
  Future<void> showNotification(String title, String content) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('10010', '30days',
        channelDescription: '都可以啦…讓使用者看這是什麼功能的通知',
        importance: Importance.max,
        priority: Priority.high,);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, title, content, notificationDetails,
        payload: '要帶回程式的資料(如果有做點按後回到程式的功能)');
  }
}

class AwesomeNotification {

}