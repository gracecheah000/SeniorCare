import 'package:flutter/material.dart';
import 'package:seniorcare/models/user.dart';
import 'package:seniorcare/services/user_details.dart';
import 'package:seniorcare/widgets/custom_multi_select_widget.dart';

class ElderlyDetailsCard extends StatefulWidget {
  const ElderlyDetailsCard({
    super.key,
    required this.elderly,
    required this.caregiverEmail,
    required this.notifyParent,
  });

  final Elderly elderly;
  final String caregiverEmail;
  final Function notifyParent;

  @override
  State<ElderlyDetailsCard> createState() => _ElderlyDetailsCardState();
}

class _ElderlyDetailsCardState extends State<ElderlyDetailsCard> {
  bool editing = false;

  List<DropdownMenuItem<String>> get sexDropDownItems {
    List<DropdownMenuItem<String>> sexMenuItems = [
      const DropdownMenuItem(value: 'Male', child: Text('Male')),
      const DropdownMenuItem(value: 'Female', child: Text('Female'))
    ];
    return sexMenuItems;
  }

  List<String> items = ['Diabetes', 'High Blood Cholesterol'];
  List? healthRisks = [];
  String? sex = 'Male';

  @override
  Widget build(BuildContext context) {
    healthRisks = widget.elderly.healthRisks;
    final age = TextEditingController();
    age.text = widget.elderly.age!;
    final address = TextEditingController();
    address.text = widget.elderly.address!;
    final additionalDetails = TextEditingController();
    additionalDetails.text = widget.elderly.additionalDetails!;

    var size = MediaQuery.of(context).size;

    if (editing == false) {
      return Card(
          color: const Color.fromARGB(255, 237, 243, 255),
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color.fromARGB(255, 176, 200, 233)),
              borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          top: size.height * 0.02,
                          bottom: size.height * 0.02),
                      child: Text(widget.elderly.name!.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 29, 77, 145)))),
                  Row(
                    children: <Widget>[
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            editing = true;
                          });
                        },
                        icon: Image.asset(
                          'assets/images/edit_blue.png',
                        ),
                        iconSize: 73,
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        splashRadius: 20,
                        onPressed: () {
                          var result = UserDetails.deleteElderlyFromCaregiver(
                              widget.elderly.email!, widget.caregiverEmail);
                        },
                        icon: Image.asset('assets/images/bin_blue.png'),
                        iconSize: 60,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 176, 200, 233),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 176, 200, 233)),
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.only(
                            top: size.height * 0.01,
                            left: size.width * 0.02,
                            bottom: size.height * 0.01,
                            right: size.width * 0.02,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('age :'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width * 0.1)),
                              Text(widget.elderly.age!,
                                  style: const TextStyle(fontSize: 15))
                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 176, 200, 233),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 176, 200, 233)),
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.only(
                            top: size.height * 0.01,
                            left: size.width * 0.02,
                            bottom: size.height * 0.01,
                            right: size.width * 0.02,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('sex :'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width * 0.1)),
                              Text(widget.elderly.sex!,
                                  style: const TextStyle(fontSize: 15))
                            ],
                          )),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.025),
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 176, 200, 233),
                          border: Border.all(
                              color: const Color.fromARGB(255, 176, 200, 233)),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(
                        top: size.height * 0.01,
                        left: size.width * 0.02,
                        bottom: size.height * 0.01,
                        right: size.width * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('address :'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(
                              padding: EdgeInsets.only(left: size.width * 0.1)),
                          Text(widget.elderly.address!,
                              style: const TextStyle(fontSize: 15))
                        ],
                      ))),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 176, 200, 233),
                          border: Border.all(
                              color: const Color.fromARGB(255, 176, 200, 233)),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(
                        top: size.height * 0.01,
                        left: size.width * 0.02,
                        bottom: size.height * 0.01,
                        right: size.width * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('health risks :'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(
                              padding: EdgeInsets.only(left: size.width * 0.1)),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (var item in widget.elderly.healthRisks!)
                                Text(
                                  item,
                                  style: const TextStyle(fontSize: 15),
                                  textAlign: TextAlign.end,
                                )
                            ],
                          ))
                        ],
                      ))),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.025),
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 176, 200, 233),
                          border: Border.all(
                              color: const Color.fromARGB(255, 176, 200, 233)),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(
                        top: size.height * 0.01,
                        left: size.width * 0.02,
                        bottom: size.height * 0.01,
                        right: size.width * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('other details :'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(
                              padding: EdgeInsets.only(left: size.width * 0.1)),
                          Expanded(
                              child: Text(
                            widget.elderly.additionalDetails!,
                            style: const TextStyle(fontSize: 15),
                            textAlign: TextAlign.end,
                          ))
                        ],
                      )))
            ],
          )));
    } else {
      return Card(
          color: const Color.fromARGB(255, 237, 243, 255),
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color.fromARGB(255, 176, 200, 233)),
              borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          top: size.height * 0.02,
                          bottom: size.height * 0.02),
                      child: Text(widget.elderly.name!.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 29, 77, 145)))),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    splashRadius: 20,
                    onPressed: () async {
                      setState(() {
                        Elderly elderly = Elderly(
                            email: widget.elderly.email,
                            age: age.text,
                            sex: sex,
                            address: address.text,
                            healthRisks: healthRisks,
                            additionalDetails: additionalDetails.text);
                        UserDetails.editElderlyDetails(elderly);
                        editing = false;
                        widget.notifyParent();
                      });
                    },
                    icon: Image.asset(
                      'assets/images/save.png',
                    ),
                    iconSize: 45,
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 176, 200, 233),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 176, 200, 233)),
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.only(
                          top: size.height * 0.01,
                          left: size.width * 0.02,
                          bottom: size.height * 0.01,
                          right: size.width * 0.02,
                        ),
                        child: SizedBox(
                            height: size.height * 0.04,
                            width: size.width * 0.3,
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'age'.toUpperCase(),
                                    labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 29, 77, 145)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 29, 77, 145)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 29, 77, 145)),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                controller: age)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 176, 200, 233),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 176, 200, 233)),
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.only(
                          top: size.height * 0.01,
                          left: size.width * 0.02,
                          bottom: size.height * 0.01,
                          right: size.width * 0.02,
                        ),
                        child: SizedBox(
                            height: size.height * 0.04,
                            width: size.width * 0.3,
                            child: DropdownButton<String>(
                                isExpanded: true,
                                value: sex,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 29, 77, 145),
                                    fontFamily: 'Montserrat',
                                    fontSize: 17),
                                items: sexDropDownItems,
                                onChanged: (value) {
                                  setState(() {
                                    sex = value;
                                  });
                                },
                                underline: Container(),
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Color.fromARGB(255, 29, 77, 145)))),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.025),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 176, 200, 233),
                        border: Border.all(
                            color: const Color.fromARGB(255, 176, 200, 233)),
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      left: size.width * 0.02,
                      bottom: size.height * 0.01,
                      right: size.width * 0.02,
                    ),
                    child: SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.8,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'address'.toUpperCase(),
                              labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 29, 77, 145)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 29, 77, 145)),
                                  borderRadius: BorderRadius.circular(20)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 29, 77, 145)),
                                  borderRadius: BorderRadius.circular(20))),
                          controller: address,
                        )),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 176, 200, 233),
                        border: Border.all(
                            color: const Color.fromARGB(255, 176, 200, 233)),
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      left: size.width * 0.02,
                      bottom: size.height * 0.01,
                      right: size.width * 0.02,
                    ),
                    child: MultiSelect(
                        items: items,
                        color: const Color.fromARGB(255, 29, 77, 145),
                        updateHealthRisks: updateParentHealthRisks,
                        healthRisks: healthRisks!.isEmpty
                            ? []
                            : widget.elderly.healthRisks!),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.025),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 176, 200, 233),
                        border: Border.all(
                            color: const Color.fromARGB(255, 176, 200, 233)),
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      left: size.width * 0.02,
                      bottom: size.height * 0.01,
                      right: size.width * 0.02,
                    ),
                    child: SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.8,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'other details'.toUpperCase(),
                              labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 29, 77, 145)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 29, 77, 145)),
                                  borderRadius: BorderRadius.circular(20)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 29, 77, 145)),
                                  borderRadius: BorderRadius.circular(20))),
                          controller: additionalDetails,
                        )),
                  ))
            ],
          )));
    }
  }

  updateParentHealthRisks(List<String>? updatedHealthRisks) {
    healthRisks = updatedHealthRisks;
  }
}
