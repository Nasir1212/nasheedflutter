import 'package:flutter/material.dart';

class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue[700],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
