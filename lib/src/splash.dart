import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;
  late Timer _timer;
  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((User? user) {
      if (mounted) {
        _timer = Timer(const Duration(seconds: 3), () {
          if (user == null) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/log', (route) => false);
          } else {
            final User user = _auth.currentUser!;
            final userId = user.uid.substring(0, 6);
            final ref = FirebaseDatabase.instance.ref();
            ref.child('Users/$userId/role').get().then((snapshot) {
              if (snapshot.exists) {
                if (snapshot.value == 'parent') {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/parent');
                } else if (snapshot.value == 'child') {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/child');
                } else {
                  debugPrint('Dont have data in database');
                }
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/stoptouch.png'),
              const SpinKitSpinningLines(
                color: Colors.green,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
