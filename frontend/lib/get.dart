import 'package:flutter/material.dart';
import 'package:frontend/providers/event_provider.dart';

import 'models/event.dart';
import 'dart:convert';
import 'services/http.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart'; // Add this import

class GET extends StatelessWidget {
  const GET({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GET data")),
      body: FutureBuilder(
        future: Http.getEvent(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Event> events = snapshot.data;
            return ListView.builder(
              itemCount: events.length, // 'events' is the list of Event objects
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.event), // Use an event-related icon
                  title: Text(events[index].title), // Display the event title
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(events[index]
                          .description), // Display the event description
                      Text(
                          'Location: ${events[index].location}'), // Display the event location
                      Text(
                          'Organizer: ${events[index].organizer}'), // Display the event organizer
                    ],
                  ),
                  trailing: Text(
                    'Date: ${events[index].date.toLocal().toString().split(' ')[0]}', // Display event date (formatted)
                    style: TextStyle(fontSize: 12), // Format date text
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
