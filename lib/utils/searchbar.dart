import 'package:flutter/material.dart';

/// Search bar template
class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String text;

  SearchBar({Key key, @required this.controller, @required this.text})
      : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: TextField(
            focusNode: FocusNode(),
            autofocus: false,
            controller: widget.controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search ' + widget.text,
              contentPadding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            )));
  }
}
