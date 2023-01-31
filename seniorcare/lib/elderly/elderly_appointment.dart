// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorcare/models/appointment.dart';
import 'package:seniorcare/services/appointment.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ElderlyAppointment extends StatefulWidget {
  const ElderlyAppointment({super.key, required this.userId});

  final String userId;

  @override
  State<ElderlyAppointment> createState() => _ElderlyAppointmentState();
}

class _ElderlyAppointmentState extends State<ElderlyAppointment> {
  DateTime _focusedCalendarDate = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Appointment>>? mySelectedEvents = {};

  List<Appointment> _listOfDayEvents(DateTime dateTime) {
    return mySelectedEvents![dateTime] ?? [];
  }

  @override
  void initState() {
    _selectedDay = _focusedCalendarDate;
    mySelectedEvents = {};

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.05, size.height * 0.01, 0, 0),
              height: size.height * 0.065,
              width: size.width * 0.7,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromRGBO(108, 99, 255, 1),
                          width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: const Center(
                      child: Text(
                    "Appointment Schedule",
                    style: TextStyle(
                        color: Color.fromRGBO(108, 99, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  )))),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(widget.userId)
                  .snapshots(),
              builder: (((context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                      height: size.height * 0.7,
                      child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 29, 77, 145)));
                } else {
                  List appointmentIdList =
                      snapshot.data!.data()!['appointment'];

                  Future<dynamic> appointments =
                      getElderlyAppointment(appointmentIdList);

                  Future<dynamic> nextAppointment =
                      AppointmentServices.getNextAppointment(
                          widget.userId, appointmentIdList);

                  return Column(children: <Widget>[
                    FutureBuilder(
                        future: nextAppointment,
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return Container(
                                height: size.height * 0.17,
                                width: size.width * 0.95,
                                margin: EdgeInsets.fromLTRB(size.width * 0.02,
                                    size.height * 0.03, size.width * 0.02, 0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 235, 244, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color:
                                            Color.fromRGBO(108, 99, 255, 1))),
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                            top: size.height * 0.007,
                                            left: size.width * 0.03,
                                          ),
                                          child: Text('Upcoming Appointment',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      108, 99, 255, 1),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                      Divider(
                                          color:
                                              Color.fromRGBO(108, 99, 255, 1),
                                          indent: size.width * 0.03,
                                          endIndent: size.width * 0.4),
                                      ListTile(
                                          contentPadding: EdgeInsets.only(
                                              left: size.width * 0.08),
                                          leading: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Column(children: [
                                                  Text(
                                                      DateFormat("d MMMM y'")
                                                          .format(snapshot
                                                              .data['date']
                                                              .toDate()),
                                                      style: TextStyle(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 29, 77, 145),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                                  Text(snapshot.data['time'],
                                                      style: TextStyle(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 29, 77, 145),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15))
                                                ]),
                                                VerticalDivider(
                                                    endIndent:
                                                        size.height * 0.02,
                                                    thickness: 2,
                                                    color: Color.fromARGB(
                                                        255, 29, 77, 145))
                                              ]),
                                          title: Padding(
                                              padding:
                                                  EdgeInsets
                                                      .only(
                                                          top: size
                                                                  .height *
                                                              0.013),
                                              child: Text(
                                                  snapshot.data['name'],
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 29, 77, 145),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15))),
                                          subtitle:
                                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                            Text(
                                                'Location: ${snapshot.data['location']}',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 104, 114, 158),
                                                    fontSize: 14)),
                                            snapshot.data['require fasting'] ==
                                                    null
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0))
                                                : Text(
                                                    '${snapshot.data['require fasting']}',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 104, 114, 158),
                                                        fontSize: 14)),
                                            (snapshot.data['description'] == "")
                                                ? Text('Other Details: -',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 104, 114, 158),
                                                        fontSize: 14))
                                                : Text(
                                                    'Other Details: ${snapshot.data['description']}',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 104, 114, 158),
                                                        fontSize: 14))
                                          ]))
                                    ])));
                          }
                        })),
                    FutureBuilder(
                        future: appointments,
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 29, 77, 145)));
                          } else {
                            mySelectedEvents = {};

                            for (Appointment appointment in snapshot.data) {
                              if (mySelectedEvents![
                                      appointment.eventDateTime] ==
                                  null) {
                                mySelectedEvents![appointment.eventDateTime] = [
                                  appointment
                                ];
                              } else if (!mySelectedEvents![
                                      appointment.eventDateTime]!
                                  .contains(appointment)) {
                                mySelectedEvents![appointment.eventDateTime]!
                                    .add(appointment);
                              }
                            }
                          }
                          return Column(children: <Widget>[
                            Card(
                                margin: EdgeInsets.fromLTRB(
                                    size.width * 0.02,
                                    size.height * 0.02,
                                    size.width * 0.02,
                                    size.height * 0.01),
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  side: BorderSide(
                                      color: Color.fromRGBO(108, 99, 255, 1)),
                                ),
                                child: TableCalendar(
                                    firstDay: DateTime.utc(2010, 1, 1),
                                    focusedDay:
                                        _focusedCalendarDate, // today's date
                                    lastDay: DateTime.utc(
                                        2100, 12, 31), // latest allowed date
                                    calendarFormat: _calendarFormat,
                                    startingDayOfWeek: StartingDayOfWeek.monday,
                                    daysOfWeekHeight: size.height * 0.05,
                                    rowHeight: size.height * 0.06,
                                    daysOfWeekStyle: const DaysOfWeekStyle(
                                        weekendStyle: TextStyle(
                                            color: Colors.deepPurple)),
                                    calendarStyle: const CalendarStyle(
                                        weekendTextStyle:
                                            TextStyle(color: Colors.deepPurple),
                                        markerDecoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 248, 134, 114),
                                            shape: BoxShape.circle),
                                        todayDecoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(
                                                255, 144, 139, 192)),
                                        selectedDecoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(
                                                255, 46, 38, 121))),
                                    headerStyle: HeaderStyle(
                                        formatButtonVisible: false,
                                        titleCentered: true),
                                    selectedDayPredicate:
                                        (currentSelectedDate) {
                                      return (isSameDay(
                                          _selectedDay, currentSelectedDate));
                                    },
                                    onDaySelected: (selectedDay, focusedDay) {
                                      if (!isSameDay(
                                          _selectedDay, selectedDay)) {
                                        setState(() {
                                          _selectedDay = selectedDay;
                                          _focusedCalendarDate = focusedDay;
                                        });
                                      }
                                    },
                                    eventLoader: _listOfDayEvents)),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.04,
                                    top: size.height * 0.01,
                                    bottom: size.height * 0.0005),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      108, 99, 255, 1))),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: Text(
                                                  DateFormat('dd MMMM')
                                                      .format(_selectedDay),
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          108, 99, 255, 1),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold))))
                                    ])),
                            ..._listOfDayEvents(_selectedDay).map(
                                (appointment) => ListTile(
                                    contentPadding: EdgeInsets.only(
                                        left: size.width * 0.05, right: 0),
                                    leading: Text(appointment.eventTime,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 29, 77, 145),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    title: Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.013),
                                        child: Text(appointment.eventTitle,
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 29, 77, 145),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18))),
                                    subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              'Location: ${appointment.eventLocation}',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 104, 114, 158),
                                                  fontSize: 15)),
                                          appointment.eventRequireFasting ==
                                                  null
                                              ? Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 0))
                                              : Text(
                                                  '${appointment.eventRequireFasting}',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 104, 114, 158),
                                                      fontSize: 15)),
                                          (appointment.eventDescription == "")
                                              ? Text('Other Details: -',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 104, 114, 158),
                                                      fontSize: 15))
                                              : Text(
                                                  'Other Details: ${appointment.eventDescription}',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 104, 114, 158),
                                                      fontSize: 15))
                                        ]))),
                            Padding(
                                padding:
                                    EdgeInsets.only(bottom: size.height * 0.05))
                          ]);
                        }))
                  ]);
                }
              })))
        ])));
  }

  getElderlyAppointment(List appointmentIdList) async {
    List<Appointment> appointmentList = [];

    if (appointmentIdList.isNotEmpty) {
      for (String id in appointmentIdList) {
        Map appointmentDetails = await AppointmentServices.getAppointment(id);

        Appointment newAppointment = Appointment(
            eventId: id,
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
