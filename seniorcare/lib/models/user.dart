class Caregiver {
  String? email;
  String? password;
  String? name;
  String? emergencyContact;
  List? elderly;

  Caregiver({this.email, this.password, this.name, this.emergencyContact});
}

class Elderly {
  String? email;
  String? password;
  String? name;
  String? age;
  String? sex;
  String? address;
  List? caregivers;
  List? healthRisks;
  String? additionalDetails;

  Elderly(
      {this.email,
      this.password,
      this.name,
      this.age,
      this.sex,
      this.address,
      this.caregivers,
      this.healthRisks,
      this.additionalDetails});
}
