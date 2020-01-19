import 'package:flutter/material.dart';

/// Basic Dialog template
class MyDialog extends StatelessWidget {
  final String title;
  final String text;
  final String closeText;
  final String actionText;
  final void Function() action;

  MyDialog(
      {Key key,
      @required this.title,
      @required this.text,
      @required this.closeText,
      this.actionText,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: <Widget>[
        actionText == null
            ? null
            : FlatButton(
                child: Text(actionText),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (action != null) action();
                }),
        FlatButton(
            child: Text(closeText),
            onPressed: () => Navigator.of(context).pop())
      ],
    );
  }
}
