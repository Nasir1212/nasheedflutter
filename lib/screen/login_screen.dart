import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:naate/component/toast.dart';
import 'package:naate/constant.dart';
import 'package:naate/db/database_helper.dart';
import 'package:naate/screen/home.dart';
import 'package:naate/screen/signup_screen.dart';

import '../component/m_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, TextEditingController> loginController = {
      "email_or_phone": TextEditingController(),
      "password": TextEditingController(),
    };

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: MAppBar(title: ""),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NasheedHub",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: loginController["email_or_phone"],
                    decoration: InputDecoration(
                      labelText: "Email or Phone",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    cursorColor: Colors.blue[800],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: loginController["password"],
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Forgot Password?"),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Validate the form
                      if (formKey.currentState!.validate()) {
                        final response = await http.post(
                          Uri.parse("$baseUrl/login"),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            "email_or_phone":
                                loginController["email_or_phone"]?.text ?? '',
                            "password": loginController["password"]?.text ?? '',
                          }),
                        );
                        print(response.statusCode);
                        if (response.statusCode == 200) {
                          // If the server returns an OK response, then parse the JSON.
                          Map<String, dynamic> userData =
                              jsonDecode(response.body);
                          print(userData);
                          DatabaseHelper dbHelper = DatabaseHelper();
                          // await dbHelper.dropDatabase();
                          await dbHelper.savedUserFromApi(
                              userData['user'], userData['token']);
                          Toast.success("Login successful");
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                          print(response.body);
                        } else if (response.statusCode == 401) {
                          Toast.error("Invalid credentials");
                        } else {
                          Toast.error("Something Went wrong");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.blue[800]),
                    child: Text("Login",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text("Sign Up"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
