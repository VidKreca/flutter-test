import 'package:flutter/material.dart';
import 'dart:math';

class RandomNumber extends StatefulWidget {
  RandomNumber({Key? key}) : super(key: key);

  @override
  _RandomNumberState createState() => _RandomNumberState();
}

class _RandomNumberState extends State<RandomNumber>
    with AutomaticKeepAliveClientMixin<RandomNumber> {
  static const String _title = "Generate random number";

  int _number = -1;
  int _max = 100;

  _RandomNumberState() {
    this._number = _randomNumber();
  }

  int _randomNumber() {
    return Random().nextInt(_max > 0 ? _max : 1);
  }

  @override
  Widget build(BuildContext context) {
    const int _sliderMax = 10000;

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          _number.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
        IconButton(
          icon: Icon(Icons.restart_alt),
          tooltip: "Regenerate number",
          iconSize: 60,
          onPressed: () {
            setState(() {
              _number = _randomNumber();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(20), child: Text("Max:")),
            Expanded(
                child: Slider(
              value: _max.toDouble(),
              min: 0,
              max: _sliderMax.toDouble(),
              label: "$_max",
              divisions: _sliderMax ~/ 1000,
              onChanged: (double value) {
                setState(() {
                  _max = value.round();
                });
              },
            ))
          ],
        ),
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
