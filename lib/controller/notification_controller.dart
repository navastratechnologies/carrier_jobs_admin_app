import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();
}

void sendPushMessage(token, body, title, jobId) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAoynrAWo:APA91bGv29ehf1e58CrYUofDoc-qMus5jR6aEtRUFrtIL8kyrf56-o5C2BwJ_bOOR1MghcaHxngS6Yzot1qJV9d2N4fmv1fViqIax7aj3T44QEfeOfzzGt5J_Ku3NnbbytsKfZ6Eamih',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'jobId': jobId,
          },
          "to": token,
        },
      ),
    );
  } catch (e) {
    print("error push notification $e");
  }
}
