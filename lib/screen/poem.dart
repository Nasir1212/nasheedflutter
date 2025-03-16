import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naate/component/m_app_bar.dart';
import 'package:naate/component/share_btn_sheet.dart';
import 'package:naate/component/toast.dart';
import 'package:naate/providers/offline_provider.dart';
import 'package:naate/providers/video_link_provider.dart';
import 'package:provider/provider.dart';
import 'package:naate/db/database_helper.dart';
import 'package:naate/model/lyrics_model.dart';
import 'package:naate/providers/action_provider.dart';
import 'package:naate/providers/lyrics_provider.dart';

class Poem extends StatelessWidget {
  final int lyricsId;
  final ScrollController scrollController = ScrollController();

  Poem({super.key, required this.lyricsId});

  @override
  Widget build(BuildContext context) {
    Provider.of<LyricsProvider>(context, listen: false).getByLyricsId(lyricsId);
    Provider.of<OfflineProvider>(context, listen: false).notDownload(lyricsId);
    Provider.of<VideoLinkProvider>(context, listen: false)
        .fetchVideoLink(lyricsId);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Call your state change logic here (setState, notifyListeners)
      DatabaseHelper dbHelper = DatabaseHelper();
      final userData = await dbHelper.getUser();
      if (userData != null) {
        Provider.of<ActionProvider>(context, listen: false)
            .setLove(lyricsId, userData['user_id'] ?? 0);
      }
    });

    return Scaffold(
      appBar: MAppBar(title: "The Nasheed"),
      body: Consumer3<LyricsProvider, ActionProvider, VideoLinkProvider>(
        builder: (context, lyricsProvider, actionP, linkP, child) {
          if (lyricsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (lyricsProvider.oneLyric != null) {
            final LyricsModel data = lyricsProvider.oneLyric!;

            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poem Title and Author
                    Center(
                      child: Column(
                        children: [
                          Text(
                            data.title ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.name ?? "",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 30),
                    // Poem Content
                    HtmlWidget(
                      data.lyrics ?? "",
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 20),

                    // Optional Video Section
                    actionP.isShowVideo
                        ? linkP.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                                children: linkP.videoLink.map((links) {
                                  return Wrap(
                                    children: [
                                      HtmlWidget(
                                        """
                                        <iframe src="https://www.youtube.com/embed/${links.link}"
                                        title="YouTube video player" frameborder="0"
                                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                        allowfullscreen>
                                        </iframe>
                                        """,
                                      ),
                                      Divider(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              )
                        : const SizedBox(),
                    const Divider(),
                    BottomNavigationBar(
                      currentIndex: 0,
                      onTap: (index) async {
                        if (index == 2) {
                          Provider.of<ActionProvider>(context, listen: false)
                              .handleVideo();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );
                          });
                        } else if (index == 1) {
                          showShareModal(context, lyricsId, data.title ?? "");
                        } else if (index == 0) {
                          DatabaseHelper dbHelper = DatabaseHelper();
                          final userData = await dbHelper.getUser();
                          bool? isLogged = await dbHelper.isLogged();
                          if (isLogged == true && userData != null) {
                            actionP.handleLove(
                                data.id ?? 0, userData['user_id'] ?? 0);
                            Toast.success('❤️ Thanks for your support.');
                          } else {
                            Toast.error('Please ! Login');
                          }
                        }
                      },
                      elevation: 0,
                      items: [
                        BottomNavigationBarItem(
                            icon: actionP.isLoved
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(Icons.favorite),
                            label: 'Likes'),
                        const BottomNavigationBarItem(
                            icon: Icon(Icons.share), label: 'Share'),
                        BottomNavigationBarItem(
                          icon: Icon(
                            actionP.isShowVideo
                                ? FontAwesomeIcons.circleStop
                                : FontAwesomeIcons.circlePlay,
                            size: 19,
                          ),
                          label: 'Watch',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 200,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
      // Floating Action Buttons
      floatingActionButton:
          Consumer<OfflineProvider>(builder: (context, offP, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'downloadButton',
              onPressed: offP.isDownloaded == false
                  ? () async {
                      final LyricsModel? data =
                          Provider.of<LyricsProvider>(context, listen: false)
                              .oneLyric;

                      if (data != null) {
                        final Map<String, dynamic> obj = {
                          'db_id': data.id,
                          'title': data.title,
                          'name': data.name,
                          'lyrics': data.lyrics,
                        };

                        await DatabaseHelper().insertItem(obj);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Successfully saved"),
                            backgroundColor: Colors.blue[800],
                          ),
                        );
                        offP.notDownload(data.id as int);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Failed to save."),
                            backgroundColor: Colors.red[800],
                          ),
                        );
                      }
                    }
                  : null,
              backgroundColor: Colors.blue[800],
              child: Icon(Icons.download,
                  color:
                      offP.isDownloaded == false ? Colors.white : Colors.grey),
            ),
          ],
        );
      }),
    );
  }
}
