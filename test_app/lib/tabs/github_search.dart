import 'dart:developer';

import 'package:flutter/material.dart';
import '../utils/services/rest.dart';

class GithubSearch extends StatefulWidget {
  GithubSearch({Key? key}) : super(key: key);

  @override
  _GithubSearchState createState() => _GithubSearchState();
}

class _GithubSearchState extends State<GithubSearch>
    with AutomaticKeepAliveClientMixin<GithubSearch> {
  final _controller = TextEditingController();

  void _search() async {
    String query = _controller.text;

    // Make request to Github API
    SearchResult result = await search(query);

    log(result.items[0].full_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Github Search")),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Search repositories...",
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _search();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
