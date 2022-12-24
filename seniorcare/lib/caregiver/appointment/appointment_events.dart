class Appointment {
  final String eventTitle;
  final DateTime eventDate;
  final String eventLocation;
  final String? eventRequireFasting;
  final String eventTime;
  final String? eventDescription;

  Appointment(
      {required this.eventTitle,
      required this.eventDate,
      required this.eventLocation,
      this.eventRequireFasting,
      required this.eventTime,
      this.eventDescription});

  @override
  String toString() => eventTitle;
}
