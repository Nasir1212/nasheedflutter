import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // Example lyricist data (replace with actual data from your source)
    const String coverPhoto =
        "https://t3.ftcdn.net/jpg/05/55/81/48/360_F_555814824_OSvP99uVRG49c7nNSzwZYTNWS7EX1Hhb.webp"; // Replace with actual cover photo URL
    const String profileImage =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGosU4BkeFyuPsve9um8iznwC4dHt7V6TzcQ&s";
    const String name = "শায়ের মোঃ সেলিম রিয়াদ কাদেরী";
    const String email = "abdulrahman@example.com";
    const String phone = "+8801234567890";
    const String joinedSince = "January 15, 2022";
    const String about =
        "Abdul Rahman is a passionate lyricist who has been contributing to the art of Islamic music for over a decade. His lyrics often focus on spiritual themes, love for the Prophet Muhammad (PBUH), and messages of hope. He enjoys writing in quiet settings and believes his words can inspire others.";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "লেখকের প্রোফাইল",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cover Photo Section
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(coverPhoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 99,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Profile Name and Joined Date
            const Text(
              name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Joined Since: $joinedSince",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Contact Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Divider(color: Colors.grey),
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.blue),
                        title: Text(
                          email,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.blue),
                        title: Text(
                          phone,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Divider(color: Colors.grey),
                      Text(
                        about,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Social Media Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Connect with me",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Add Facebook profile URL here
                            },
                          ),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.twitter,
                              color: Colors.lightBlue,
                            ),
                            onPressed: () {
                              // Add Twitter profile URL here
                            },
                          ),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.instagram,
                              color: Colors.pink,
                            ),
                            onPressed: () {
                              // Add Instagram profile URL here
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
