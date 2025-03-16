import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:naate/component/m_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:naate/providers/offline_provider.dart';
import 'package:naate/db/database_helper.dart';

class OfflinePoem extends StatelessWidget {
  const OfflinePoem({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch offline data
    Provider.of<OfflineProvider>(context, listen: false).fetchItem();

    return Scaffold(
      appBar: MAppBar(title: "Offline Nasheeds"),
      body: Consumer<OfflineProvider>(
        builder: (context, offlineP, child) {
          final data = offlineP.offlineData;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No offline Nasheed available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final poem = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                elevation: 1,
                shadowColor: Colors.grey,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and author
                      Text(
                        poem.title ?? "Untitled",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        poem.name ?? "Unknown Author",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      const Divider(height: 20, thickness: 1),

                      // Lyrics
                      HtmlWidget(
                        poem.lyrics ?? "",
                        textStyle: const TextStyle(fontSize: 14),
                      ),

                      // Delete Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final db = DatabaseHelper();
                            await db.deleteItem(poem.id ?? 0);

                            Provider.of<OfflineProvider>(context, listen: false)
                                .fetchItem(); // Refresh list
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Poem deleted successfully"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
