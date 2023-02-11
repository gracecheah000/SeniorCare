class Appointment {
  String? eventId;
  int? notificationId;
  String eventTitle;
  DateTime eventDateTime;
  String eventTime;
  String eventLocation;
  String? eventRequireFasting;
  String? eventDescription;

  Appointment({
    this.eventId,
    this.notificationId,
    required this.eventTitle,
    required this.eventDateTime,
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
          other.eventDateTime == eventDateTime &&
          other.eventTime == eventTime &&
          other.eventLocation == eventLocation &&
          other.eventRequireFasting == eventRequireFasting &&
          other.eventDescription == eventDescription;

  @override
  int get hashCode =>
      eventTitle.hashCode ^
      eventDateTime.hashCode ^
      eventTime.hashCode ^
      eventLocation.hashCode ^
      eventRequireFasting.hashCode ^
      eventDescription.hashCode;
}
