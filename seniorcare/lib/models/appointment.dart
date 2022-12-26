class Appointment {
  String eventTitle;
  DateTime eventDate;
  String eventLocation;
  String? eventRequireFasting;
  String eventTime;
  String? eventDescription;

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
