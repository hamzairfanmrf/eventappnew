import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventappnew/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../view/authentication/login.dart';
import '../view_model/event_provider.dart';
import 'delete_users.dart';


class ApproveEvents extends StatefulWidget {
  const ApproveEvents({super.key});

  @override
  State<ApproveEvents> createState() => _ApproveEventsState();
}

class _ApproveEventsState extends State<ApproveEvents> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
   drawer: Drawer(
     child: ListView(
       padding: EdgeInsets.zero,
       children: [
         DrawerHeader(
           decoration: BoxDecoration(
             color: defaultColor,
           ),
           child: Text(
             'Admin',
             style: TextStyle(color: Colors.white, fontSize: 24),
           ),
         ),
         ListTile(
           leading: Icon(Icons.people),
           title: Text('Users'),
           onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => ShowAllUsers()),
             );
           },
         ),
         ListTile(
           leading: Icon(Icons.logout),
           title: Text('Logout'),
           onTap: () async {
             await FirebaseAuth.instance.signOut();
             Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => LoginForm()),
             );
           },
         ),
         ListTile(
           leading: Icon(Icons.thumb_up),
           title: Text('Approve Events'),
           onTap: () {
             // Do nothing as you are already on the 'Approve Events' screen
             Navigator.pop(context); // Close the drawer
           },
         ),
       ],
     ),
   ),
      appBar: AppBar(
        title: Text("Approve events"),
        backgroundColor: defaultColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child:SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 16/19
                  ),
                  itemCount: context.watch<EventProvider>().getAllEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Alert",
                          desc: "Do you wanna delete or accept the event",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance.collection('events')
                                    .doc(context.watch<EventProvider>().getAllEvents[index].documentId)
                                    .update({
                                  "status":"approve"
                                });
                              },
                              color: Color.fromRGBO(0, 179, 134, 1.0),
                            ),
                            DialogButton(
                              child: Text(
                                "GRADIENT",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance.collection('events')
                                    .doc(context.watch<EventProvider>().getAllEvents[index].documentId)
                                    .update({
                                  "status":"reject"
                                });
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ]),
                            )
                          ],
                        ).show();

                      },
                      child: Card(
                        // color: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(context.watch<EventProvider>().getAllEvents[index].imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(context.watch<EventProvider>().getAllEvents[index].eventName),
                            Text(context.watch<EventProvider>().getAllEvents[index].city),
                            Text(context.watch<EventProvider>().getAllEvents[index].price),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
