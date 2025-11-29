import 'package:flutter/material.dart';
import 'package:naate/db/database_helper.dart';
import 'package:naate/screen/home.dart';
import 'package:naate/screen/login_screen.dart';
import 'package:naate/screen/note_home.dart';
import 'package:naate/screen/offline_poem.dart';
import 'package:naate/screen/signup_screen.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import 's_app_bar.dart';
import 'toast.dart';

class SettingCom extends StatelessWidget {
  const SettingCom({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper();
    return Scaffold(
      appBar: SAppBar(title: "All Menu"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<bool>(
            future: dbHelper.isLogged().then((value) => value ?? false),
            builder: (context, snapshot) {
              bool isLoggedIn = snapshot.data ?? false;
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 3,
                ),
                children: [
                  _buildMenuButton(context, Icons.offline_pin, 'Saved', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OfflinePoem()),
                    );
                  }),
                  _buildMenuButton(context, Icons.note, 'Note', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoteHome()),
                    );
                  }),
                  _buildMenuButton(context, Icons.home, 'Home', () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  }),

                  if (!isLoggedIn) ...[
                    _buildMenuButton(context, Icons.login, 'Sign In', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ); // Refresh login status after returning
                    }),
                    _buildMenuButton(context, Icons.app_registration, 'Sign Up',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      ); // Refresh login status after returning
                    }),
                  ] else
                    _buildMenuButton(context, Icons.exit_to_app, 'Logout',
                        () async {
                      String token =
                          await DatabaseHelper().getToken(); // Get stored token
                      print("logout token is $token");

                      try {
                        final response = await http.post(
                          Uri.parse("$baseUrl/logout"),
                          headers: {
                            'Authorization': 'Bearer $token',
                            'Accept': 'application/json',
                          },
                        );

                        if (response.statusCode == 200) {
                          await DatabaseHelper()
                              .logout(); // Remove user from DB
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        } else {
                          Toast.error('Logout failed. Try again!');
                          print("Logout failed: ${response.body}");
                        }
                      } catch (e) {
                        Toast.error('Something Went wrong');
                        print("Error: $e");
                      }
                    })
                ],
                // _buildMenuButton(context, Icons.settings, 'Settings', () {
                //   // Navigate to settings screen
                // }),
                // _buildMenuButton(context, Icons.notifications, 'Notifications', () {
                //   // Navigate to notifications screen
                // }),
                // _buildMenuButton(context, Icons.help_outline, 'Help', () {
                //   // Navigate to help screen
                // }),
              );
            }),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
