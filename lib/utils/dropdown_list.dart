import 'package:flutter/material.dart';

/// Dropdown list template
class DropdownList extends StatefulWidget {
  final int initial;
  final Future<List<dynamic>> data;
  final void Function(int) onChanged;

  DropdownList(
      {Key key, @required this.initial, @required this.data, this.onChanged})
      : super(key: key);

  @override
  DropdownListState createState() => DropdownListState();
}

class DropdownListState extends State<DropdownList> {
  int _id;

  @override
  void initState() {
    super.initState();
    _id = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.data,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return DropdownButton<int>(
            value: _id,
            onChanged: (int value) {
              if (widget.onChanged != null) widget.onChanged(value);
              setState(() => _id = value);
            },
            items: List.generate(
                snapshot.data.length,
                (int i) => DropdownMenuItem<int>(
                    value: i, child: Text(snapshot.data[i].toString()))),
          );
        } else if (snapshot.hasError) {
          throw snapshot.error;
        } else
          return Text('No data');
      },
    );
  }
}
