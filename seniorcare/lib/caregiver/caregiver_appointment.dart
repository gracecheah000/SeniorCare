// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:seniorcare/models/appointment.dart';
import 'package:seniorcare/widgets/appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CaregiverAppointment extends StatefulWidget {
  const CaregiverAppointment({super.key});

  @override
  State<CaregiverAppointment> createState() => _CaregiverAppointmentState();
}

class _CaregiverAppointmentState extends State<CaregiverAppointment> {
  DateTime _focusedCalendarDate = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  bool requireFasting = false;

  late Map<DateTime, List<Appointment>> mySelectedEvents;

  // TODO: change to push and pull from firebase
  List<Appointment> _listOfDayEvents(DateTime dateTime) {
    return mySelectedEvents[dateTime] ?? [];
  }

  @override
  void initState() {
    _selectedDay = _focusedCalendarDate;
    mySelectedEvents = {};
    titleController.text = '';
    timeController.text = '';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SeniorCareAppBar(start: false),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                height: 50,
                width: 250,
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
                  )),
                )),
            Card(
              margin: const EdgeInsets.fromLTRB(8, 30, 8, 8),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(color: Color.fromRGBO(108, 99, 255, 1)),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                focusedDay: _focusedCalendarDate, // today's date
                lastDay: DateTime.utc(2030, 1, 1), // latest allowed date
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekHeight: 60,
                rowHeight: 55,
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.deepPurple)),
                calendarStyle: const CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.deepPurple),
                    markerDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 248, 134, 114),
                        shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 144, 139, 192)),
                    selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 46, 38, 121))),
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                selectedDayPredicate: (currentSelectedDate) {
                  return (isSameDay(_selectedDay, currentSelectedDate));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedCalendarDate = focusedDay;
                    });
                  }
                },

                eventLoader: _listOfDayEvents,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(108, 99, 255, 1))),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                                DateFormat('dd MMMM').format(_selectedDay),
                                style: TextStyle(
                                    color: Color.fromRGBO(108, 99, 255, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ])),
            ..._listOfDayEvents(_selectedDay).map((Appointment) => ListTile(
                leading: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      Appointment.eventTime,
                      style: TextStyle(
                          color: Color.fromRGBO(108, 99, 255, 1),
                          fontWeight: FontWeight.bold),
                    )),
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('${Appointment.eventTitle}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 42, 38, 119)))),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Location: ${Appointment.eventLocation}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 104, 114, 158),
                            fontSize: 13)),
                    Appointment.eventRequireFasting != null
                        ? Text('${Appointment.eventRequireFasting}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 114, 158),
                                fontSize: 13))
                        : Padding(padding: EdgeInsets.only(left: 0)),
                    Appointment.eventDescription == null
                        ? Padding(padding: EdgeInsets.only(left: 0))
                        : Text('Other Details: ${Appointment.eventDescription}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 114, 158),
                                fontSize: 13)),
                  ],
                ))),
          ],
        )),
        floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              _showAddAppointmentDialog();
            },
            backgroundColor: Color.fromARGB(255, 160, 171, 221),
            heroTag: "AddAppointment",
            child: Image.asset('assets/images/add.png')));
  }

  _showAddAppointmentDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              scrollable: true,
              backgroundColor: Color.fromARGB(255, 247, 249, 250),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('New Appointment',
                            style: TextStyle(
                                color: Color.fromRGBO(108, 99, 255, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            titleController.clear();
                            timeController.clear();
                            locationController.clear();
                            requireFasting = false;
                            descriptionController.clear();
                            Navigator.pop(context);
                          },
                          icon:
                              Image.asset('assets/images/close.png', scale: 20),
                          iconSize: 20,
                        )
                      ],
                    ),
                    Divider(
                      color: Color.fromRGBO(108, 99, 255, 1),
                    ),
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
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(108, 99, 255, 1)),
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                          );

                          if (pickedTime != null) {
                            DateTime parsedTime = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                pickedTime.hour,
                                pickedTime.minute);
                            String formattedTime =
                                DateFormat("h:mma").format(parsedTime);

                            setState(() {
                              timeController.text = formattedTime;
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
                              color: Color.fromRGBO(108, 99, 255, 1))),
                    ),
                  ],
                );
              }),
              actions: [
                TextButton(
                    onPressed: () {
                      if (titleController.text.isEmpty &&
                          timeController.text.isEmpty &&
                          locationController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Please fill up title, time and location of appointment'),
                            duration: Duration(seconds: 2)));
                        return;
                      } else {
                        setState(() {
                          if (mySelectedEvents[_selectedDay] != null) {
                            mySelectedEvents[_selectedDay]?.add(Appointment(
                                eventTitle: titleController.text,
                                eventDate: _selectedDay,
                                eventLocation: locationController.text,
                                eventRequireFasting:
                                    requireFasting ? 'Require fasting' : null,
                                eventTime: timeController.text,
                                eventDescription:
                                    descriptionController.text.isEmpty
                                        ? null
                                        : descriptionController.text));
                          } else {
                            mySelectedEvents[_selectedDay] = [
                              Appointment(
                                  eventTitle: titleController.text,
                                  eventDate: _selectedDay,
                                  eventLocation: locationController.text,
                                  eventRequireFasting:
                                      requireFasting ? 'Require fasting' : null,
                                  eventTime: timeController.text,
                                  eventDescription:
                                      descriptionController.text.isEmpty
                                          ? null
                                          : descriptionController.text)
                            ];
                          }
                        });

                        titleController.clear();
                        timeController.clear();
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
              ],
            ));
  }
}

Widget customTextField(
    {String? hint, required TextEditingController controller}) {
  return TextField(
    controller: controller,
    textCapitalization: TextCapitalization.words,
    decoration: InputDecoration(
        labelText: hint ?? '',
        labelStyle: TextStyle(color: Color.fromRGBO(108, 99, 255, 1)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(108, 99, 255, 1)),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(108, 99, 255, 1)),
            borderRadius: BorderRadius.circular(20))),
  );
}
