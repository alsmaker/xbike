import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'registrer.dart';


class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                  child: Text('buy bike'),
                  onPressed: () {
                    Get.toNamed("/view");
                  }
                  ),

              RaisedButton(
                  child: Text('sell bike'),
                  onPressed: () {
                    Get.toNamed("/register");
                  }
                  ),
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  if(!snapshot.hasData) {
                    return RaisedButton(
                        child: Text('Login'),
                        onPressed: () {
                          Get.toNamed("/login");
                        }
                    );
                  } else {
                  return RaisedButton(
                      child: Text('Logout'),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      });
                }
              },
            ),
            ],
          ),
        ),
    );
  }
}