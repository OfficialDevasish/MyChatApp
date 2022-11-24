import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mychatapp/LoginScreen.dart';

class SplashScreen extends StatefulWidget {


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.gotonextpage();
    this.hidestutas();
  }

  gotonextpage()async{
    await Future.delayed(Duration(seconds: 3),(){
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>LoginScreen())
      );
    });
  }

  void hidestutas()async{
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue.shade50,
          child:Column(

            children: [
              Image.asset("img/img10.png"),

              SizedBox(height: 10,),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
