import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
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
  late String notif = '';
  late String name = '';

  triggerNotif() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Reminder ',
      body: 'you can extend your child device',
      wakeUpScreen: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  const SizedBox(height: 40),
                  const Text(
                    'Child Device Setup',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Container(
                      padding: const EdgeInsets.only(left: 30),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'DEVICE PAIRING',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                    child: TextFormField(
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Child Device ID',
                        border: OutlineInputBorder(),
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
                      onSaved: (value) => name = value!,
                    ),
                  ),
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
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                    child: TextFormField(
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Phone limit here',
                        border: OutlineInputBorder(),
                        hintText: 'Minutes format',
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
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                    child: TextFormField(
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Restriction time here',
                        border: OutlineInputBorder(),
                        hintText: 'Minutes format',
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
                  Container(
                      padding: const EdgeInsets.only(left: 30),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Message Notification',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Set A short message for Notification that will warn the child device.',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: TextFormField(
                      maxLength: 25,
                      decoration: const InputDecoration(
                        labelText: 'Put your message here',
                        border: OutlineInputBorder(),
                        hintText: 'Make it short',
                        hintStyle: TextStyle(fontSize: 16),
                        errorStyle: TextStyle(color: Colors.red),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter shor message';
                        }
                        return null;
                      },
                      onSaved: (value) => notif = value!,
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
                        final dbr = FirebaseDatabase.instance.ref('Users');
                        dbr.child(name).child('rules').set({
                          'timer': timerValue,
                          'restriction': restrictionValue,
                          'notif': notif
                        });
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
                        Timer(const Duration(seconds: 30), () {
                          triggerNotif();
                        });
                      }
                    },
                    child: const Text(
                      'Set',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
