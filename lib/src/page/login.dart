import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _smsController = TextEditingController();

  String _verificationId;

  final SmsAutoFill _autoFill = SmsAutoFill();

  verifyPhoneNumber(String phoneNumber) async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      //phoneNumber: '+82 11 2222 3333',
        phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async{
        // Sign the user in (or link) with the auto-generated credential
        //await auth.signInWithCredential(credential);
        print(auth.currentUser.uid);
      },
      verificationFailed: (FirebaseAuthException authException) {
        if (authException.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        else
          print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      },
      codeSent: (String verificationId, int resendToken) {
        print('Please check your phone for the verification code.');
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("verification code: " + verificationId);
        _verificationId = verificationId;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(padding: const EdgeInsets.all(8),
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(child: Text("Get current number"),
                      onPressed: () async => {
                        _phoneNumberController.text = await _autoFill.hint
                      },
                      color: Colors.greenAccent[700]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.greenAccent[400],
                    child: Text("Verify Number"),
                    onPressed: () async {
                      verifyPhoneNumber(_phoneNumberController.text);
                    },
                  ),
                ),
                TextFormField(
                  controller: _smsController,
                  decoration: const InputDecoration(labelText: 'Verification code'),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                      color: Colors.greenAccent[200],
                      onPressed: () async {
                        //signInWithPhoneNumber();
                      },
                      child: Text("Sign in")),
                ),
              ],
            )
        ),
      )
    );
  }
}