import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:stoptouch/src/parentFeatures/parent_main.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final databaseReference = FirebaseDatabase.instance.ref('ParentPasscode');
  final _auth = FirebaseAuth.instance;
  late String passcode = '';
  void _onSavePressed() {
    final User? user = _auth.currentUser;
    final userid = user!.uid;
    _addpasscode(userid);
  }

  void _addpasscode(String id) {
    databaseReference.ref.child(id).set({'passcode': passcode});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Center(
                child: Image.asset(
              'assets/stoptouch.png',
              height: 100,
              width: 150,
            )),
            const SizedBox(height: 20),
            const Text(
              'Set Parent Passcode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'To Stop Your Children Accessing The App.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Passcode',
                  border: OutlineInputBorder(),
                  hintText: 'Enter 4 Digits',
                  hintStyle: TextStyle(fontSize: 16),
                  errorStyle: TextStyle(color: Colors.red),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (passcode) {
                  this.passcode = passcode;
                },
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    padding: const EdgeInsets.fromLTRB(160, 15, 160, 15),
                    backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParentMainPage(),
                      ),
                      (route) => false);
                  _onSavePressed();
                },
                child: const Text(
                  'save',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
          ],
        ),
      ),
    ));
  }
}
