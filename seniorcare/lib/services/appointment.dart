import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seniorcare/models/appointment.dart';
import 'package:seniorcare/services/user_details.dart';

class AppointmentServices {
  static saveAppointments(String elderlyId, Appointment newAppointment) async {
    String appointmentId = '';

    await FirebaseFirestore.instance.collection('appointment').add({
      'name': newAppointment.eventTitle,
      'date': newAppointment.eventDate,
      'time': newAppointment.eventTime,
      'location': newAppointment.eventLocation,
      'require fasting': newAppointment.eventRequireFasting,
      'description': newAppointment.eventDescription,
      'notes': []
    }).then((success) {
      appointmentId = success.id;
    }).catchError((e) {
      return e;
    });

    var result = await UserDetails.addNewAppointment(elderlyId, appointmentId);
    if (result == true) {
      return true;
    } else {
      return result;
    }
  }

  static getAppointment(String appointmentId) async {
    DocumentSnapshot details = await FirebaseFirestore.instance
        .collection('appointment')
        .doc(appointmentId)
        .get();

    return details.data();
  }

  static deleteAppointment(String appointmentId, String elderlyId) async {
    await FirebaseFirestore.instance
        .collection('appointment')
        .doc(appointmentId)
        .delete()
        .catchError((e) {
      return e;
    });

    var result =
        await UserDetails.deleteElderlyAppointment(elderlyId, appointmentId);
    if (result == true) {
      return true;
    } else {
      return result;
    }
  }
}
