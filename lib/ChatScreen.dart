
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/ImageView.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mychatapp/VideoView.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {

  var  pic =  "";

  var  mail =  "";

  var  nm =    "";

  var  receiverid = "";


  ChatScreen({this.pic,this.mail,this.nm,this.receiverid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  ScrollController listScrollController = ScrollController();
  ImagePicker _picker = ImagePicker();



  TextEditingController _msg = TextEditingController();
  var isloading=false;
  var senderid;
  var receiverid;
  getvalue() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       senderid = prefs.getString("senderid");
       receiverid = widget.receiverid.toString();
     });
  }


  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    _msg
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _msg.text.length));
  }

  _onBackspacePressed() {
    _msg
      ..text = _msg.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _msg.text.length));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalue();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){

            }, icon: Icon(Icons.call))
          ],
          titleSpacing: 0,
          title: Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: CircleAvatar(
                    radius: 25, // Image radius
                    backgroundImage: NetworkImage(widget.pic),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.nm,style: TextStyle(fontSize: 14.0)),
                      Text(widget.mail,style: TextStyle(fontSize: 12.0)),
                    ],
                  ),
                )
              ],
            ),
          ),
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back_ios)),
        ),
        body:SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Users")
                      .doc(senderid).collection("Chats").doc(receiverid).collection("messages").orderBy("timestamp",descending: true).snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData)
                      {
                       if(snapshot.data.size<=0)
                         {
                           return Center(
                             child: Text("No Messages"),
                           );
                         }
                       else
                         {
                           return ListView(

                             controller: listScrollController,
                             reverse: true,
                            // Timer(Duration(milliseconds: 500), () => _myController.jumpTo(_myController.position.maxScrollExtent)),


                             children: snapshot.data.docs.map((document){
                               if(document["senderid"]==senderid)
                                 {
                                   return Align(
                                     alignment: Alignment.centerRight,
                                     child: Container(

                                       padding: EdgeInsets.all(15.0),
                                       margin: EdgeInsets.all(15.0),
                                       child: (document["msgtype"]=="image")?GestureDetector(
                                         onTap: ()async{
                                           Navigator.of(context).push(
                                             MaterialPageRoute(builder: (context)=>ImageView(img:document["message"],))
                                           );
                                         },
                                         child: Image.network(document["message"],width: 100.0),
                                       ):(document["msgtype"]=="video")?
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => VideoView(vid: document["message"],))
                                                );
                                              },
                                              child: Image.asset("img/img13.png"),
                                            )
                                           :Text(document["message"],style: TextStyle(color: Colors.white)),
                                       decoration: BoxDecoration(
                                           color: Colors.black,
                                           borderRadius: BorderRadius.circular(15.0)
                                       ),
                                     ),
                                   );
                                 }
                               else
                                 {
                                   return Align(
                                     alignment: Alignment.centerLeft,
                                     child: Container(

                                       padding: EdgeInsets.all(15.0),
                                       margin: EdgeInsets.all(15.0),
                                       child: (document["msgtype"]=="image")?GestureDetector(
                                         onTap: ()async{
                                           Navigator.of(context).push(
                                               MaterialPageRoute(builder: (context)=>ImageView(img:document["message"],))
                                           );
                                         },
                                         child: Image.network(document["message"],width: 100.0),
                                       ):(document["msgtype"]=="video")?
                                       GestureDetector(
                                         onTap: (){
                                           Navigator.of(context).push(
                                               MaterialPageRoute(builder: (context) => VideoView(vid: document["message"],))
                                           );
                                         },
                                         child: Image.asset("img/img13.png"),
                                       )
                                           :Text(document["message"],style: TextStyle(color: Colors.white)),
                                       decoration: BoxDecoration(
                                           color: Colors.black,
                                           borderRadius: BorderRadius.circular(15.0)
                                       ),
                                     ),
                                   );
                                 }

                             }).toList(),
                           );
                         }
                      }
                    else
                      {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                  },
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: TextField(
                            controller: _msg,
                            decoration: InputDecoration(
                              hintText: 'message',
                              prefixIcon: IconButton(onPressed: ()async{
                                setState(() {
                                  emojiShowing = !emojiShowing;
                                });
                              },
                                  icon: Icon(Icons.emoji_emotions_outlined,color: Colors.black,)),
                              suffixIcon: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (isloading)?CircularProgressIndicator():  IconButton(
                                      onPressed: ()async{
                                         XFile photo = await _picker.pickImage(source: ImageSource.camera);

                                         var timestamp=DateTime.now().millisecondsSinceEpoch;
                                         var sdocid="";
                                         var rdocid="";



                                         await FirebaseFirestore.instance.collection("Users")
                                             .doc(senderid)
                                             .collection("Chats").doc(receiverid).collection("messages").add({
                                           "senderid":senderid,
                                           "receiverid":receiverid,
                                           "message":"Uploading...",
                                           "msgtype":"text",
                                           "timestamp":timestamp
                                         }).then((value) async{
                                           setState(() {
                                             sdocid=value.id.toString();
                                           });
                                           await FirebaseFirestore.instance.collection("Users")
                                               .doc(receiverid)
                                               .collection("Chats").doc(senderid).collection("messages").add({
                                             "senderid":senderid,
                                             "receiverid":receiverid,
                                             "message":"Uploading...",
                                             "msgtype":"text",
                                             "timestamp":timestamp
                                           }).then((value){
                                             _msg.text="";
                                             setState(() {
                                               rdocid=value.id.toString();
                                             });
                                             final position = listScrollController.position.minScrollExtent;
                                             listScrollController.jumpTo(position);
                                           }).then((value) async{
                                             File imagefile = File(photo.path);
                                             var uuid = Uuid();
                                             var imagename = uuid.v4().toString()+".jpg";
                                             await FirebaseStorage.instance.ref(imagename).putFile(imagefile)
                                                 .whenComplete((){}).then((filedata) async{
                                               await filedata.ref.getDownloadURL().then((fileurl) async{
                                                 SharedPreferences prefs = await SharedPreferences.getInstance();
                                                 var senderid = prefs.getString("senderid");
                                                 var receiverid = widget.receiverid.toString();
                                                 var timestamp=DateTime.now().millisecondsSinceEpoch;

                                                 await FirebaseFirestore.instance.collection("Users")
                                                     .doc(senderid)
                                                     .collection("Chats").doc(receiverid).collection("messages").add({
                                                   "senderid":senderid,
                                                   "receiverid":receiverid,
                                                   "message":fileurl,
                                                   "msgtype":"image",
                                                   "timestamp":timestamp
                                                 }).then((value) async{
                                                   await FirebaseFirestore.instance.collection("Users")
                                                       .doc(receiverid)
                                                       .collection("Chats").doc(senderid).collection("messages").add({
                                                     "senderid":senderid,
                                                     "receiverid":receiverid,
                                                     "message":fileurl,
                                                     "msgtype":"image",
                                                     "timestamp":timestamp
                                                   }).then((value) async{
                                                     _msg.text="";
                                                     final position = listScrollController.position.minScrollExtent;
                                                     listScrollController.jumpTo(position);
                                                     await FirebaseFirestore.instance.collection("Users")
                                                         .doc(senderid)
                                                         .collection("Chats").doc(receiverid).collection("messages").doc(sdocid).delete();

                                                     await FirebaseFirestore.instance.collection("Users")
                                                         .doc(receiverid)
                                                         .collection("Chats").doc(senderid).collection("messages").doc(rdocid).delete();
                                                   });
                                                 });
                                               });
                                             });
                                           });
                                         });




                                      },

                                      icon: Icon(Icons.camera),
                                    ),
                                    IconButton(
                                      onPressed: ()async{
                                        XFile photo = await _picker.pickImage(source: ImageSource.gallery);
                                        File imagefile = File(photo.path);
                                        var uuid = Uuid();
                                        var imagename = uuid.v4().toString()+".jpg";
                                        await FirebaseStorage.instance.ref(imagename).putFile(imagefile).whenComplete((){}).then((filedata) async{
                                          await filedata.ref.getDownloadURL().then((fileurl) async{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            var senderid = prefs.getString("senderid");
                                            var receiverid = widget.receiverid.toString();
                                            var timestamp=DateTime.now().millisecondsSinceEpoch;
                                            await FirebaseFirestore.instance.collection("Users")
                                                .doc(senderid)
                                                .collection("Chats").doc(receiverid).collection("messages").add({
                                              "senderid":senderid,
                                              "receiverid":receiverid,
                                              "message":fileurl,
                                              "msgtype":"image",
                                              "timestamp":timestamp
                                            }).then((value) async{
                                              await FirebaseFirestore.instance.collection("Users")
                                                  .doc(receiverid)
                                                  .collection("Chats").doc(senderid).collection("messages").add({
                                                "senderid":senderid,
                                                "receiverid":receiverid,
                                                "message":fileurl,
                                                "msgtype":"image",
                                                "timestamp":timestamp
                                              }).then((value){
                                                _msg.text="";
                                                final position = listScrollController.position.minScrollExtent;
                                                listScrollController.jumpTo(position);
                                              });
                                            });
                                          });
                                        });
                                      },

                                      icon: Icon(Icons.image),
                                    ),
                                    IconButton(
                                      onPressed: ()async{


                                        XFile photo = await _picker.pickVideo(source: ImageSource.gallery);
                                        File videofile = File(photo.path);

                                        var uuid = Uuid();
                                        var imagename = uuid.v4().toString()+".mp4";
                                        await FirebaseStorage.instance.ref(imagename).putFile(videofile).whenComplete((){}).then((filedata) async{
                                          await filedata.ref.getDownloadURL().then((fileurl) async{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            var senderid = prefs.getString("senderid");
                                            var receiverid = widget.receiverid.toString();
                                            var timestamp=DateTime.now().millisecondsSinceEpoch;
                                            await FirebaseFirestore.instance.collection("Users")
                                                .doc(senderid)
                                                .collection("Chats").doc(receiverid).collection("messages").add({
                                              "senderid":senderid,
                                              "receiverid":receiverid,
                                              "message":fileurl,
                                              "msgtype":"video",
                                              "timestamp":timestamp
                                            }).then((value) async{
                                              await FirebaseFirestore.instance.collection("Users")
                                                  .doc(receiverid)
                                                  .collection("Chats").doc(senderid).collection("messages").add({
                                                "senderid":senderid,
                                                "receiverid":receiverid,
                                                "message":fileurl,
                                                "msgtype":"video",
                                                "timestamp":timestamp
                                              }).then((value){
                                                _msg.text="";
                                                final position = listScrollController.position.minScrollExtent;
                                                listScrollController.jumpTo(position);
                                              });
                                            });
                                          });
                                        });

                                      },



                                    icon:Icon (Icons.video_collection),
                                    )
                                  ],
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)
                              )
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: ()async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var senderid = prefs.getString("senderid");
                          var receiverid = widget.receiverid.toString();
                          print("Sender Id : "+senderid);
                          print("Receiver Id : "+receiverid);

                          var msg = _msg.text.toString();

                          var timestamp=DateTime.now().millisecondsSinceEpoch;
                          if(msg.length>=1)
                            {
                              await FirebaseFirestore.instance.collection("Users")
                                  .doc(senderid)
                                  .collection("Chats").doc(receiverid).collection("messages").add({
                                "senderid":senderid,
                                "receiverid":receiverid,
                                "message":msg,
                                "msgtype":"text",
                                "timestamp":timestamp
                              }).then((value) async{
                                await FirebaseFirestore.instance.collection("Users")
                                    .doc(receiverid)
                                    .collection("Chats").doc(senderid).collection("messages").add({
                                  "senderid":senderid,
                                  "receiverid":receiverid,
                                  "message":msg,
                                  "msgtype":"text",
                                  "timestamp":timestamp
                                }).then((value){
                                  _msg.text="";
                                  final position = listScrollController.position.minScrollExtent;
                                  listScrollController.jumpTo(position);
                                });
                              });
                            }
                        },
                        icon: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: 'No Recents',
                          noRecentsStyle: const TextStyle(
                              fontSize: 20, color: Colors.black26),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
