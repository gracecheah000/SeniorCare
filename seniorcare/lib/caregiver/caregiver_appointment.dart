// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_conditional_assignment, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/caregiver/notes/notes_edit.dart';
import 'package:seniorcare/const.dart';
import 'package:seniorcare/models/appointment.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/appointment.dart';
import 'package:seniorcare/services/notification_api.dart';
import 'package:seniorcare/services/server_api.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:seniorcare/widgets/custom_text_field.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CaregiverAppointment extends StatefulWidget {
  const CaregiverAppointment({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<CaregiverAppointment> createState() => _CaregiverAppointmentState();
}

class _CaregiverAppointmentState extends State<CaregiverAppointment> {
  DateTime _focusedCalendarDate = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  String? userId;

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final reminderTimeController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  bool requireFasting = false;

  Elderly? selectedElderly;
  int elderlyIndex = 0;

  Map<DateTime, List<Appointment>>? mySelectedEvents = {};

  List<Appointment> _listOfDayEvents(DateTime dateTime) {
    return mySelectedEvents![dateTime] ?? [];
  }

  @override
  void initState() {
    _selectedDay = _focusedCalendarDate;
    titleController.text = '';
    timeController.text = '';
    reminderTimeController.text = '';
    locationController.text = '';
    descriptionController.text = '';
    requireFasting = false;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    timeController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    reminderTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic> caregiverElderlyList = getElderlyList();
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: FutureBuilder(
            future: caregiverElderlyList,
            builder: (((context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data.isEmpty) {
                return const Center(
                    child: Text('No elderly has been added',
                        style: TextStyle(fontWeight: FontWeight.bold)));
              } else {
                List<Elderly> elderlyList = snapshot.data[1];

                userId = snapshot.data[0];

                if (selectedElderly == null) {
                  selectedElderly = elderlyList[0];
                }
                return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(35, 10, 0, 0),
                          height: size.height * 0.07,
                          width: size.width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(108, 99, 255, 1),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: DropdownButton<Elderly>(
                                  isExpanded: true,
                                  value: selectedElderly,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(108, 99, 255, 1),
                                      fontFamily: 'Montserrat',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                  onChanged: (Elderly? value) {
                                    setState(() {
                                      selectedElderly = value;
                                      elderlyIndex = elderlyList
                                          .indexOf(selectedElderly as Elderly);
                                    });
                                  },
                                  items: elderlyList.map((Elderly elderly) {
                                    return DropdownMenuItem<Elderly>(
                                        value: elderly,
                                        child: Text(elderly.name
                                            .toString()
                                            .toUpperCase()));
                                  }).toList(),
                                  underline: Container(),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color:
                                          Color.fromRGBO(108, 99, 255, 1))))),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user')
                              .doc(selectedElderly!.id)
                              .snapshots(),
                          builder: (((context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 29, 77, 145));
                            } else {
                              List appointmentIdList =
                                  snapshot.data!.data()!['appointment'];

                              Future<dynamic> appointments =
                                  getElderlyAppointment(appointmentIdList);

                              return FutureBuilder(
                                  future: appointments,
                                  builder: ((context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      mySelectedEvents = {};

                                      for (Appointment appointment
                                          in snapshot.data) {
                                        if (mySelectedEvents![
                                                appointment.eventDateTime] ==
                                            null) {
                                          mySelectedEvents![appointment
                                              .eventDateTime] = [appointment];
                                        } else if (!mySelectedEvents![
                                                appointment.eventDateTime]!
                                            .contains(appointment)) {
                                          mySelectedEvents![
                                                  appointment.eventDateTime]!
                                              .add(appointment);
                                        }
                                      }
                                    }
                                    return Column(children: <Widget>[
                                      Card(
                                          margin: EdgeInsets.fromLTRB(
                                              size.width * 0.02,
                                              size.height * 0.03,
                                              size.width * 0.02,
                                              size.height * 0.01),
                                          elevation: 5.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      108, 99, 255, 1))),
                                          child: TableCalendar(
                                              firstDay:
                                                  DateTime.utc(2010, 1, 1),
                                              focusedDay:
                                                  _focusedCalendarDate, // today's date
                                              lastDay: DateTime.utc(
                                                  2100, 12, 31), // latest allowed date
                                              calendarFormat: _calendarFormat,
                                              startingDayOfWeek:
                                                  StartingDayOfWeek.monday,
                                              daysOfWeekHeight:
                                                  size.height * 0.05,
                                              rowHeight: size.height * 0.06,
                                              daysOfWeekStyle: const DaysOfWeekStyle(
                                                  weekendStyle: TextStyle(
                                                      color:
                                                          Colors.deepPurple)),
                                              calendarStyle: const CalendarStyle(
                                                  weekendTextStyle: TextStyle(color: Colors.deepPurple),
                                                  markerDecoration: BoxDecoration(color: Color.fromARGB(255, 248, 134, 114), shape: BoxShape.circle),
                                                  todayDecoration: BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 144, 139, 192)),
                                                  selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 46, 38, 121))),
                                              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                                              selectedDayPredicate: (currentSelectedDate) {
                                                return (isSameDay(_selectedDay,
                                                    currentSelectedDate));
                                              },
                                              onDaySelected: (selectedDay, focusedDay) {
                                                if (!isSameDay(_selectedDay,
                                                    selectedDay)) {
                                                  setState(() {
                                                    _selectedDay = selectedDay;
                                                    _focusedCalendarDate =
                                                        focusedDay;
                                                  });
                                                }
                                              },
                                              onPageChanged: (date) {
                                                _focusedCalendarDate = date;
                                              },
                                              eventLoader: _listOfDayEvents)),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.04,
                                              top: size.height * 0.01,
                                              bottom: size.height * 0.0005),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color.fromRGBO(
                                                                108, 99, 255, 1))),
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 5,
                                                                horizontal: 5),
                                                        child: Text(
                                                            DateFormat('dd MMMM')
                                                                .format(
                                                                    _selectedDay),
                                                            style: TextStyle(
                                                                color:
                                                                    Color.fromRGBO(108, 99, 255, 1),
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold))))
                                              ])),
                                      ..._listOfDayEvents(_selectedDay).map(
                                          (appointment) => ListTile(
                                              contentPadding: EdgeInsets.only(
                                                  left: size.width * 0.05,
                                                  right: 0),
                                              leading: Text(
                                                appointment.eventTime,
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 29, 77, 145),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              title: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: size.height * 0.013),
                                                  child: Text(
                                                      appointment.eventTitle,
                                                      style: TextStyle(
                                                          color: const Color.fromARGB(
                                                              255, 29, 77, 145),
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              subtitle:
                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                                                      Widget>[
                                                Text(
                                                    'Location: ${appointment.eventLocation}',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 104, 114, 158),
                                                        fontSize: 13)),
                                                appointment.eventRequireFasting ==
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 0))
                                                    : Text(
                                                        '${appointment.eventRequireFasting}',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    114,
                                                                    158),
                                                            fontSize: 13)),
                                                (appointment.eventDescription ==
                                                        "")
                                                    ? Text('Other Details: -',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    114,
                                                                    158),
                                                            fontSize: 13))
                                                    : Text(
                                                        'Other Details: ${appointment.eventDescription}',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    104,
                                                                    114,
                                                                    158),
                                                            fontSize: 13))
                                              ]),
                                              trailing: SizedBox(
                                                  width: size.width * 0.28,
                                                  child: Row(children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          var result = await AppointmentServices
                                                              .deleteAppointment(
                                                                  appointment
                                                                      .eventId
                                                                      .toString(),
                                                                  selectedElderly!
                                                                      .id
                                                                      .toString());

                                                          if (result != true) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(SnackBar(
                                                                    content: Text(
                                                                        'Please try again'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            2)));
                                                          }
                                                          ServerApi.deleteAppointmentPush(
                                                              appointment,
                                                              selectedElderly!
                                                                  .registrationToken!);

                                                          NotificationServices
                                                              .cancelAppointmentNotifications(
                                                                  appointment
                                                                      .notificationId!);
                                                        },
                                                        splashRadius: 15,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        icon: Icon(Icons.delete,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                104,
                                                                114,
                                                                158))),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => NoteEdit(
                                                                  title: appointment
                                                                      .eventTitle,
                                                                  tag: DateFormat(
                                                                          "yyyy-MM-dd")
                                                                      .format(appointment
                                                                          .eventDateTime),
                                                                  appointmentId:
                                                                      appointment
                                                                          .eventId,
                                                                  elderlyId:
                                                                      selectedElderly!
                                                                          .id
                                                                          .toString())));
                                                        },
                                                        splashRadius: 15,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        icon: Icon(
                                                            Icons.note_add,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                104,
                                                                114,
                                                                158)))
                                                  ])))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: size.height * 0.05))
                                    ]);
                                  }));
                            }
                          })))
                    ]));
              }
            }))),
        floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              _showAddAppointmentDialog(userId.toString());
            },
            backgroundColor: Color.fromARGB(99, 160, 171, 221),
            heroTag: "AddAppointment",
            child: Image.asset('assets/images/add.png')));
  }

  _showAddAppointmentDialog(String userId) async {
    DateTime parsedDateTime = DateTime.now();
    DateTime reminderDateTime = DateTime.now();

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                scrollable: true,
                backgroundColor: Color.fromARGB(255, 247, 249, 250),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('New Appointment',
                              style: TextStyle(
                                  color: Color.fromRGBO(108, 99, 255, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                              onPressed: () {
                                titleController.clear();
                                timeController.clear();
                                locationController.clear();
                                requireFasting = false;
                                descriptionController.clear();
                                Navigator.pop(context);
                              },
                              icon: Image.asset('assets/images/close.png',
                                  scale: 20),
                              iconSize: 20)
                        ]),
                    Divider(color: Color.fromRGBO(108, 99, 255, 1)),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    customTextField(hint: 'Title', controller: titleController),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(108, 99, 255, 1)),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(108, 99, 255, 1)),
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Time',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(108, 99, 255, 1))),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                              initialEntryMode: TimePickerEntryMode.inputOnly);

                          if (pickedTime != null) {
                            parsedDateTime = DateTime(
                                _selectedDay.year,
                                _selectedDay.month,
                                _selectedDay.day,
                                pickedTime.hour,
                                pickedTime.minute);
                            String formattedTime =
                                DateFormat("h:mma").format(parsedDateTime);

                            setState(() {
                              timeController.text = formattedTime;
                            });
                          }
                        }),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    TextField(
                        controller: reminderTimeController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(108, 99, 255, 1)),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(108, 99, 255, 1)),
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Reminder Time',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(108, 99, 255, 1))),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                              initialEntryMode: TimePickerEntryMode.inputOnly);

                          if (pickedTime != null) {
                            reminderDateTime = DateTime(
                                _selectedDay.year,
                                _selectedDay.month,
                                _selectedDay.day,
                                pickedTime.hour,
                                pickedTime.minute);
                            String formattedTime =
                                DateFormat("h:mma").format(reminderDateTime);

                            setState(() {
                              reminderTimeController.text = formattedTime;
                            });
                          }
                        }),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    customTextField(
                        hint: 'Location', controller: locationController),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    customTextField(
                        hint: 'Other Details',
                        controller: descriptionController),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    CheckboxListTile(
                        activeColor: Color.fromRGBO(108, 99, 255, 1),
                        value: requireFasting,
                        onChanged: (value) {
                          setState(() {
                            requireFasting = value!;
                          });
                        },
                        title: Text("Require Fasting?",
                            style: TextStyle(
                                color: Color.fromRGBO(108, 99, 255, 1))))
                  ]);
                }),
                actions: [
                  TextButton(
                      onPressed: () async {
                        if (titleController.text.isEmpty &&
                            timeController.text.isEmpty &&
                            locationController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Please fill up title, time and location of appointment'),
                              duration: Duration(seconds: 2)));
                          return;
                        } else {
                          Appointment newAppointment = Appointment(
                              eventTitle: titleController.text,
                              eventDateTime: parsedDateTime,
                              eventTime: timeController.text,
                              reminderTime: reminderDateTime,
                              eventLocation: locationController.text,
                              eventRequireFasting:
                                  requireFasting ? "Require Fasting" : null,
                              eventDescription: descriptionController.text);
                          String appointmentId =
                              await AppointmentServices.saveAppointments(
                                  selectedElderly!.id.toString(),
                                  newAppointment);

                          ServerApi.sendAddAppointmentPush(
                              newAppointment,
                              selectedElderly!.registrationToken!,
                              appointmentId);

                          NotificationServices.createScheduledNotification(
                              userId: userId,
                              appointmentId: appointmentId,
                              title: Constants.apptNotificationTitle,
                              body: Constants.apptNotificationBody,
                              payload: 'Appointment',
                              scheduledDate: reminderDateTime);

                          titleController.clear();
                          timeController.clear();
                          reminderTimeController.clear();
                          locationController.clear();
                          requireFasting = false;
                          descriptionController.clear();

                          Navigator.pop(context);
                          return;
                        }
                      },
                      child: const Text('Add',
                          style: TextStyle(
                              color: Color.fromRGBO(108, 99, 255, 1),
                              fontSize: 18)))
                ]));
  }

  getElderlyList() async {
    List details = await UserDetails.getUserDetailsWithEmail(widget.userEmail);
    List<dynamic> elderlyList = details[1]['elderly'];
    String userId = details[0];

    List<Elderly> elderlyDetails = [];

    for (var element in elderlyList) {
      Map details = await UserDetails.getUserDetailsWithId(element);
      Elderly elderly = Elderly(
          email: details['email'],
          name: details['name'],
          id: element,
          registrationToken: details['deviceToken']);
      elderlyDetails.add(elderly);
    }

    return [userId, elderlyDetails];
  }

  getElderlyAppointment(List appointmentIdList) async {
    List<Appointment> appointmentList = [];

    if (appointmentIdList.isNotEmpty) {
      for (String id in appointmentIdList) {
        Map appointmentDetails = await AppointmentServices.getAppointment(id);

        Appointment newAppointment = Appointment(
            eventId: id,
            notificationId: appointmentDetails['notification Id'],
            eventTitle: appointmentDetails['name'],
            eventDateTime: DateTime.parse(
                DateFormat("yyyy-MM-dd' 'HH:mm:ss.SSS'Z'").format(
                    DateTime.parse(DateFormat("yyyy-MM-dd'").format(
                        (appointmentDetails['date'] as Timestamp).toDate())))),
            eventTime: appointmentDetails['time'],
            eventLocation: appointmentDetails['location'],
            eventRequireFasting: appointmentDetails['require fasting'],
            eventDescription: appointmentDetails['description']);
        appointmentList.add(newAppointment);
      }
    }
    return appointmentList;
  }
}
