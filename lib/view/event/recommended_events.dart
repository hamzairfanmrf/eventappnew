import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';

class RecommendedEvents extends StatefulWidget {
  final String eventType;

  RecommendedEvents({required this.eventType});

  @override
  State<RecommendedEvents> createState() => _RecommendedEventsState();
}

class _RecommendedEventsState extends State<RecommendedEvents> {
  late Stream<QuerySnapshot> eventsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the events stream with filtered events
    eventsStream = FirebaseFirestore.instance
        .collection('events')
        .where('type', isEqualTo: widget.eventType) // Filter events by type
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Events'),
        centerTitle: true,
        backgroundColor: defaultColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator while data is loading
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If data is loaded successfully, display the events
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? eventData =
              document.data() as Map<String, dynamic>?; // Use Map<String, dynamic>?
              if (eventData == null) {
                return SizedBox(); // If eventData is null, return an empty SizedBox
              }
              return eventContainer(eventData['image'], eventData['eventName'], 'free', eventData['eventLat']
                  , eventData['eventLong'], eventData['city']);
            }).toList(),
          );
        },
      ),
    );
  }
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

class EventCard extends StatelessWidget {
  final String name;
  final String description;
  // Add more fields as needed

  EventCard({
    required this.name,
    required this.description,
    // Add more fields as needed
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
