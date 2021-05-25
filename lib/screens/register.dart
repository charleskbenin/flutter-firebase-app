import 'package:firebase_app/screens/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'homepage.dart';

final auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("images/task-min.jpg"),
                radius: 100,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              TextField(
                textAlign: TextAlign.justify,
                controller: emailController,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.blue,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.justify,
                controller: passController,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text("Register"),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    final newUser = await auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text);
                    if (newUser != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(userID: newUser.user.uid,)));
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                },
              ),
              Text("Already have an accounts?"),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SignInPage()));
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
