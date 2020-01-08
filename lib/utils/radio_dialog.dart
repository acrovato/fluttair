import 'package:flutter/material.dart';

/// Dialog with radio tiles template
class RadioDialog extends StatefulWidget {
  final int initial;
  final Future<List<dynamic>> data;
  final void Function(int) onChoiceChanged;
  final String title;

  RadioDialog(
      {Key key,
      this.initial,
      this.data,
      this.onChoiceChanged,
      this.title})
      : super(key: key);

  @override
  RadioDialogState createState() => RadioDialogState();
}

class RadioDialogState extends State<RadioDialog> {
  bool _visible;
  int _id;

  @override
  void initState() {
    super.initState();
    _visible = false;
    _id = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: FutureBuilder(
          future: widget.data,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData && snapshot.data.length != 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return RadioListTile(
                        title: Text(snapshot.data[i].name),
                        value: snapshot.data[i].id as int,
                        groupValue: _id ?? snapshot.data.length + 1,
                        onChanged: (int value) {
                          _visible = true;
                          setState(() => _id = value);
                        });
                  });
            } else if (snapshot.hasError) {
              return Container(
                  child: Text(snapshot.error.toString()),
                  margin: EdgeInsets.all(10));
            } else
              return Center(child: Text('No data'));
          }),
      actions: <Widget>[
        Visibility(
            visible: _visible,
            child: FlatButton(
                child: Text("Set"),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onChoiceChanged(_id);
                  setState(() {});
                })),
        FlatButton(
            child: Text("Cancel"), onPressed: () => Navigator.of(context).pop())
      ],
    );
  }
}
