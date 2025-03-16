import 'package:flutter/material.dart';
import 'package:naate/component/m_app_bar.dart';
import 'package:naate/providers/lyricist_provider.dart';
import 'package:naate/screen/by_lyricist.dart';
import 'package:naate/screen/profile.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class SearchByLyricist extends StatelessWidget {
  const SearchByLyricist({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textCon = TextEditingController();

    return Scaffold(
      appBar: MAppBar(title: "Search your favorite Shayer"),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: textCon,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            textCon.clear();
                            Provider.of<LyricistPorvider>(context,
                                    listen: false)
                                .fetchBySearch("");
                          },
                        ),
                        hintText: "Type Shayer's name...",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        Provider.of<LyricistPorvider>(context, listen: false)
                            .fetchBySearch(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List of Lyricists
          Expanded(
            child: Consumer<LyricistPorvider>(
              builder: (context, lyricistProvider, child) {
                if (lyricistProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (lyricistProvider.searchLyricist.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Shayer  found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lyricistProvider.searchLyricist.length,
                  itemBuilder: (context, index) {
                    final lyricist = lyricistProvider.searchLyricist[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.white,
                      elevation: 1,
                      shadowColor: Colors.grey,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                          lyricistId: lyricist.id,
                                        )));
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage("$imgUrl/${lyricist.profile}"),
                          ),
                        ),
                        title: Text(
                          lyricist.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Total Nasheed: ${lyricist.nateRasulsCount}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ByLyricist(
                                    lyricistId: lyricist.id,
                                    name: lyricist.name),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ByLyricist(
                                  lyricistId: lyricist.id, name: lyricist.name),
                            ),
                          );
                        },
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
}
