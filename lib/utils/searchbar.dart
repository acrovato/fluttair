import 'package:flutter/material.dart';

/// Search bar template
Widget searchBar(TextEditingController controller, String text) {
  return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextField(
          focusNode: FocusNode(),
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search ' + text,
            contentPadding: EdgeInsets.only(top: 16.0, bottom: 16.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          )));
}
