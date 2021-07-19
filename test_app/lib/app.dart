import 'package:flutter/material.dart';
import 'package:test_app/utils/services/rest.dart';
import 'dart:math';

import 'tabs/random_number.dart';
import 'tabs/timer.dart';
import 'tabs/notes.dart';
import 'tabs/github_search.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static const String _title = "My App";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: Text(_title),
                actions: [
                  IconButton(
                    onPressed: () {
                      // Open GithubSearch page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GithubSearch()));
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.confirmation_number),
                    ),
                    Tab(
                      icon: Icon(Icons.timer),
                    ),
                    Tab(
                      icon: Icon(Icons.notes),
                    ),
                  ],
                )),
            body: TabBarView(
              children: [
                RandomNumber(),
                TimerWidget(),
                NotesWidget(),
              ],
            )));
  }
}
