import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class GoogleMapExample extends StatefulWidget {

  @override
  State<GoogleMapExample> createState() => _GoogleMapExampleState();
}

class _GoogleMapExampleState extends State<GoogleMapExample> {



  BitmapDescriptor icon;

  GoogleMapController _controller;
  Location currentLocation = Location();
  Set<Marker> _markers={};
  Timer _timer;
  void getLocation() async{
    await FirebaseFirestore.instance.collection("Location").doc("5hGxSAVPSPwgIMcNGRxM").get().then((document) async{
      var icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 3.2),"img/img11.png");
      setState(() {
        this.icon = icon;
      });
      setState(() {
        _markers.add(Marker(markerId: MarkerId('Home'),
            icon: icon,
            position: LatLng(double.parse(document["lattitude"]),double.parse(document["longtitude"]))
          ));
        });
    });
    
    // var icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 3.2),"img/img11.png");
    // setState(() {
    //   this.icon = icon;
    // });
    // var location = await currentLocation.getLocation();
    // currentLocation.onLocationChanged.listen((LocationData loc){
    //   _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
    //     target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
    //     zoom: 12.0,
    //   )));
    //   print(loc.latitude);
    //   print(loc.longitude);
    //   setState(() {
    //    _markers.add(Marker(markerId: MarkerId('Home'),
    //         icon: icon,
    //         position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
    //     ));
    //    _markers.add(Marker(markerId: MarkerId('Adajan'),
    //        icon: icon,
    //        position: LatLng(21.1959,72.7933)
    //    ));
    //    _markers.add(Marker(markerId: MarkerId('Rander'),
    //        icon: icon,
    //        position: LatLng(21.2189,72.7961)
    //    ));
    //   });
    // });
  }
  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(21.1702,72.8311),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller){
          _controller = controller;
          getLocation();
        },
        markers: _markers,
      ),
      
    );

  }
}
// class AppConstant {
//   static List<Map<String, dynamic>> list = [
//     {"title": "one", "id": "1", "lat": 21.1959, "lon":72.7933},
//     {"title": "two", "id": "2", "lat": 21.2300, "lon": 72.9009},
//     {"title": "three", "id": "3", "lat": 21.2266, "lon": 72.8312},
//   ];
// }