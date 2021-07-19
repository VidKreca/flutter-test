import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';

class TimerWidget extends StatefulWidget {
  TimerWidget({Key? key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with AutomaticKeepAliveClientMixin<TimerWidget> {
  static const String _title = "Timer";
  Duration _chosenDuration = Duration.zero;
  int _progress = 0;

  Future<dynamic> _setDuration() async {
    Duration _duration = Duration.zero;

    AlertDialog dialog = AlertDialog(
      title: Text("Set timer duration"),
      content: DurationPicker(
        onChange: (value) {
          setState(() {
            _duration = value;
          });
        },
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
          child: Text("Confirm"),
          onPressed: () {
            setState(() {
              Navigator.pop(context, _duration);
            });
          },
        ),
      ],
    );

    return showDialog(context: context, builder: (context) => dialog);
  }

  void _startTimer() {
    // Reset any progress from before
    _progress = 0;

    // Start the timer
    Timer _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_progress >= _chosenDuration.inSeconds) {
        timer.cancel();
      } else {
        setState(() {
          _progress++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_chosenDuration.toString()),
          TextButton(
            child: Text("Set duration"),
            onPressed: () async {
              Duration? dur = await _setDuration();

              setState(() {
                _chosenDuration = (dur != null) ? dur : Duration.zero;
                _progress = 0;
              });
            },
          ),
          SizedBox(
            height: 200.0,
            child: GestureDetector(
              onTap: () {
                _startTimer();
              },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: new CircularProgressIndicator(
                        strokeWidth: 20,
                        backgroundColor: Colors.grey[300],
                        value: (_progress > 0)
                            ? (_progress / _chosenDuration.inSeconds)
                            : 0,
                        semanticsLabel: "Seconds remaining",
                      ),
                    ),
                  ),
                  Center(
                      child: Text(
                          (_chosenDuration.inSeconds - _progress).toString() +
                              "s")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
