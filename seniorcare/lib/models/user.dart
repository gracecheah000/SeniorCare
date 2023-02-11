class Caregiver {
  String? email;
  String? password;
  String? name;
  String? emergencyContact;
  List? elderly;
  String? registrationToken;

  Caregiver(
      {this.email,
      this.password,
      this.name,
      this.emergencyContact,
      this.registrationToken});
}

class Elderly {
  String? id;
  String? email;
  String? name;
  String? age;
  String? sex;
  String? address;
  String? pin;
  List? caregivers;
  List? healthRisks;
  String? additionalDetails;
  String? registrationToken;
  List? mealTimings;

  Elderly(
      {this.id,
      this.email,
      this.name,
      this.age,
      this.sex,
      this.address,
      this.caregivers,
      this.healthRisks,
      this.additionalDetails,
      this.registrationToken,
      this.mealTimings,
      this.pin});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Elderly &&
        other.email == email &&
        other.id == id &&
        other.name == other.name;
  }

  @override
  int get hashCode => email.hashCode ^ id.hashCode ^ name.hashCode;
}
