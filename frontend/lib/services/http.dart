import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class Http {
  // final url = 'http://127.0.0.1:8383/events/'; // For iOS Simulator
  static String url =
      'https://us-central1-pancarinca.cloudfunctions.net/app/events'; // For physical devices
  // static String url = "http://10.0.2.2:8383/events/"; // android
  //  In the context of emulators, localhost refers to the emulator itself, not your development machine.
  // static Dio dio = Dio();
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
      final res = await http.get(Uri.parse(url));
      print('Response status: ${res.statusCode}');
      if (res.statusCode == 200) {
        print('Response body: ${res.body}');
        var data = jsonDecode(res.body);
        // var event = Event.fromJson(data);
        // print('fetch Event: ${event}');
        //  data is an array

        data.forEach((value) => {
              events.add(
                Event(
                  value['id'],
                  value['title'],
                  value['description'],
                  DateTime.parse(value['date']), // Convert DateTime to String
                  value['location'],
                  value['organizer'],
                  value['eventType'],
                  DateTime.parse(
                      value['updatedAt']), // Convert DateTime to String
                ),
              )
            });

        return events;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load eventsFFFFF: ${e.toString()}');
    }
  }

  // Change _parseDate to a static method
  static DateTime _parseDate(dynamic timestamp) {
    // Check if the timestamp is a String and convert it to int
    if (timestamp is String) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      throw Exception('Invalid timestamp format');
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
