import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
  'AAAAec3orsY:APA91bEZOHV1jeVqvvDb90G4h2njJbwpXfpmdk7tbVghzTseo54dCvcOdkAmEb6d_Ve4aoFn9qIVbIJotPkGZ7llyYNHiVyZT9GX_FXnCh6fnPZKNMsxtU6qNmvwWdPjehVUNxQNmGVO';
     
//'AAAAagzhBvY:APA91bHDvXxfpWasB2PTFzxyUD9tJn4bHRgnBc0f5RBFY2peJ5StpZoxibIVA2W4RPjFsn3BTJ-r-_B1kHvLUapOKpiqK6l-_1SSZLJioYQh0j69OxVabANCowWziIPDubIaDwBq2L4P';
  static Future<Response> sendToUser({
    // @required String description,
    @required String alert,
    @required String id,
  }) =>
     // sendToTopic( amount:amount,description: description, token: id);
sendToTopic( alert: alert, token: id);
  static Future<Response> sendToTopic(
          {
           @required String alert,
           @required String token}) =>
      sendTo( alert:alert,
       fcmToken:  '$token');
     

  static Future<Response> sendTo({
    
    @required String alert,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
     
          'notification': { 'title': '$alert','body':'$alert',
          

         },
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            
          },
          'to': ' $fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}