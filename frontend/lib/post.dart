import 'package:flutter/material.dart';

// import 'package:intl/intl.dart'; // For formatting Date
import 'models/event.dart';
import 'services/http.dart';

class POST extends StatefulWidget {
  const POST({super.key});

  @override
  State<POST> createState() => _POSTState();
}

TextEditingController name = TextEditingController();
TextEditingController price = TextEditingController();
TextEditingController desc = TextEditingController();

class _POSTState extends State<POST> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController organizer = TextEditingController();
  TextEditingController location = TextEditingController();
  DateTime? selectedDate;
  DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              TextField(
                controller: title,
                decoration: const InputDecoration(label: Text("Event Title")),
              ),
              const SizedBox(height: 20),

              // Description
              TextField(
                controller: description,
                decoration:
                    const InputDecoration(label: Text("Event Description")),
              ),
              const SizedBox(height: 20),

              // Organizer
              TextField(
                controller: organizer,
                decoration: const InputDecoration(label: Text("Organizer")),
              ),
              const SizedBox(height: 20),

              // Location
              TextField(
                controller: location,
                decoration: const InputDecoration(label: Text("Location")),
              ),
              const SizedBox(height: 20),

              // Event Date (Date Picker)
              Row(
                children: [
                  Text("Select Event Date"
                      // selectedDate == null
                      //   ? "Select Event Date"
                      //   : DateFormat.yMd().format(selectedDate!)
                      ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                  onPressed: () {
                    if (selectedDate != null) {
                      updatedAt = DateTime.now();

                      // Create an Event object
                      Event event = Event(
                        DateTime.now()
                            .toString(), // Assuming a new ID is generated as a string
                        title.text,
                        description.text,
                        selectedDate!,
                        location.text,
                        organizer.text,
                        "Conference", // Assuming a default eventType
                        updatedAt!, // Current time as updated time
                      );

                      // Convert event to JSON and post it
                      var data = event.toJson();
                      Http.postEvent(
                          data); // Implement the HTTP POST logic here

                      print(data); // For debugging
                    } else {
                      // Show an error if the date is not selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a date.')),
                      );
                    }
                  },
                  child: const Text("SEND")),
            ],
          ),
        ),
      ),
    );
  }
}
