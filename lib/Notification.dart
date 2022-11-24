import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {


  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("local Notification"),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                AwesomeNotifications().createNotification(
                    content: NotificationContent(
                        id: 10,
                        channelKey: 'basic_channel',
                        title: 'Simple Notification',
                        body: 'Simple body'
                    )
                );
              },
              child: Text("Notification"),
            ),
            ElevatedButton(
              onPressed: () async {
                AwesomeNotifications().cancel(10);
              },
              child: Text("Clear"),
            ),
            ElevatedButton(
              onPressed: () async {
                AwesomeNotifications().createNotification(
                    content: NotificationContent(
                    id: 1,
                    channelKey: 'key1',
                    title: 'This is Notification title',
                    body: 'This is Body of Noti',
                    bigPicture: 'https://protocoderspoint.com/wp-content/uploads/2021/05/Monitize-flutter-app-with-google-admob-min-741x486.png',
                    notificationLayout: NotificationLayout.BigPicture
                ));
              },
              child: Text("Image"),
            ),

            ElevatedButton(
                onPressed: ()async{

                  bool isallowed = await AwesomeNotifications().isNotificationAllowed();
                  if (!isallowed) {
                    //no permission of local notification
                    AwesomeNotifications().requestPermissionToSendNotifications();
                  }else{
                    //show notification
                    AwesomeNotifications().createNotification(
                        content: NotificationContent( //simgple notification
                          id: 123,
                          channelKey: 'key2',
                          title: 'Welcome to FlutterCampus.com',
                          body: 'Button NotiFication',
                          payload: {"name":"FlutterCampus"},
                          autoDismissible: false,
                        ),

                        actionButtons: [
                          NotificationActionButton(
                            key: "open",
                            label: "Replay",
                          ),

                          NotificationActionButton(
                            key: "delete",
                            label: "Delete File",
                          )
                        ]
                    );
                  }
                },
                child: Text("Show Notification With Button")
            ),

          ],

        ),
      ),
    );
  }
}








