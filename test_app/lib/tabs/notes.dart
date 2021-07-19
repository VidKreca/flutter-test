import 'dart:developer';

import 'package:flutter/material.dart';

class NotesWidget extends StatefulWidget {
  NotesWidget({Key? key}) : super(key: key);

  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget>
    with AutomaticKeepAliveClientMixin<NotesWidget> {
  static const String _title = "Notes";

  final _controller = TextEditingController();
  late FocusNode _focusNode;
  final _list = <String>[];

  void _saveNewNote() {
    String _text = _controller.text;
    _controller.text = "";

    // Close the keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _list.add(_text);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Note saved"),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _list.removeLast();
            });
          },
        ),
      ),
    );
  }

  void _showBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text("Move to top"),
              onTap: () {
                setState(() {
                  _list.insert(0, _list[index]);
                  _list.removeAt(index + 1);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit"),
              onTap: () {
                _controller.text = _list[index];

                setState(() {
                  _list.removeAt(index);
                });

                // Set focus to input field
                _focusNode.requestFocus();

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Delete"),
              onTap: () {
                setState(() {
                  _list.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            minLines: 1,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "New note...",
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () {
              _saveNewNote();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Card(
                      child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(_list[index]),
                  )),
                  onTap: () {
                    _showBottomSheet(index);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
