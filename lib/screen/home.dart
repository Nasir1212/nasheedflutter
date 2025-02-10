import 'package:flutter/material.dart';
import 'package:naate/component/home_com.dart';
import 'package:naate/component/person_com.dart';
import 'package:naate/component/setting_com.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const TabBar(
              dividerHeight: 0,
              labelColor: Colors.white, // Color of the selected tab's label
              unselectedLabelColor:
                  Colors.grey, // Color of the unselected tabs' labels
              indicatorColor: Colors.white, // Color of the indicator line

              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.bookmark),
                ),
                Tab(
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            backgroundColor: Colors.blue[800],
          ),
          body: const TabBarView(
            children: [
              Center(child: HomeCom()),
              Center(child: PersonCom()),
              Center(child: SettingCom()),
            ],
          ),
        ));
  }
}
