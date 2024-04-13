import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventappnew/view/event/payment/card_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants/constants.dart';
import '../../view_model/event_provider.dart';


class EventDetail extends StatefulWidget {
  const EventDetail({Key? key}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final snackBar = SnackBar(
    content: const Text('Please Turn on Location'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  late GoogleMapController mapController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  dynamic a=1;
  double totalDist=0;
  var total=0;
  var lat;
  var long;
  double calculateDistance(double lat1,double lon1,double lat2,double lon2){
    // double lat2=context.read<WorkerSideProvider>().userLat;
    // double lon2=context.read<WorkerSideProvider>().userLong;

    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    totalDist=12742* asin(sqrt(a));
    total=totalDist.round();


    return   totalDist;
  }
  Marker marker = Marker(
    markerId: const MarkerId('default'),
  );
  Marker user_marker = Marker(
    markerId: const MarkerId('default2'),
  );
  var ic=Icon(
    Icons.pin_drop,
    color: Colors.red,
  );
  var hei;
  var wid;
  @override
  Widget build(BuildContext context) {
    hei=MediaQuery.of(context).size.height;
    wid=MediaQuery.of(context).size.width;
    return Scaffold(

      floatingActionButton: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width/1.1,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: defaultColor, // Background color
          ),

          onPressed: (){
            Alert(
              context: context,
              type: AlertType.warning,
              title: "Alert",
              desc: "Do you wanna participate in the event?",
              buttons: [
                DialogButton(
                  color: defaultColor,
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    DateTime currentDate = DateTime.now();
                    DateTime eventDate = context.read<EventProvider>().eventModel.date;

                    if (eventDate.isBefore(currentDate)) {
                      Navigator.pop(context);
                      // Event date is before the current date
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("This event has already passed. Cannot participate."),
                        ),
                      );
                    } else {
                      // Event date is in the future, add participant
                      FirebaseFirestore.instance
                          .collection('events')
                          .doc(context.read<EventProvider>().eventModel.documentId)
                          .collection('participants')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        "eventId": context.read<EventProvider>().eventModel.documentId,
                        "userId": FirebaseAuth.instance.currentUser!.uid,
                      });
                      if(context.read<EventProvider>().eventModel.price=="free"){
                        Navigator.pop(context);
                      }
                      else{
                        Navigator.push(context, PageRouteBuilder(
                            transitionDuration: Duration(seconds: 1),
                            transitionsBuilder: (BuildContext context,Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child){
                              animation=CurvedAnimation(parent: animation, curve: Curves.ease);
                              return ScaleTransition(
                                alignment: Alignment.center,
                                scale: animation,
                                child: child,
                              );

                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation
                                ){
                              return MySample();
                            }

                        )
                        );

                      }




                    }
                  },
                  width: 120,
                )

              ],
            ).show();


          },
          child: Text('Participate'
          ),
        ),
      ),
      body: NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250.0,
              leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back
                ),
              ),

              floating: true,
              pinned: true,
              snap: true,

              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl:context.watch<EventProvider>().imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                  )
                ],
              ),
            ),


            // SliverPadding(
            //   padding: new EdgeInsets.all(16.0),
            //   sliver: new SliverList(
            //     delegate: new SliverChildListDelegate([
            //       TabBar(
            //         labelColor: Colors.black87,
            //         unselectedLabelColor: Colors.grey,
            //         tabs: [
            //           new Tab(icon: new Icon(Icons.info), text: "Tab 1"),
            //           new Tab(
            //               icon: new Icon(Icons.lightbulb_outline),
            //               text: "Tab 2"),
            //         ],
            //       ),
            //     ]),
            //   ),
            // ),
          ];
        },
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            // color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                const SizedBox(
                  height: 20,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.watch<EventProvider>().eventModel.eventName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.pin_drop,
                            color: Color(0xFFD9DDE1),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(context.read<EventProvider>().eventModel.city),
                          const SizedBox(
                            width: 15,
                          ),
                          const Icon(
                            Icons.calendar_month,
                            color: Color(0xFFD9DDE1),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                           Text("${context.read<EventProvider>().eventModel.date.day}th / ${context.read<EventProvider>().eventModel.date.month}/ ${context.read<EventProvider>().eventModel.date.year}"),

                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      Container(
                        height: 100,
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFD9DDE1)
                          ),

                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(

                                children: [
                                  Text("Participents",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black

                                  ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CachedNetworkImage(
                                    height: 25,
                                    width: 25,
                                    fit: BoxFit.cover,
                                    imageUrl: "https://cdn-icons-png.flaticon.com/512/4807/4807598.png",
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return ClipOval(
                                                child: CachedNetworkImage(
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                  imageUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80',
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              );
                                            }),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: defaultColor
                                        ),
                                        child: const Center(
                                          child: Text('+20',
                                            style: TextStyle(
                                                fontSize: 10
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                  CachedNetworkImage(
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                    imageUrl: "https://cdn-icons-png.flaticon.com/512/854/854878.png",
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('About Event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                       Text(
                         context.read<EventProvider>().eventModel.desc,
                        // "After many years, we're finally coming back to South"
                        //   "East Asial Your love and support for our band since day I has never gone unnoticed and we can't wait to see all of your beautiful faces again."
                        // "After many years, we're finally coming back to South"
                        //     "East Asial Your love and support for our band since day I has never gone unnoticed and we can't wait to see all of your beautiful faces again."
                        // "After many years, we're finally coming back to South"
                        //     "East Asial Your love and support for our band since day I has never gone unnoticed and we can't wait to see all of your beautiful faces again.",

                        style: TextStyle(
                          color: Color(0xFFC7C8CA)
                        ),

                      )




                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: defaultColor,
                    ),
                    height: hei/3.5,
                    width: wid,

                    child: Stack(
                      children: [
                        GoogleMap(

                          initialCameraPosition:
                          CameraPosition(target: LatLng(double.parse(context.read<EventProvider>().eventModel.eventLat), double.parse(context.read<EventProvider>().eventModel.eventLong)), zoom: 15),
                          onMapCreated: _onMapCreated,
                          mapType: MapType.hybrid,
                          zoomControlsEnabled: false,
                          compassEnabled: true,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: {
                            marker,
                            user_marker
                          },

                        ),

                        Positioned(
                          bottom: 50,
                          right: 10,
                          child: FloatingActionButton(onPressed: ()async {
                            a = await _determinePosition();
                            lat=a.latitude;
                            long=a.longitude;
                            var _newposition = CameraPosition(
                                target: LatLng(a.latitude, a.longitude), zoom: 15);
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(_newposition));
                            setState(() {
                              double dist=calculateDistance(double.parse(context.read<EventProvider>().eventModel.eventLat), double.parse(context.read<EventProvider>().eventModel.eventLong),a.latitude, a.longitude);
                              print("total distance isss $dist");
                              _addMarker(a.latitude, a.longitude);
                            });

                          },
                            child: Icon(
                              Icons.pin_drop,
                              color: defaultColor,
                            ),
                          ),
                        )
                      ],

                    ),




                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      marker = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(double.parse(context.read<EventProvider>().eventModel.eventLat), double.parse(context.read<EventProvider>().eventModel.eventLong)),
      );
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  _addMarker(double lat, double long) {
    setState(() {

      user_marker = Marker(
        markerId: const MarkerId('origin1'),
        infoWindow: const InfoWindow(title: 'Origin1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(lat, long),
      );
    });
    ic=Icon(
      Icons.four_g_mobiledata_outlined,
      color: Colors.red,
    );
  }
}
