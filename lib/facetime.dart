import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFaceTimePage extends StatefulWidget {
  @override
  _MyFaceTimePageState createState() => _MyFaceTimePageState();
}

class _MyFaceTimePageState extends State<MyFaceTimePage> {

  @override
  void initState() {
    _getThingsOnStartup().then((value){
      print('Async done');
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Navigator.pop(context);
    return Container();
  }

  Future _getThingsOnStartup() async {
    _launchURL();
  }
 
  _launchURL() async {
    final String url = 'facetime:9497748505';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}