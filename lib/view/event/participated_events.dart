import 'package:eventappnew/constants/constants.dart';
import 'package:eventappnew/view_model/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/event_model.dart';

class ParticipatedEvents extends StatefulWidget {
  const ParticipatedEvents({super.key});

  @override
  State<ParticipatedEvents> createState() => _ParticipatedEventsState();
}

class _ParticipatedEventsState extends State<ParticipatedEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participated'),
        centerTitle: true,
        backgroundColor: defaultColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 8 / 11, // Adjust the aspect ratio as needed
            ),
            itemCount: context.watch<EventProvider>().particitpatedEvents.length,
            itemBuilder: (BuildContext context, int index) {
              return buildEventCard(context.watch<EventProvider>().particitpatedEvents[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget buildEventCard(EventModel event) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              height: 120.0, // Adjust the height as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Type ${event.eventName}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Event City ${event.city}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Event Price ${event.price}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

