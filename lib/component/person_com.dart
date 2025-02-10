import 'package:flutter/material.dart';
import 'package:naate/model/lyricist_model.dart';
import 'package:naate/providers/lyricist_provider.dart';
import 'package:naate/screen/by_lyricist.dart';
import 'package:naate/screen/profile.dart';
import 'package:naate/screen/search_by_lyricist.dart';
import 'package:provider/provider.dart';

class PersonCom extends StatelessWidget {
  const PersonCom({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch lyricists data on widget build
    Provider.of<LyricistPorvider>(context, listen: false).fetchData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lyricist List',
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
         backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Consumer<LyricistPorvider>(
        builder: (context, lyricistP, child) {
          if (lyricistP.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (lyricistP.lyricist.isEmpty) {
            return const Center(
              child: Text(
                "No Lyricists found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<LyricistPorvider>(context, listen: false).fetchData();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lyricistP.lyricist.length,
              itemBuilder: (context, index) {
                final LyricistModel lyricistData = lyricistP.lyricist[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ByLyricist(
                          lyricistId: lyricistData.id,
                          name: lyricistData.name,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                      elevation: 1,
                      shadowColor: Colors.grey,
                      surfaceTintColor:Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                  
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      child: Row(
                        children: [
                          // Profile Image with Gesture to View Profile
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Profile()),
                              );
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: NetworkImage(
                                lyricistData.profileImage ??
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGosU4BkeFyuPsve9um8iznwC4dHt7V6TzcQ&s',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Lyricist Name and Song Count
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lyricistData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Total Songs: ${lyricistData.nateRasulsCount}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow Icon
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ByLyricist(
                                    lyricistId: lyricistData.id,
                                    name: lyricistData.name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchByLyricist()),
          );
        },
        backgroundColor: Colors.blue[800],
        shape: const CircleBorder(),
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}
