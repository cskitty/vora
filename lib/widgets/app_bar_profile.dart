import 'package:flutter/material.dart';
//import 'settings.dart';
import 'package:flutter/cupertino.dart';


AppBar buildAppBar (BuildContext context) {
  final light_icon = CupertinoIcons.moon_stars;
  return AppBar(
    title: Text("Profile"),
    leading: BackButton(),
    elevation: 0,
    backgroundColor: Colors.transparent,
    actions: [
      IconButton(
      icon: Icon(light_icon),
        onPressed: () {},
  )
  ]
  );
}