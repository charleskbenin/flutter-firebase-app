import 'package:firebase_app/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../dailog_dart.dart';
import 'homepage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

bool isPasswordVisible = true;
bool isLoading = false;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("images/task-min.jpg"),
                  radius: 100,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 15),
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
                  obscureText: isPasswordVisible,
                  textAlign: TextAlign.justify,
                  controller: passController,
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          }),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      )),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final currentUser =
                                await auth.signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passController.text);
                            if (currentUser != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }on FirebaseAuthException catch (e) {
                            // print(e.toString());
                            openDailog(context,e.message);
                            
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Need an accounts?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => SignUpPage()));
                          },
                          child: Text("Register"))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
