import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:naate/providers/action_provider.dart';
import 'package:naate/providers/lyricist_provider.dart';
import 'package:naate/providers/lyrics_provider.dart';
import 'package:naate/providers/offline_provider.dart';
import 'package:naate/providers/video_link_provider.dart';
import 'package:naate/providers/video_provider.dart';
import 'package:naate/screen/home.dart';
import 'package:naate/screen/poem.dart';
import 'package:naate/services/lyrics_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LyricsProvider(lyricsService: LyricsService())),
        ChangeNotifierProvider(create: (_) => LyricistPorvider()),
        ChangeNotifierProvider(create: (_) => OfflineProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => ActionProvider()),
        ChangeNotifierProvider(create: (_) => VideoLinkProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: Container(
          color: Colors.white,
          child: const Home(),
        ),
        onGenerateRoute: (settings) {
          final Uri uri = Uri.parse(settings.name!);

          // Check if the incoming route is a deep link
          if (uri.pathSegments.isNotEmpty) {
            // Parse the deep link, for example, the ID from URL
            String nasheedId = uri.pathSegments.last;
            String decodedId = utf8.decode(base64Decode(nasheedId));
            return MaterialPageRoute(
              builder: (context) => Poem(lyricsId: decodedId as int),
            );
          }
          return null;
        },
      ),
    );
  }
}

// void initDeepLinks() {
//   uriLinkStream.listen((Uri? uri) {
//     if (uri != null) {
//       String encodedId = uri.pathSegments.last;
//       // Decode the Base64 encoded nasheedId
//       String decodedId = utf8.decode(base64Decode(encodedId));

//       // Navigate to Nasheed detail page with the decoded nasheedId
//       navigatorKey.currentState?.pushNamed('/nasheed/$decodedId');
//     }
//   });
// }
