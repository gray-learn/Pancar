import 'package:flutter/foundation.dart';
import '../models/event.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../services/http.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  String _currentFilter = 'All';

  List<Event> get events {
    if (_currentFilter == 'All') {
      return _events;
    } else {
      final filteredEvents =
          _events.where((event) => event.eventType == _currentFilter).toList();
      if (filteredEvents.isEmpty) {
        print(
            'There is no event matching the selected type.'); // Show message if no match
      }
      return filteredEvents;
    }
  }

  String get currentFilter => _currentFilter;

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    try {
      List<Event> events = await Http.getEvent();

      _events = events; // Update the _events list
      notifyListeners(); // Notify listeners after updating
    } catch (e) {
      throw Exception('Failed to load events: ${e.toString()}');
    }
  }

  Future<void> addEvent(Event event) async {
    await Http.postEvent(event.toJson());
    await fetchEvents();
  }

  Future<void> updateEvent(Event event) async {
    await Http.updateEvent(int.parse(event.id), event.toJson());
    await fetchEvents();
  }

  Future<void> deleteEvent(int id) async {
    await Http.deleteEvent(id);
    await fetchEvents();
  }
}
