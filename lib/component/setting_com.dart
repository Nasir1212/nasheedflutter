import 'package:flutter/material.dart';
import 'package:naate/screen/login_screen.dart';
import 'package:naate/screen/offline_poem.dart';
import 'package:naate/screen/signup_screen.dart';

class SettingCom extends StatelessWidget {
  const SettingCom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Menu',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
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
                MaterialPageRoute(builder: (context) => const OfflinePoem()),
              );
            }),
            _buildMenuButton(context, Icons.account_balance, 'SignIn', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }),
            _buildMenuButton(context, Icons.account_box_sharp, 'Sign Up', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            }),
            _buildMenuButton(context, Icons.home, 'Home', () {
              // Navigate to home screen
            }),
            _buildMenuButton(context, Icons.settings, 'Settings', () {
              // Navigate to settings screen
            }),
            _buildMenuButton(context, Icons.notifications, 'Notifications', () {
              // Navigate to notifications screen
            }),
            _buildMenuButton(context, Icons.help_outline, 'Help', () {
              // Navigate to help screen
            }),
            _buildMenuButton(context, Icons.exit_to_app, 'Logout', () {
              // Handle logout action
            }),
          ],
        ),
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
