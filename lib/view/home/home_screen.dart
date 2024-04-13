

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventappnew/constants/constants.dart';
import 'package:eventappnew/user/user_profile.dart';
import 'package:eventappnew/view/authentication/login.dart';
import 'package:eventappnew/view/event/participated_events.dart';
import 'package:eventappnew/view/event/upload_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/event_model.dart';
import '../../view_model/event_provider.dart';
import '../event/event_detail.dart';
import '../event/recommended_events.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('events').snapshots();
  TextEditingController searchController = TextEditingController();
  List<EventModel> filteredEvents=[];
  String categoryType="";
  bool isFiltered=false;
  bool isNearby=false;
  @override
  void initState() {
    // TODO: implement initState
context.read<EventProvider>().getNearByEvents(context);
    super.initState();
  }
  double totalDist=0;
  int total=0;
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
 Future getFilteredList() async{
    await FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Timestamp t=doc['date'] as Timestamp;
        DateTime d=t.toDate();
      setState(() {
        if(categoryType==doc['type']){
          filteredEvents.add(EventModel(imageUrl: doc['image'],
              eventName: doc['eventName'], city: doc['city'], price: "Free",
              type: doc['type'], date: d, eventLat: doc['eventLat'],
              eventLong: doc['eventLong'], eventTime: doc['eventTime'],
              status: doc['status'], createdBy: doc['createdBy'],
              desc: doc["desc"], documentId: doc.id));
        }
      });

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[70],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: defaultColor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/event1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.file_upload, color: defaultColor),
                  SizedBox(width: 10),
                  Text('Upload Event'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadEvents()),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.file_upload, color: defaultColor),
                  SizedBox(width: 10),
                  Text('Recommended Events'),
                ],
              ),
              onTap: () async{
              var a= await context.read<EventProvider>().fetchRecommendations('VsJ2LXMUFmefLKIVptXEmuOriBj1');
              print(a);
              String? eventName = context.read<EventProvider>().getEventWithHighestScore(a);
              print('Event name with highest score: $eventName');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecommendedEvents(eventType: eventName!,)),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.event_note, color: defaultColor),
                  SizedBox(width: 10),
                  Text('My Participated Events'),
                ],
              ),
              onTap: () async {
                await context.read<EventProvider>().participatedEvents();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParticipatedEvents()),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person, color: defaultColor),
                  SizedBox(width: 10),
                  Text('Profile'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout, color: defaultColor),
                  SizedBox(width: 10),
                  Text('Logout'),
                ],
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Navigate to the login or home screen based on your app flow
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm()),
                );
              },
            ),


          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFE91E63),
        title: Text("Home Screen"),
        centerTitle: true,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// appBar
              // appbar(),
              const SizedBox(
                height: 20,
              ),

              ///search bar
              searchBar(),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
                child: buildCategoryContainer(
                    'https://cdn-icons-png.flaticon.com/512/1753/1753311.png',
                    'Festivals'),
              ),

              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   physics: BouncingScrollPhysics(),
              //   child: Row(
              //     children: [
              //       buildCategoryContainer(
              //           'https://cdn-icons-png.flaticon.com/512/1753/1753311.png',
              //           'Festivals'),
              //       // buildCategoryContainer(
              //       //     'https://cdn-icons-png.flaticon.com/512/2071/2071392.png',
              //       //     'Educational'),
              //       // buildCategoryContainer(
              //       //     'https://cdn-icons-png.flaticon.com/512/2402/2402478.png',
              //       //     'Webinars'),
              //       // buildCategoryContainer(
              //       //     'https://cdn-icons-png.flaticon.com/512/3591/3591343.png',
              //       //     'Seminar'),
              //       // buildCategoryContainer(
              //       //     'https://cdn-icons-png.flaticon.com/512/4579/4579333.png',
              //       //     'Expo'),
              //       // buildCategoryContainer(
              //       //     'https://cdn-icons-png.flaticon.com/512/4766/4766734.png',
              //       //     'Conference'),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),

              /// textRow
              buildTextRow(),
              StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return SizedBox(
                    height: 240,
                    child: isFiltered==false?ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        Timestamp t=data['date'] as Timestamp;
                        DateTime d=t.toDate();
                        return InkWell(
                          onTap: (){
                            context.read<EventProvider>().setEvent(EventModel(imageUrl: data['image'], eventName: data['eventName'], city: data['city']
                                , price: "Free", type: data['type'], date: d,
                                eventLat: data['eventLat'], eventLong: data['eventLong'], eventTime:
                                data['eventTime'], status: data['status'], createdBy: data['createdBy'],
                            desc: data['desc'],documentId: document.id
                            ));
                            context.read<EventProvider>().setImageUrl(data['image']);
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
                                  return EventDetail();
                                }

                            )
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const EventDetail()),
                            // );
                          },
                          child: eventContainer(
                              data['image'],
                              data['eventName'],
                              'Free',
                              data['eventLat'],
                          data['eventLong'],
                          data['city']
                          ),
                        );
                      }).toList(),
                    ):filteredEvents.isEmpty?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator(
                          color: defaultColor,
                        )),
                      ],
                    ):ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredEvents.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){
                              Timestamp t=filteredEvents[index].date as Timestamp;
                              DateTime d=t.toDate();
                              context.read<EventProvider>().setEvent(EventModel(imageUrl: filteredEvents[index].imageUrl, eventName: filteredEvents[index].eventName,
                                  city: filteredEvents[index].city
                                  , price: "Free", type: filteredEvents[index].type, date: d,
                                  eventLat: filteredEvents[index].eventLat, eventLong: filteredEvents[index].eventLong, eventTime:
                                  filteredEvents[index].eventTime, status: filteredEvents[index].status, createdBy: filteredEvents[index].createdBy,
                                  desc: filteredEvents[index].desc,documentId:filteredEvents[index].documentId
                              ));
                              context.read<EventProvider>().setImageUrl(filteredEvents[index].imageUrl);
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
                                    return EventDetail();
                                  }

                              )
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const EventDetail()),
                              // );
                            },
                            child: eventContainer(
                                filteredEvents[index].imageUrl,
                                filteredEvents[index].eventName,
                                'Free',
                                filteredEvents[index].eventLat,
                                filteredEvents[index].eventLong,
                                filteredEvents[index].city
                            ),
                          );
                        }
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),

              ///near you
              nearYou(),
              context.watch<EventProvider>().nearbyEvents.isNotEmpty?SizedBox(
                height: 240,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: context.watch<EventProvider>().nearbyEvents.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          Timestamp t=context.watch<EventProvider>().nearbyEvents[index].date as Timestamp;
                          DateTime d=t.toDate();
                          context.read<EventProvider>().setEvent(EventModel(imageUrl: context.watch<EventProvider>().nearbyEvents[index].imageUrl, eventName: filteredEvents[index].eventName,
                              city: context.watch<EventProvider>().nearbyEvents[index].city
                              , price: "Free", type: context.watch<EventProvider>().nearbyEvents[index].type, date: d,
                              eventLat: context.watch<EventProvider>().nearbyEvents[index].eventLat, eventLong: context.watch<EventProvider>().nearbyEvents[index].eventLong, eventTime:
                              context.watch<EventProvider>().nearbyEvents[index].eventTime, status: context.watch<EventProvider>().nearbyEvents[index].status, createdBy: context.watch<EventProvider>().nearbyEvents[index].createdBy,
                              desc: context.watch<EventProvider>().nearbyEvents[index].desc,documentId:context.watch<EventProvider>().nearbyEvents[index].documentId
                          ));
                          context.read<EventProvider>().setImageUrl(context.watch<EventProvider>().nearbyEvents[index].imageUrl);
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
                                return EventDetail();
                              }

                          )
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const EventDetail()),
                          // );
                        },
                        child: eventContainer(
                            filteredEvents[index].imageUrl,
                            filteredEvents[index].eventName,
                            'Free',
                            filteredEvents[index].eventLat,
                            filteredEvents[index].eventLong,
                            filteredEvents[index].city
                        ),
                      );
                    }
                ),
              ):Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                context.watch<EventProvider>().startTimer(),
                  // CircularProgressIndicator(
                  //   color: defaultColor,
                  // ),
                ],
              )

              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   physics: BouncingScrollPhysics(),
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {},
              //         child: eventContainer(
              //             'http://www.traditionntrendz.com/images/events/5-1560497156_crop.jpg',
              //             'Qawali Night',
              //             'Free',
              //             'Islamabad'),
              //       ),
              //       InkWell(
              //         onTap: () {},
              //         child: eventContainer(
              //             'http://www.traditionntrendz.com/images/events/9-1560497195_crop.jpg',
              //             'Rahat Qawali',
              //             'Free',
              //             'Islamabad'),
              //       ),
              //       InkWell(
              //         onTap: () {},
              //         child: eventContainer(
              //             'https://images.unsplash.com/photo-1567942712661-82b9b407abbf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80',
              //             'Mega Concert',
              //             'Rs 3400',
              //             'Islamabad'),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Padding nearYou() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Near You",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            'Events',
            style: TextStyle(
              color: Color(0xFF99BFE0),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Padding buildTextRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Events",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            'Explore',
            style: TextStyle(
              color: Color(0xFF99BFE0),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Padding searchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
      child: SizedBox(
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            // Implement live search logic here if needed
          },
          maxLines: 1,
          minLines: 1,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon:  Icon(
                isFiltered?Icons.close:Icons.search,
                color: Color(0xFF99BFE0),
              ),
              onPressed: () {
                if(isFiltered){
                  setState(() {
                    isFiltered=false;
                  });
                }
                else{
                  searchEvents(searchController.text);
                }
                // Trigger filtering when the search icon is clicked

              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            hintStyle: const TextStyle(
              color: Color(0xFFB9B9B9),
            ),
            hintText: "Search Events..",
            contentPadding: EdgeInsets.all(10),
            fillColor: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }


  Padding appbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.filter_list,
              color: Color(0xFF99BFE0),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Location',
                style: TextStyle(color: Color(0xFFD1D1D1)),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Islamabad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/1827/1827370.png',

                  height: 20,
                  width: 20,
                  // fit: BoxFit.cover,
                ),
              )),
        ],
      ),
    );
  }

  Padding eventContainer(
      String imageUrl, String name, String price, String lat,String long,String city) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 210,
        width: 200,
        decoration: BoxDecoration(
          color: Color(0xFFEFF5F7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl:imageUrl,
                  height: 150,
                  width: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(
                    color: defaultColor,
                  )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.pin_drop,
                            color: Colors.blueAccent,
                          ),
                          // Image.network('https://cdn-icons-png.flaticon.com/512/1483/1483336.png',
                          // height: 20,
                          //   width: 20,
                          // ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(city)
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(color: Colors.blueAccent),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  int ind=-1;

  ListView buildCategoryContainer(String iconUrl, String text) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: categories.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return  InkWell(
            onTap: (){
              filteredEvents.clear();
              setState(() {
                categoryType=categories[index].text;

                if(ind==index){
                  ind=-1;
                  isFiltered=false;
                }
                else{
                  ind=index;
                  getFilteredList().whenComplete(()  {
                    setState(() {
                      isFiltered=true;

                    });

                  });
                }

              });

            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 40,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color:index==ind?defaultColor: Color(0xFF99BFE0))),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        categories[index].iconUrl,
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(categories[index].text,
                      style: TextStyle(
                        color: Colors.black
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
  void searchEvents(String query) async {

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventName', isGreaterThanOrEqualTo: query)
          .get();

      setState(() {
        filteredEvents.clear();
        filteredEvents = querySnapshot.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Timestamp t = data['date'] as Timestamp;
          DateTime d = t.toDate();

          return EventModel(
            imageUrl: data['image'],
            eventName: data['eventName'],
            city: data['city'],
            price: "Free",
            type: data['type'],
            date: d,
            eventLat: data['eventLat'],
            eventLong: data['eventLong'],
            eventTime: data['eventTime'],
            status: data['status'],
            createdBy: data['createdBy'],
            desc: data["desc"],
            documentId: document.id,
          );
        }).toList();

        print("query is $query");
        print("filtered events length is ${filteredEvents.length}");
        isFiltered=true;
      });
    } catch (e) {
      print("Error searching events: $e");
      // Handle the error as needed
    }
  }


  List<CategoryModel> categories=[
    CategoryModel(iconUrl: 'https://cdn-icons-png.flaticon.com/512/1753/1753311.png', text: "Festivals"),
    CategoryModel(iconUrl: 'https://cdn-icons-png.flaticon.com/512/2071/2071392.png', text: "Educational"),
    CategoryModel(iconUrl: 'https://cdn-icons-png.flaticon.com/512/2402/2402478.png', text: "Webinars"),
    CategoryModel(iconUrl: 'https://cdn-icons-png.flaticon.com/512/3591/3591343.png', text: "Seminars"),
    CategoryModel(iconUrl: 'https://cdn-icons-png.flaticon.com/512/4579/4579333.png', text: "Expo"),
    CategoryModel(iconUrl: 'https://cdn-icons-png.flaticon.com/512/4766/4766734.png', text: "Conferences"),

  ];
}



class CategoryModel{
  String iconUrl;
  String text;
  CategoryModel({required this.iconUrl,required this.text});
}
