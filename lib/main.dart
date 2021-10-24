import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vora/app_theme.dart';
import 'package:vora/tts_settings.dart';
import 'speech_recognition.dart';
import 'ui/home_view.dart';
import 'settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  TTSsettings.newVolume = (prefs.getDouble('Volume') ?? 1);
  TTSsettings.newPitch = (prefs.getDouble('Pitch') ?? 1.25);
  TTSsettings.newRate = (prefs.getDouble('Rate') ?? 0.5);

  //print(TTSsettings.newVolume);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vora',
      theme: ThemeData(
        primaryColor: AppTheme.colors.blue_grey,
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "Visual Aid"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _pagelist = [];

  @override
  void initState() {
    _pagelist
      ..add(SpeechRecognitionPage(title: 'Speech Assistant'))
      ..add(HomeView())
      ..add(SettingPage(title: 'Settings'));
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //appBar: AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      //title: Text(widget.title),
      //),
      body: _pagelist[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Speak',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.grey),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.grey.shade300,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
