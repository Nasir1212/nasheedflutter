import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:naate/component/m_app_bar.dart';
import 'package:naate/providers/lyrics_provider.dart';
import 'package:naate/screen/poem.dart';
import 'package:provider/provider.dart';

class SearchByLyrics extends StatelessWidget {
  const SearchByLyrics({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textCon = TextEditingController();

    return Scaffold(
      appBar: MAppBar(title: "Search your favorite Nasheed"),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textCon,
                      decoration: const InputDecoration(
                        hintText: "Search for Nasheed ...",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        Provider.of<LyricsProvider>(context, listen: false)
                            .fetchBySearch(value);
                      },
                    ),
                  ),
                  if (textCon.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        textCon.clear();
                        Provider.of<LyricsProvider>(context, listen: false)
                            .fetchBySearch("");
                      },
                    ),
                ],
              ),
            ),
          ),

          // Lyrics List
          Expanded(
            child: Consumer<LyricsProvider>(
              builder: (context, lyricsProvider, child) {
                if (lyricsProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (lyricsProvider.searchLyric.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Nasheed found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lyricsProvider.searchLyric.length,
                  itemBuilder: (context, index) {
                    final data = lyricsProvider.searchLyric[index];
                    final highlightValue = _highlightAndLimitText(
                        data.lyrics, lyricsProvider.searchValue);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.white,
                      elevation: 1,
                      shadowColor: Colors.grey,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Poem(lyricsId: data.id)));
                        },
                        title: Text(
                          data.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: HtmlWidget(
                          highlightValue,
                          textStyle: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Highlights the matched word and limits the displayed text to 50 words.
  String _highlightAndLimitText(String text, String searchValue) {
    if (searchValue.isEmpty) return text;

    // Find all matches
    final regex = RegExp(RegExp.escape(searchValue), caseSensitive: false);
    final matches = regex.allMatches(text);

    if (matches.isEmpty) return text;

    // Take the first match for simplicity
    final match = matches.first;

    // Get a snippet of text surrounding the match
    final snippetStart = match.start - 100 > 0 ? match.start - 100 : 0;
    final snippetEnd =
        match.start + 100 < text.length ? match.start + 100 : text.length;
    String snippet = text.substring(snippetStart, snippetEnd);

    // Highlight the matched word
    snippet = snippet.replaceAllMapped(
      regex,
      (match) =>
          "<mark style='background-color:yellow;'>${match.group(0)}</mark>",
    );

    return snippet;
  }
}
