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
  late int timerValue;
  late int restrictionValue;
  late String notif = '';
  late String name = '';

  triggerNotif() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 8,
      channelKey: 'basic_channel',
      title: 'Reminder ',
      body: 'you can still extend your child device time.',
      wakeUpScreen: true,
      badge: 8,
    ));
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/stoptouch.png',
          height: 200,
          width: 200,
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        // this is the logout button
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut();
        //         Navigator.pushReplacementNamed(context, '/log');
        //       },
        //       icon: const Icon(Icons.power_settings_new_outlined))
        // ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 15),
                const Text(
                  'Child Device Setup',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'DEVICE PAIRING',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
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
                    margin: const EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'PHONE LIMIT',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Set limit how long your children can use his/her phone.',
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
                    onSaved: (value) => timerValue = int.parse(value!),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'RESTRICTION LIMIT',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
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
                    onSaved: (value) => restrictionValue = int.parse(value!),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Message Notification',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Set A short message in a form of notification.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: () {
                          final dbr1 = FirebaseDatabase.instance.ref('Users');
                          dbr1.child(name).child('rules').update({
                            'restriction': 0,
                            'notif': 'Your Parent Cancel Restriction'
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Reminder'),
                                content: const Text(
                                    'Your child can use the device now'),
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
                        },
                        child: const Text(
                          'Stop',
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
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
                          Timer(Duration(seconds: (timerValue) * 60 ~/ 2), () {
                            triggerNotif();
                          });
                        }
                      },
                      child: const Text(
                        'Set',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
