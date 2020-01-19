import 'package:flutter/material.dart';

/// Basic Switch template
class MySwitch extends StatefulWidget {
  final void Function(bool) setter;
  final bool Function() getter;
  final void Function() onEnable;
  final void Function() onDisable;

  MySwitch(
      {Key key,
      @required this.setter,
      @required this.getter,
      this.onEnable,
      this.onDisable})
      : super(key: key);

  @override
  MySwitchState createState() => MySwitchState();
}

class MySwitchState extends State<MySwitch> {
  @override
  void initState() {
    super.initState();
  }

  _onEnable() {
    widget.setter(true);
    if (widget.onEnable != null) widget.onEnable();
    setState(() {});
  }

  _onDisable() {
    widget.setter(false);
    if (widget.onDisable != null) widget.onDisable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: widget.getter() ?? false,
      onChanged: (value) => value ? _onEnable() : _onDisable(),
    );
  }
}
