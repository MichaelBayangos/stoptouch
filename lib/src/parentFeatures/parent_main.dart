import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ParentMainPage extends StatefulWidget {
  const ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> {
  final _formKey = GlobalKey<FormState>();
  late String timerValue = '';
  late String restrictionValue = '';
  final dbRef = FirebaseDatabase.instance.ref().child('Timer');
  final dbref1 = FirebaseDatabase.instance.ref().child('Restriction');

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      timerValue = event.snapshot.value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/stoptouch.png'),
                ),
                const SizedBox(height: 60),
                const Text(
                  'Child Device Setup',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60),
                Container(
                    padding: const EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'PHONE LIMIT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Set limit how long to use phone then screen will automatically lock once the set time is reached.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                      hintText: 'Timer for child device lock funtion',
                      hintStyle: TextStyle(fontSize: 16),
                      errorStyle: TextStyle(color: Colors.red),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter time limit';
                      }
                      return null;
                    },
                    onSaved: (value) => timerValue = value!,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'RESTRICTION LIMIT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Set how long you want to lock your device screen, activation after phone limit is done.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 80),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Time Restriction',
                      border: OutlineInputBorder(),
                      hintText:
                          'Restrtiction time before the device unlock properly',
                      hintStyle: TextStyle(fontSize: 16),
                      errorStyle: TextStyle(color: Colors.red),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Restriction time';
                      }
                      return null;
                    },
                    onSaved: (value) => restrictionValue = value!,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.fromLTRB(80, 15, 80, 15),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      dbRef.set(timerValue);
                      dbref1.set(restrictionValue);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Success'),
                            content: const Text(
                                'Your settings have been saved, Wait for the child device to Log In to apply Stop Touch configurations.'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ok'))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'Set',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
