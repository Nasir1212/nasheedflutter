import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naate/component/m_app_bar.dart';
import 'package:naate/constant.dart';
import 'package:naate/providers/lyricist_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatelessWidget {
  final int lyricistId;
  const Profile({super.key, required this.lyricistId});

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
    const String elseAbout =
        "Hi, I’m a passionate lyricist who has been contributing to the art of Islamic music for over a decade. My lyrics often explore spiritual themes, express love for the Prophet Muhammad (PBUH), and carry messages of hope. I find inspiration in quiet settings and believe that my words have the power to uplift and inspire others.";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Call your state change logic here (setState, notifyListeners)

      Provider.of<LyricistPorvider>(context, listen: false)
          .fetchById(lyricistId);
    });
    void openWhatsApp(String phone) async {
      if (!phone.startsWith("+88")) {
        phone = "+88$phone"; // Add country code if missing
      }
      final Uri whatsappUrl = Uri.parse("https://wa.me/$phone");

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        throw "Could not launch WhatsApp";
      }
    }

    void openDialPad(String phone) async {
      if (!phone.startsWith("+88")) {
        phone = "+88$phone"; // Add country code if missing
      }

      final Uri dialUrl = Uri.parse("tel:$phone");

      if (await canLaunchUrl(dialUrl)) {
        await launchUrl(dialUrl,
            mode: LaunchMode.externalApplication); // Explicit mode
      } else {
        throw "Could not open dial pad";
      }
    }

    void openFacebook(String facebookUrl) async {
      final Uri parseUri = Uri.parse(facebookUrl);

      if (await canLaunchUrl(parseUri)) {
        await launchUrl(parseUri,
            mode: LaunchMode
                .externalApplication); // Opens Facebook in the browser or the app (if installed)
      } else {
        throw 'Could not open Facebook';
      }
    }

    return Scaffold(
      appBar: MAppBar(title: "Shayer's Profile"),
      body: SingleChildScrollView(
        child: Consumer<LyricistPorvider>(builder: (context, lyP, child) {
          if (lyP.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final lyricistData = lyP.lyricistData;
          String dateOnly = "N/A"; // Default value

          if (lyricistData != null && lyricistData.joinedSince.isNotEmpty) {
            try {
              DateTime dateTime = DateTime.parse(lyricistData.joinedSince);
              dateOnly =
                  dateTime.toString().split(' ')[0]; // Extract only the date
            } catch (e) {
              print("Error parsing date: $e");
            }
          } else {
            print("No valid date available.");
          }

          if (lyricistData == null) {
            return const Center(
              child: Text("No data found",
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cover Photo Section
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$imgUrl/${lyricistData.cover}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 99,
                        backgroundImage:
                            NetworkImage("$imgUrl/${lyricistData.profile}"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Profile Name and Joined Date
              Text(
                lyricistData.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Joined Since: $dateOnly",
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Contact Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.blue),
                          title: Text(
                            lyricistData.email,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.blue),
                          title: Text(
                            lyricistData.phone,
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
                  child: Padding(
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
                          lyricistData.about,
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
                                openFacebook(lyricistData.facebook);
                              },
                            ),
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.lightGreen,
                              ),
                              onPressed: () {
                                openWhatsApp(lyricistData.whatsapp);
                              },
                            ),
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.phone,
                                color: Colors.lightBlue,
                              ),
                              onPressed: () {
                                openDialPad(lyricistData.phone);
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
          );
        }),
      ),
    );
  }
}
