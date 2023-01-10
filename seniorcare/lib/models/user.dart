class Caregiver {
  String? email;
  String? password;
  String? name;
  String? emergencyContact;
  List? elderly;

  Caregiver({this.email, this.password, this.name, this.emergencyContact});
}

class Elderly {
  String? id;
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
      {this.id,
      this.email,
      this.password,
      this.name,
      this.age,
      this.sex,
      this.address,
      this.caregivers,
      this.healthRisks,
      this.additionalDetails});

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
