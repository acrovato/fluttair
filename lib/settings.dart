import 'package:flutter/material.dart';

import 'sidebar.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
            children: <Widget>[
              CheckboxListTile(
                value: false,
                title: Text("This is a CheckBoxPreference"),
                onChanged: (value) {},
              ),
              SwitchListTile(
                value: false,
                title: Text("This is a SwitchPreference"),
                onChanged: (value) {},
              ),
              ListTile(
                title: Text("This is a ListPreference"),
                subtitle: Text("Subtitle goes here"),
                onTap: (){},
              )
            ]
        )
    );
  }
}
