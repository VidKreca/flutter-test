import 'package:flutter/material.dart';
import 'dart:math';

import 'random_number.dart';
import 'timer.dart';
import 'notes.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static const String _title = "My App";

  int _number = -1;
  int _max = 100;

  _AppState() {
    this._number = _randomNumber();
  }

  int _randomNumber() {
    return Random().nextInt(_max > 0 ? _max : 1);
  }

  @override
  Widget build(BuildContext context) {
    const int _sliderMax = 10000;

    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: Text(_title),
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.confirmation_number)),
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
