import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naate/constant.dart';
import 'package:url_launcher/url_launcher.dart';

void shareOnSocialMedia(String platform, String url) async {
  switch (platform) {
    case 'whatsapp':
      url = 'https://wa.me/?text=Check%20out%20the%20Nasheed!%20$url';
      break;
    case 'twitter':
      url =
          'https://twitter.com/intent/tweet?text=Check%20out%20the%20Nasheed!%20$url';
      break;
    case 'facebook':
      url = 'https://www.facebook.com/sharer/sharer.php?u=$url';
      break;
  }

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

void showShareModal(BuildContext context, int nasheedId, String nasheedName) {
  String encodedId = base64Encode(utf8.encode(nasheedId.toString()));
  String shareUrl = "$rootUrl/share/$encodedId/$nasheedName";

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Share Nasheed",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      shareUrl,
                      style: TextStyle(
                          fontSize: 14, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.black, size: 24),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: shareUrl));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Link copied ! ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.blue[800],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialMediaButton(
                  context,
                  icon: FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  onPressed: () => shareOnSocialMedia("whatsapp", shareUrl),
                ),
                _socialMediaButton(
                  context,
                  icon: FontAwesomeIcons.twitter,
                  color: Colors.blue,
                  onPressed: () => shareOnSocialMedia("twitter", shareUrl),
                ),
                _socialMediaButton(
                  context,
                  icon: FontAwesomeIcons.facebook,
                  color: Colors.blueAccent,
                  onPressed: () => shareOnSocialMedia("facebook", shareUrl),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Widget _socialMediaButton(BuildContext context,
    {required IconData icon,
    required Color color,
    required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      onPressed();
    },
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
      ),
      child: Icon(icon, color: color, size: 32),
    ),
  );
}
