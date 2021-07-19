import 'dart:developer';

import 'package:flutter/material.dart';
import '../utils/services/rest.dart';
import 'package:url_launcher/url_launcher.dart';

class GithubSearch extends StatefulWidget {
  GithubSearch({Key? key}) : super(key: key);

  @override
  _GithubSearchState createState() => _GithubSearchState();
}

class _GithubSearchState extends State<GithubSearch>
    with AutomaticKeepAliveClientMixin<GithubSearch> {
  final _controller = TextEditingController();

  SearchResult _result = SearchResult.empty();
  bool _loading = false;

  void _search() async {
    String query = _controller.text;

    // Make request to Github API
    setState(() => _loading = true);
    SearchResult result = await search(query);

    setState(() {
      _loading = false;
      _result = result;
    });
  }

  void _showDetails(Repository repo) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(repo.full_name),
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(repo.description),
            ),
            ElevatedButton(
              onPressed: () async {
                String url = repo.html_url;
                await launch(url);
              },
              child: Text("Open in browser"),
            ),
          ],
        );
      },
    );
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

                // Close the keyboard
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Found: ${_result.total_count}"),
              Text("Displayed: ${_result.items.length}"),
            ],
          ),
          (_loading)
              ? Padding(
                  padding: EdgeInsets.all(40),
                  child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _result.items.length,
                    itemBuilder: (context, index) {
                      Repository repo = _result.items[index];

                      return ListTile(
                        leading: Image.network(repo.avatar_url),
                        title: Card(
                            child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(repo.full_name),
                        )),
                        onTap: () {
                          _showDetails(repo);
                        },
                      );
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
