import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:device_policy_controller/device_policy_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  final dbRef = FirebaseDatabase.instance.ref().child('Timer');
  final dbref1 = FirebaseDatabase.instance.ref().child('Restriction');
  final dbref2 = FirebaseDatabase.instance.ref().child('Notifcation');
  final dpc = DevicePolicyController.instance;
  String timerValue = '';
  String restrictionValue = '';
  String notif = '';
  Timer? timer;
  Timer? restriction;
  Timer? delay;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    dbref1.onValue.listen((event) {
      setState(() {
        restrictionValue = event.snapshot.value.toString();
      });
    });
    dbref2.onValue.listen((event) {
      setState(() {
        notif = event.snapshot.value.toString();
      });
    });
    dbRef.onValue.listen(
      (event) {
        setState(() {
          timerValue = event.snapshot.value.toString();
          timer?.cancel();
          int seconds = int.tryParse(timerValue)! * 60;
          triggerNotif();
          setState(() {
            if (seconds > 0) {
              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                setState(() {
                  if (seconds != 0) {
                    seconds--;
                    timerValue = seconds.toString();
                    if (seconds == 30) {
                      warningNotif();
                    }
                  } else {
                    timer.cancel();
                    dpc.lockDevice();
                    restriction?.cancel();
                    int resTime = int.tryParse(restrictionValue)! * 60;
                    if (resTime != 0) {
                      restriction = Timer.periodic(const Duration(seconds: 1),
                          (restriction) {
                        setState(() {
                          if (resTime != 0) {
                            resTime--;
                            restrictionValue = resTime.toString();
                            if (resTime != 0) {
                              delay = Timer(const Duration(seconds: 3), () {
                                dpc.lockDevice();
                              });
                            } else {
                              restriction.cancel();
                            }
                          }
                        });
                      });
                    }
                  }
                });
              });
            }
          });
        });
      },
    );
  }

  triggerNotif() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Message From Parent',
      body: notif,
    ));
  }

  warningNotif() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Warning Notification',
      body: 'You Only Have 30 seconds remaing',
    ));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/stoptouch.png',
                    height: 100,
                    width: 200,
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Card(
                      elevation: 20,
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'PHONE LIMIT',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                'Your Parents/guardian set time how long you will use your phone until it force lock'),
                            const SizedBox(height: 60),
                            Text('Time remaining: $timerValue',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Card(
                      elevation: 20,
                      color: Colors.greenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'RESTRICTION TIME',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                'Your Parents/guardian set your time how long you will not able to use your phone.'),
                            const SizedBox(height: 60),
                            Text(
                              'Restrction remaining: $restrictionValue',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
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
