import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stoptouch/src/childFeatures/child_page.dart';
import 'package:stoptouch/src/loginFeatures/login.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:stoptouch/src/loginFeatures/singup_page.dart';
import 'package:stoptouch/src/parentFeatures/parent_main.dart';
import 'package:stoptouch/src/splash.dart';

Future<void> main() async {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notification',
          channelDescription: 'Warning Notification for users',
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
        )
      ],
      debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/log': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/child': (context) => const ChildPage(),
        '/parent': (context) => const ParentMainPage(),
      },
    );
  }
}
