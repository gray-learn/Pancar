import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../screens/create_edit_event_screen.dart';
import '../screens/event_detail_screen.dart';

class EventListItem extends StatelessWidget {
  final Event event;

  EventListItem({required this.event}) {
    print(
        'Event details: ${event.toJson()}'); // Moved print statement inside the constructor body
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider =
        Provider.of<EventProvider>(context); // Get the EventProvider instance
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
            Text('organizer: ${event.organizer}'),
            Text('description: ${event.description}'),
            Container(
              width: MediaQuery.of(context).size.width - 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditEventScreen(
                              event:
                                  event), // Pass event to CreateEditEventScreen
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete this event?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  eventProvider.deleteEvent(int.parse(
                                      event.id)); // Convert String to int
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(event: event),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
