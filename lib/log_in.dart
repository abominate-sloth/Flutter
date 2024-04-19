import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab2/itemlist.dart';
import 'package:lab2/registration.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизация"),
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showProgress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Авторизация",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
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
                  password = value;
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
                    try {
                      showProgress = true;
                      final user = await _auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemScreen()),
                        );
                        setState(() {
                          showProgress = false;
                        });
                      }
                    } catch (e) {
                      setState(() {
                        showProgress = false;
                      });
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
                    "Login",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyRegistrationPage()),
                  );
                },
                child: const Text(
                  "You didn't register? Do it Now",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
