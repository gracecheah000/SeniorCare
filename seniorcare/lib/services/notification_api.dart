// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/services/appointment.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final onMedicationNotifications =
      BehaviorSubject<String?>(); // stream of medication notifications
  static final onAppointmentNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('Seniorcare', 'Seniorcare',
            channelDescription: 'Seniorcare notifications',
            importance: Importance.max,
            playSound: true));
  }

  static Future init({bool initScheduled = false}) async {
    // request for permission
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    // set app icon
    const android = AndroidInitializationSettings('app_icon');
    const settings = InitializationSettings(android: android);

    // for when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      if (details.notificationResponse!.payload!.contains('Medication')) {
        onMedicationNotifications.add(details.notificationResponse!.payload);
      } else {
        onAppointmentNotifications.add(details.notificationResponse!.payload);
      }
    }

    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async {
      if (payload.payload!.contains('Medication')) {
        onMedicationNotifications.add(payload.payload);
      } else {
        onAppointmentNotifications.add(payload.payload);
      }
    });

    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

  // for appointment
  static Future createScheduledNotification(
      {String? title,
      String? body,
      String? payload,
      required bool caregiver,
      required String userId,
      required String appointmentId,
      required DateTime scheduledDate}) async {
    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    AppointmentServices.updateAppointmentNotificationId(
        appointmentId, id, caregiver);
  }

  // for daily medication
  static Future createRepeatedNotification(
      {int id = 0,
      required String userId,
      required String frequency,
      required String title,
      required String body,
      required payload,
      required List<String> mealTimings}) async {
    List notification = await UserDetails.getNotifications(userId);
    switch (frequency) {
      case 'Every morning':
        {
          if (notification[0] == 0) {
            int hour = DateFormat("HH:mm").parse(mealTimings[0]).hour;
            int min = DateFormat("HH:mm").parse(mealTimings[0]).minute;

            _notifications.zonedSchedule(Constants.morningNotificationId, title,
                body, _scheduleDaily(hour, min), await _notificationDetails(),
                payload: payload,
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
                matchDateTimeComponents: DateTimeComponents.time);
          }

          await UserDetails.addNumberOfNotifications(userId, [1, 0, 0]);
        }
        break;
      case 'Every night':
        {
          if (notification[2] == 0) {
            int hour = DateFormat("HH:mm").parse(mealTimings[2]).hour;
            int min = DateFormat("HH:mm").parse(mealTimings[2]).minute;

            _notifications.zonedSchedule(Constants.nightNotificationId, title,
                body, _scheduleDaily(hour, min), await _notificationDetails(),
                payload: payload,
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
                matchDateTimeComponents: DateTimeComponents.time);
          }
          await UserDetails.addNumberOfNotifications(userId, [0, 0, 1]);
        }
        break;
      case 'Twice a day':
        {
          if (notification[0] == 0) {
            int hour = DateFormat("HH:mm").parse(mealTimings[0]).hour;
            int min = DateFormat("HH:mm").parse(mealTimings[0]).minute;

            _notifications.zonedSchedule(Constants.morningNotificationId, title,
                body, _scheduleDaily(hour, min), await _notificationDetails(),
                payload: payload,
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
                matchDateTimeComponents: DateTimeComponents.time);
          }

          if (notification[2] == 0) {
            int hour = DateFormat("HH:mm").parse(mealTimings[2]).hour;
            int min = DateFormat("HH:mm").parse(mealTimings[2]).minute;

            _notifications.zonedSchedule(Constants.nightNotificationId, title,
                body, _scheduleDaily(hour, min), await _notificationDetails(),
                payload: payload,
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
                matchDateTimeComponents: DateTimeComponents.time);
          }
          await UserDetails.addNumberOfNotifications(userId, [1, 0, 1]);
        }
        break;
      case '3 times a day':
        {
          for (int i = 0; i < 3; i++) {
            if (notification[i] == 0) {
              int hour = DateFormat("HH:mm").parse(mealTimings[i]).hour;
              int min = DateFormat("HH:mm").parse(mealTimings[i]).minute;

              _notifications.zonedSchedule(i, title, body,
                  _scheduleDaily(hour, min), await _notificationDetails(),
                  payload: payload,
                  androidAllowWhileIdle: true,
                  uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime,
                  matchDateTimeComponents: DateTimeComponents.time);
            }
          }
          await UserDetails.addNumberOfNotifications(userId, [1, 1, 1]);
        }
        break;
    }
  }

  static tz.TZDateTime _scheduleDaily(int hour, int minutes) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static Future<void> cancelMedicationNotification(
      String userId, String frequency) async {
    List notification = await UserDetails.getNotifications(userId);

    switch (frequency) {
      case 'Every morning':
        {
          if (notification[0] == 1) {
            await _notifications.cancel(Constants.morningNotificationId);
          }

          await UserDetails.deleteNumberOfNotifications(userId, [1, 0, 0]);
        }
        break;
      case 'Every night':
        {
          if (notification[2] == 1) {
            await _notifications.cancel(Constants.nightNotificationId);
          }

          await UserDetails.deleteNumberOfNotifications(userId, [0, 0, 1]);
        }
        break;
      case 'Twice a day':
        {
          if (notification[0] == 1) {
            await _notifications.cancel(Constants.morningNotificationId);
          } else if (notification[2] == 1) {
            await _notifications.cancel(Constants.nightNotificationId);
          }

          await UserDetails.deleteNumberOfNotifications(userId, [1, 0, 1]);
        }
        break;
      case '3 times a day':
        {
          if (notification[0] == 1) {
            await _notifications.cancel(Constants.morningNotificationId);
          } else if (notification[1] == 1) {
            await _notifications.cancel(Constants.afternoonNotificationId);
          } else if (notification[2] == 1) {
            await _notifications.cancel(Constants.nightNotificationId);
          }
          await UserDetails.deleteNumberOfNotifications(userId, [1, 1, 1]);
        }
        break;
    }
  }

  static Future<void> cancelAppointmentNotifications(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAll() => _notifications.cancelAll();
}
