import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mychatapp/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginScreen extends StatefulWidget {



  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();


  var version="";

  getversion() async
  {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }
  checklogin()async
  {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   if(prefs.containsKey("name"))
     {
       Navigator.of(context).pop();
       Navigator.of(context).push(
           MaterialPageRoute(builder: (context)=>HomePage())
       );
     }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getversion();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Login"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
             Center(
               child:  Image.asset("img/img4.png"),
             ),
              SizedBox(height: 30,),
              GestureDetector(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.black,
                    border: Border.all(

                    ),
                      borderRadius: BorderRadius.all(Radius.circular(50))
                  ),

                  margin: EdgeInsets.all(20),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("img/img6.png",height: 30,),

                      SizedBox(width: 10,),
                      Text("Login With Google",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),

                    ],
                  ),

                ),


                onTap: ()async{

                  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
                  GoogleSignInAuthentication googleSignInAuthentication =
                  await googleSignInAccount.authentication;
                  AuthCredential credential = GoogleAuthProvider.credential(
                    accessToken: googleSignInAuthentication.accessToken,
                    idToken: googleSignInAuthentication.idToken,
                  );
                  UserCredential authResult = await auth.signInWithCredential(credential);
                 User _user = authResult.user;

                 var name = _user.displayName.toString();
                 var email= _user.email.toString();
                 var photo = _user.photoURL.toString();
                 var googleid = _user.uid.toString();

                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 prefs.setString("name", name);
                 prefs.setString("email", email);
                 prefs.setString("photo", photo);
                 prefs.setString("id", googleid);
                 //firebase
                  await FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: email).get().then((data) async{
                    if(data.size<=0)
                      {
                        await FirebaseFirestore.instance.collection("Users").add({
                          "name":name,
                          "email":email,
                          "photo":photo,
                          "id":googleid
                        }).then((value){
                          prefs.setString("senderid", value.id.toString());
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>HomePage())
                          );
                        });
                      }
                    else
                      {
                        prefs.setString("senderid", data.docs.first.id.toString());
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>HomePage())
                        );
                      }
                  });
                  //firebase


                 
                },
              ),




              SizedBox(height: 80,),
              Text("Version: "+version,style: TextStyle(fontSize: 20),),

            ],
          ),
        ),
      ),
    );
  }
}
