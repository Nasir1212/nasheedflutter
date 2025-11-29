import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:naate/component/m_app_bar.dart';
import 'package:naate/screen/poem.dart';
import 'package:provider/provider.dart';
import 'package:naate/providers/offline_provider.dart';
import 'package:naate/db/database_helper.dart';

import '../providers/lyrics_provider.dart';

class NoteHome extends StatelessWidget {
  const NoteHome({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textCon = TextEditingController();
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: MAppBar(title: "Note Nasheeds"),
      body: Column(
        children: [
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
                        hintText: "Search your note ...",
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
          Expanded(
            child:  SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
    children: [
    GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => Poem(lyricsId: 1),
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
    " Title ",
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black87,
    ),
    ),
    const SizedBox(height: 5),
    Text(
    "Lyrich Name",
    style: TextStyle(
    fontSize: 15,
    color: Colors.grey[700],
    ),
    ),
    const SizedBox(height: 15),

    // Lyrics content
    HtmlWidget(
    '<h1> My Name is Nasir Uddin </p>',
    textStyle: const TextStyle(
    fontSize: 14,
    color: Colors.black87,
    ),
    ),
    const SizedBox(height: 10),


    ],
    ),
    ),
    ),
    ),

    ],
    )


          ),
            ),
          ),
          Divider(height: 50,),


        ],
      ),
       
      );

  }
}
