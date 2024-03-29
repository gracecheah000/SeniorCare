class Medication {
  String? medicationId;
  String medicationName;
  String medicationImage;
  String medicationFrequency;
  String medicationQuantity;
  String medicationTime;
  String medicationPrescription;
  String? otherDescription;
  String? status;
  String? startDate;
  String? endDate;

  Medication(
      {this.medicationId,
      required this.medicationName,
      required this.medicationImage,
      required this.medicationFrequency,
      required this.medicationQuantity,
      required this.medicationTime,
      required this.medicationPrescription,
      this.otherDescription,
      this.status,
      this.startDate,
      this.endDate});
}
