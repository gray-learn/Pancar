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
        print('fetch data: ' + jsonEncode(data));
        var event = Event(
          data['title'],
          data['description'],
          data['organizer'],
          data['location'],
          data['eventType'],
          DateTime.parse(data['date']),
          DateTime.parse(data['updatedAt']),
        );
        // jsonData.map((eventData) => Event.fromJson(eventData)).toList();

        print('Event: ${event}');
        events.add(event);
        // data['product'].forEach((value) => {
        //       product.add(
        //         Product(
        //           value['name'],
        //           value['price'],
        //           value['desc'],
        //         ),
        //       )
        //     });
        return events;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load events: ${e.toString()}');
    }
  }
}
