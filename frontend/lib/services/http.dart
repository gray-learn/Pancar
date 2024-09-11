import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class Http {
  // final url = 'http://127.0.0.1:8383/events/'; // For iOS Simulator
  // final url = 'http://192.168.x.x:8383/events/'; // For physical devices
  static String url = "http://10.0.2.2:8383/events/"; // android
  //  In the context of emulators, localhost refers to the emulator itself, not your development machine.

  static postEvent(Map pdata) async {
    try {
      print(url); // /events/addEvent
      final res = await http.post(Uri.parse("${url}addEvent"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(pdata));

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static getEvent() async {
    List<Event> events = [];
    try {
      // final res = await http.get(Uri.parse("${url}get_product"));
      final res = await http.get(Uri.parse("${url}"));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        var event = Event.fromJson(data);
        print('fetch Event: ${event}');
        events.add(event);
        return events;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load events: ${e.toString()}');
    }
  }

  // Update (PUT)
  static updateEvent(int id, Map<String, dynamic> pdata) async {
    try {
      final res = await http.put(
        Uri.parse("${url}updateEvent/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pdata),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print("Updated event: $data");
      } else {
        print("Failed to update event");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete (DELETE)
  static deleteEvent(int id) async {
    try {
      final res = await http.delete(Uri.parse("${url}deleteEvent/$id"),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode == 200) {
        print("Deleted event with id: $id");
      } else {
        print("Failed to delete event");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
