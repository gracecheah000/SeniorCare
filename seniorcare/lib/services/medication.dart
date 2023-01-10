import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seniorcare/models/medication.dart';
import 'package:seniorcare/services/user_details.dart';

class MedicationServices {
  static saveMedication(String elderlyId, Medication medication) async {
    String medicationId = '';

    await FirebaseFirestore.instance.collection("medication").add({
      'name': medication.medicationName,
      'frequency': medication.medicationFrequency,
      'quantity': medication.medicationQuantity,
      'timing': medication.medicationTime,
      'image': medication.medicationImage,
      'prescription': medication.medicationPrescription,
      'other details': medication.otherDescription
    }).then((value) {
      medicationId = value.id;
    }).catchError((error) {
      return error;
    });

    await UserDetails.addElderlyMedication(elderlyId, medicationId)
        .then((success) {
      return true;
    }).catchError((error) {
      return error;
    });
  }

  static getMedicationDetails(String medicationId) async {
    DocumentSnapshot details = await FirebaseFirestore.instance
        .collection('medication')
        .doc(medicationId)
        .get();

    return details.data();
  }

  static deleteMedication(String elderlyId, String medicationId) async {
    await FirebaseFirestore.instance
        .collection('medication')
        .doc(medicationId)
        .delete()
        .catchError((e) {
      return e;
    });

    var result =
        await UserDetails.deleteElderlyMedication(elderlyId, medicationId);

    if (result == true) {
      return true;
    } else {
      return result;
    }
  }
}
