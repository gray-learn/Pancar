import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../screens/event_detail_screen.dart';

class EventListItem extends StatelessWidget {
  final Event event;

  EventListItem({required this.event}) {
    print(
        'Event details: ${event.toJson()}'); // Moved print statement inside the constructor body
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          event.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text('Type: ${event.eventType}'),
            Text(
                'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(event.date)}'),
            Text('Location: ${event.location}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
      ),
    );
  }
}
