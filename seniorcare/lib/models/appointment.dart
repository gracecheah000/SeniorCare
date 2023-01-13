class Appointment {
  String? eventId;
  String eventTitle;
  DateTime eventDate;
  String eventTime;
  String eventLocation;
  String? eventRequireFasting;
  String? eventDescription;

  Appointment({
    this.eventId,
    required this.eventTitle,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventRequireFasting,
    this.eventDescription,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Appointment &&
          other.runtimeType == runtimeType &&
          other.eventTitle == eventTitle &&
          other.eventDate == eventDate &&
          other.eventTime == eventTime &&
          other.eventLocation == eventLocation &&
          other.eventRequireFasting == eventRequireFasting &&
          other.eventDescription == eventDescription;

  @override
  int get hashCode =>
      eventTitle.hashCode ^
      eventDate.hashCode ^
      eventTime.hashCode ^
      eventLocation.hashCode ^
      eventRequireFasting.hashCode ^
      eventDescription.hashCode;
}
