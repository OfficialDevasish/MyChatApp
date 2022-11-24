import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChatScreen.dart';
import 'LoginScreen.dart';

class         HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name = "", email = "", photo = "", id = "";
  GoogleSignIn googleSignIn = GoogleSignIn();

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name").toString();
      email = prefs.getString("email").toString();
      photo = prefs.getString("photo").toString();
      id = prefs.getString("id").toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome,"+name.toUpperCase()),
        actions: [
          IconButton(
            color: Colors.black,
            iconSize: 35,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              googleSignIn.signOut();
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").where("email",isNotEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.size <= 0) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return ListView(
                children: snapshot.data.docs.map((document) {
                  return ListTile(

                      leading: CircleAvatar(
                        radius: 30, // Image radius
                        backgroundImage: NetworkImage(document["photo"]),
                      ),
                      title: Text(
                        document["name"],
                        style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Schyler"),
                      ),
                      subtitle: Text(document["email"]),

                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>
                                ChatScreen(pic: document["photo"],receiverid: document.id.toString(),mail: document["email"],nm: document["name"],
                            )));
                      },
                  );

                }).toList(),

              );
              // Text("GoogleId: "+id),
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),


    );
  }
}
