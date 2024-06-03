// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class Notification {
//   final FlutterLocalNotificationsPlugin notifications =
//       FlutterLocalNotificationsPlugin();
//
//   init() async {
//     var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
//     // var ios = const IOSInitializationSettings();
//
//     // await notifications.initialize(
//     //     InitializationSettings(android: android, iOS: ios),
//     //     onSelectNotification: selectNotification);
//
//
//     await notifications.initialize(
//         InitializationSettings(android: android));
//
//   }
//
//   void selectNotification(String? payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: $payload');
//
//       // todo 这里根据自己的业务处理
//     }
//   }
//
//   // 清除所有通知
//   void cleanNotification() {
//     notifications.cancelAll();
//   }
//
//   void cancelNotification(int id, {String? tag}) {
//     notifications.cancel(id, tag: tag);
//   }
//
// }
//
// var notification = Notification();
