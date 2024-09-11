import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';

class EventFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        return DropdownButton<String>(
          value: eventProvider.currentFilter,
          items:
              ['All', 'Conference', 'Workshop', 'Webinar'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              eventProvider.setFilter(newValue);
            }
          },
        );
      },
    );
  }
}
