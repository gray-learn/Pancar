import 'package:flutter/material.dart';
import '../models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${event.eventType}'),
            Text('Date: ${event.date}'),
            Text('Description: ${event.description}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Edit Event Screen
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
