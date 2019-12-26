import 'package:flutter/material.dart';

class RadioDialog extends StatefulWidget {
  final int initial;
  final Future<List<dynamic>> choiceList;
  final void Function(int) onChoiceChanged;
  final String title;

  RadioDialog(
      {Key key,
      this.initial,
      this.choiceList,
      this.onChoiceChanged,
      this.title})
      : super(key: key);

  @override
  RadioDialogState createState() => RadioDialogState();
}

class RadioDialogState extends State<RadioDialog> {
  bool _visible;
  int _choice;

  @override
  void initState() {
    super.initState();
    _visible = false;
    _choice = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: FutureBuilder(
          future: widget.choiceList,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData && snapshot.data.length != 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return RadioListTile(
                        title: Text(snapshot.data[i].name),
                        value: i,
                        groupValue: _choice ?? snapshot.data.length + 1,
                        onChanged: (int value) {
                          _visible = true;
                          setState(() => _choice = value);
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
                  widget.onChoiceChanged(_choice);
                  setState(() {});
                })),
        FlatButton(
            child: Text("Cancel"), onPressed: () => Navigator.of(context).pop())
      ],
    );
  }
}
