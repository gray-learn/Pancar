class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date; // Changed to String to match the expected type
  final String location;
  final String organizer;
  final String eventType;
  final DateTime updatedAt; // Changed to String to match the expected type

  Event(this.id, this.title, this.description, this.date, this.location,
      this.organizer, this.eventType, this.updatedAt);

  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id,
      data['title'],
      data['description'],
      data['date'],
      data['location'],
      data['organizer'],
      data['eventType'],
      data['updatedAt'], // Changed to pass String instead of DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'organizer': organizer,
      'eventType': eventType,
      'updatedAt': updatedAt,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      json['id'], // Assuming 'id' is also part of the JSON
      json['title'],
      json['description'],
      json['date'],
      json['location'],
      json['organizer'],
      json['eventType'],
      json['updatedAt'], // Changed to pass String instead of DateTime
    );
  }
}
