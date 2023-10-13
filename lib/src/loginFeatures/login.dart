import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoptouch/src/childFeatures/child_page.dart';
import 'package:stoptouch/src/loginFeatures/singup_page.dart';
import 'package:stoptouch/src/parentFeatures/parent_main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SignUpState();
}

class _SignUpState extends State<LoginPage> {
  late String txtEmail, txtPassword;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.ref().child('Users');
  bool isLoading = false;
  void _signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
          email: txtEmail, password: txtPassword);
      final User user = _auth.currentUser!;
      final userId = user.uid.substring(0, 6);
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('Users/$userId/role').get();
      if (snapshot.exists) {
        if (snapshot.value == 'parent') {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentMainPage(),
              ),
              (route) => false);
        } else if (snapshot.value == 'child') {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ChildPage(),
              ),
              (route) => false);
        } else {
          log('Dont have data in database');
        }
      }
    } catch (e) {
      setState(() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Failed to Login!',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              content: const Text(
                'You Entered wrong username or password!! please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(wordSpacing: 1.5, letterSpacing: 2),
              ),
              actions: [
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                )
              ],
            );
          },
        );
      });
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  Image.asset('assets/stoptouch.png', height: 100, width: 150),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 35),
              child: Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 35),
              child: Text(
                'Enter your Email and password below to continue.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (value) => txtEmail = value!,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (value) => txtPassword = value!,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 40),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.greenAccent,
                          ))
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      _signIn();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(10),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 20, 30, 20),
                                  ),
                                  child: const Text(
                                    'Log in',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ));
                        },
                        child: const Text('Create new account')),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Enter email address';
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password!.isEmpty) {
      return 'Enter your password';
    } else {
      return null;
    }
  }
}
