import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:seniorcare/services/user_details.dart';

class LocationServices {
  static updateLocation(String userEmail, LocationData currentLocation) async {
    String userId = await UserDetails.getUserId(userEmail);
    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude
    });
  }
}
