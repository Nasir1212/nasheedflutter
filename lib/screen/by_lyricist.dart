import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:naate/component/m_app_bar.dart';
import 'package:naate/providers/lyrics_provider.dart';
import 'package:naate/screen/poem.dart';
import 'package:provider/provider.dart';

class ByLyricist extends StatelessWidget {
  final int lyricistId;
  final String? name;

  const ByLyricist({super.key, required this.lyricistId, this.name});

  @override
  Widget build(BuildContext context) {
    // Fetch lyrics by lyricist when the widget is built
    Provider.of<LyricsProvider>(context, listen: false)
        .fetchLyricsByLyricist(lyricistId);

    return Scaffold(
      appBar: MAppBar(title: name ?? ""),
      body: Consumer<LyricsProvider>(
        builder: (context, lyricsP, child) {
          if (lyricsP.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (lyricsP.Lyrics.isEmpty) {
            return const Center(
              child: Text(
                "No Lyrics Found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: lyricsP.Lyrics.length,
            itemBuilder: (context, index) {
              final data = lyricsP.Lyrics[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Poem(lyricsId: data.id)),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  shadowColor: Colors.grey,
                  surfaceTintColor: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          data.title ?? "Untitled",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Lyrics snippet
                        HtmlWidget(
                          data.lyrics ?? "",
                          textStyle: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),

                        const SizedBox(height: 8),

                        // "See more" link
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "See more...",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
