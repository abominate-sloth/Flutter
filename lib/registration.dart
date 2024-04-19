import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'log_in.dart';

class MyRegistrationPage extends StatefulWidget {
  const MyRegistrationPage({super.key});

  @override
  _MyRegistrationPageState createState() => _MyRegistrationPageState();
}

class _MyRegistrationPageState extends State<MyRegistrationPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  late String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Authentication"),
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showProgress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Registration",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value; //get the value entered by user.
                },
                decoration: const InputDecoration(
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value; //get the value entered by user.
                },
                decoration: const InputDecoration(
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {showProgress = true;});
                    try {
                      final newuser =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                      String? uid = newuser.user?.uid;
                      DatabaseReference ref = FirebaseDatabase.instance.ref("users");
                      await ref.child(uid!).child("UserInfo").set
                        ({
                          "email": email
                         }
                        );
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyLoginPage()),
                      );
                      setState(() {
                        showProgress = false;
                      });
                                        } catch (e)
                    {
                      setState(() {showProgress = false;});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  minWidth: 200.0,
                  height: 45.0,
                  child: const Text(
                    "Регистрация",
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyLoginPage()),
                  );
                },
                child: const Text(
                  "Already Registred? Login Now",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}