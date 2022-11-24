import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/Notification.dart';

import 'GoogleMapExample.dart';
import 'OnlinePaymentExample.dart';
import 'SplashScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/notification',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        ),
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights:true,
            enableVibration: true
        ),
        NotificationChannel(
            channelKey: 'key2',
            channelName: 'replay Notification',
            channelDescription: "Notification replay example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights:true,
            enableVibration: true
        ),

      ],
      debug: true
  );




  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  // AwesomeNotifications().actionStream.listen((action) {
  //   if(action.buttonKeyPressed == "open"){
  //     print("Open button is pressed");
  //   }else if(action.buttonKeyPressed == "delete"){
  //     print("Delete button is pressed.");
  //   }else{
  //     print(action.payload); //notification was pressed
  //   }
  // });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // AwesomeNotifications().actionStream.listen((action) {
    //   if(action.buttonKeyPressed == "open"){
    //     print("Open button is pressed");
    //   }else if(action.buttonKeyPressed == "delete"){
    //     print("Delete button is pressed.");
    //   }else{
    //     print(action.payload); //notification was pressed
    //   }
    // });



    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: NotificationScreen(),
    );
  }
}
