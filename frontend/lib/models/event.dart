class Event {
  final String id;
  final String title;
  final String description;
  final String organizer;
  final String location;
  final String type;
  final DateTime date;
  final DateTime updatedAt;

  Event(
    this.id,
    this.title,
    this.description,
    this.organizer,
    this.location,
    this.type,
    this.date,
    this.updatedAt,
  );

  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id,
      data['title'],
      data['description'],
      data['organizer'],
      data['location'],
      data['type'],
      DateTime.parse(data['date']),
      DateTime.parse(data['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'organizer': organizer,
      'location': location,
      'date': date,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      json['id'], // Assuming 'id' is also part of the JSON
      json['title'],
      json['description'],
      json['organizer'],
      json['location'],
      json['type'], // Changed 'eventType' to 'type' to match the constructor
      DateTime.parse(json['date']),
      DateTime.parse(json['updatedAt']),
    );
  }
}
