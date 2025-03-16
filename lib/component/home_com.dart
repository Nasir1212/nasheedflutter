import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:naate/component/s_app_bar.dart';
import 'package:naate/providers/lyrics_provider.dart';
import 'package:naate/screen/offline_poem.dart';
import 'package:naate/screen/poem.dart';
import 'package:naate/screen/search_by_lyrics.dart';
import 'package:provider/provider.dart';

class HomeCom extends StatelessWidget {
  const HomeCom({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<LyricsProvider>(context, listen: false).fetchLyrics();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: SAppBar(title: "All Nasheed"),
      body: Consumer<LyricsProvider>(
        builder: (context, lyricsP, child) {
          if (lyricsP.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (lyricsP.Lyrics.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await Provider.of<LyricsProvider>(context, listen: false)
                    .fetchLyrics();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: lyricsP.Lyrics.length,
                itemBuilder: (context, index) {
                  final lyricsData = lyricsP.Lyrics[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Poem(lyricsId: lyricsData.id),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      shadowColor: Colors.grey,
                      surfaceTintColor: Colors.white,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and name
                            Text(
                              lyricsData.title ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              lyricsData.name ?? "",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Lyrics content
                            HtmlWidget(
                              lyricsData.lyrics ?? "",
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // "See more" link
                            Text(
                              "See more...",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No Nasheed available at the moment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing between text and button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OfflinePoem(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Text color
                      backgroundColor: Colors.blue[700], // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.offline_pin, size: 24),
                    label: const Text(
                      "Go Save",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchByLyrics(),
            ),
          );
        },
        backgroundColor: Colors.blue[700],
        shape: const CircleBorder(),
        child: const Icon(
          Icons.search,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
