class Event {
  final String title;
  final String description;
  final String organizer;
  final String location;
  final String eventType;
  final DateTime date;
  final DateTime updatedAt;

  Event(
    this.title,
    this.description,
    this.organizer,
    this.location,
    this.eventType,
    this.date,
    this.updatedAt,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'organizer': organizer,
      'location': location,
      'date': date.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
