import 'package:flutter/material.dart';
import 'package:naviget/routeView.dart';
import 'package:naviget/shared/point.dart';

import 'auth/auth.dart';

class Search extends SearchDelegate {
  final BaseAuth auth;

  Search(this.auth, this.listExample);
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResults;

  @override
  Widget buildResults(BuildContext context) {
    var suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(
            listExample.where((element) => element.name.contains(query)));
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return query.isEmpty
            ? Container(
                child: Padding(
                padding: const EdgeInsets.all(75.0),
                child: Center(child: CircularProgressIndicator()),
              ))
            : Card(
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RouteView(
                                auth: auth,
                                buddyPoint: suggestionList[index].marker,
                              )),
                    );
                  },
                  child: ListTile(
                    title: Text(suggestionList[index].name),
                  ),
                ),
              );
      },
    );
  }

  List<Point> recentList = [Point(name: 'null')];
  final List listExample;

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(
            listExample.where((element) => element.name.contains(query)));
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return query.isEmpty
            ? Container(
                child: Padding(
                padding: const EdgeInsets.all(75.0),
                child: Center(child: CircularProgressIndicator()),
              ))
            : Card(
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RouteView(
                                buddyPoint: suggestionList[index].latlng,
                              )),
                    );
                  },
                  child: ListTile(
                    title: Text(suggestionList[index].name),
                  ),
                ),
              );
      },
    );
  }
}
