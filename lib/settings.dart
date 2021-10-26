import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'app_theme.dart';
import 'tts_settings.dart';
import 'package:flutter/cupertino.dart';
import 'profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vora/speech_singleton.dart';
import 'profile_info.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vora/ui/home_view.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.title}) : super(key: key);

  //GOALS
  // 1. Audio Settings (for Text to Speech): volume, pitch, male/female, language
  //

  final String title;

  @override
  _SettingPageState createState() => _SettingPageState();
}

_savedName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('Full Name', userSettings.name);
}

_savedVolume() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('Volume', TTSsettings.newVolume);

  SpeechSingleton().setVolume(TTSsettings.newVolume);
}

_savedPitch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('Pitch', TTSsettings.newPitch);

  SpeechSingleton().setPitch(TTSsettings.newPitch);
}

_savedRate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('Rate', TTSsettings.newRate);

  SpeechSingleton().setSpeechRate(TTSsettings.newRate);
}

class _SettingPageState extends State<SettingPage> {
  SpeechSingleton _myTts = SpeechSingleton();

  TextEditingController _name = new TextEditingController();
  bool _enabled = false;

  FlutterTts flutterTts;

  dynamic languages;
  String language;

  // stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = '';
  final stt.SpeechToText speech = stt.SpeechToText();
  bool _hasSpeech = false;

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void startListening() {
    _text = "started";
    lastError = "";
    speech.listen(onResult: resultListener);
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);

    setState(() {
      _isListening = true;
    });
  }

  void stopListening() {
    speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      if (result.recognizedWords == _text) {
        return;
      }

      _text = result.recognizedWords;
      var tmp = _text.toLowerCase();
      if (tmp.contains("object") &&
          (tmp.contains("detection") ||
              tmp.contains("recognition") ||
              tmp.contains("detect") ||
              tmp.contains("recognizer"))) {
        stopListening();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeView()));
      }

      if (tmp.contains("volume") &&
          (tmp.contains("change") ||
              tmp.contains("increase") ||
              tmp.contains("up"))) {
        stopListening();
        if (TTSsettings.newVolume <= 0.8) {
          TTSsettings.newVolume = TTSsettings.newVolume + 0.2;
          _savedVolume();
        }
        if (TTSsettings.newVolume > 0.8) {
          TTSsettings.newVolume = 1.0;
          _savedVolume();
        }
      }

      if (tmp.contains("volume") &&
          (tmp.contains("change") ||
              tmp.contains("decrease") ||
              tmp.contains("down"))) {
        stopListening();
        if (TTSsettings.newVolume >= 0.2) {
          TTSsettings.newVolume = TTSsettings.newVolume - 0.2;
          _savedVolume();
        }
      }

      if (tmp.contains("rate") &&
          (tmp.contains("change") ||
              tmp.contains("increase") ||
              tmp.contains("up"))) {
        stopListening();
        if (TTSsettings.newRate <= 0.8) {
          TTSsettings.newRate = TTSsettings.newRate + 0.2;
          _savedRate();
        }
        if (TTSsettings.newRate > 0.8) {
          TTSsettings.newRate = 1.0;
          _savedRate();
        }
      }
      if (tmp.contains("rate") &&
          (tmp.contains("change") ||
              tmp.contains("decrease") ||
              tmp.contains("down"))) {
        stopListening();
        if (TTSsettings.newRate >= 0.2) {
          TTSsettings.newRate = TTSsettings.newRate - 0.2;
          _savedRate();
        }
      }

      if (tmp.contains("pitch") &&
          (tmp.contains("change") ||
              tmp.contains("decrease") ||
              tmp.contains("down"))) {
        stopListening();
        if (TTSsettings.newPitch >= 0.8) {
          TTSsettings.newPitch = TTSsettings.newPitch - 0.3;
          _savedPitch();
        }
        if (TTSsettings.newPitch < 0.8) {
          TTSsettings.newPitch = 0.5;
          _savedPitch();
        }
      }

      if (tmp.contains("pitch") &&
          (tmp.contains("change") ||
              tmp.contains("increase") ||
              tmp.contains("up"))) {
        stopListening();
        if (TTSsettings.newPitch <= 1.7) {
          TTSsettings.newPitch = TTSsettings.newPitch + 0.3;
          _savedPitch();
        }
        if (TTSsettings.newPitch > 1.7) {
          TTSsettings.newPitch = 2.0;
          _savedPitch();
        }
      }

      if (result.finalResult) {
        _isListening = false;
      }
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
    stt.SpeechToText speech = stt.SpeechToText();
    speech = stt.SpeechToText();
    //_getLanguages();
  }

  //static AudioCache player = new AudioCache();
  FlutterTts tts = FlutterTts();
  var speech_input = "Hello, how can I help?";

  // Future _getLanguages() async {
  //   languages = await flutterTts.getLanguages;
  //   print("print ${languages}");
  //   if (languages != null) setState(() => languages);
  // }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (String type in languages) {
      items.add(DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            //if (val.hasConfidenceRating && val.confidence > 0) {
            //_confidence = val.confidence;
            //}
            // if (_text == "open object detector" || _text == "open object recognition" || _text == "object detection" || _text == "object recognizer" ||_text == "detect objects"|| _text == "recognize objects"){
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => HomePage(cameras))
            //   );
            // }
            // if (_text == "open letter recognition"){
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => LetterRecognitionPage(title: "Letter Recognition"))
            //   );
            // }
            // if (_text == "open settings"){
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => SettingPage(title: "Settings"))
            //   );
            //};
            // if (_text == "Mute??"){
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => LetterRecognitionPage(title: "Letter Recognition"))
            //   );
            // }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.blue_grey,
        title: Text(widget.title),
      ),
      body:
          // Container(
          //   height: 100.0,
          //   child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemExtent: 100.0,
          //       itemCount: temp.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         return ListTile(
          //             title: Text(temp[index]),
          //             onTap: () {
          //               print(temp[index]);
          //             });
          //       }),
          // ),
          //  Container(
          //    child: Text('data'),
          //  )

          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // children: <Widget>[
          //   ListView.builder(
          //       scrollDirection: Axis.vertical,
          //       shrinkWrap: true,
          //       itemCount: 5,
          //       itemExtent: 50,
          //       itemBuilder: (context, index) {
          //       }
          //   ),
          children: [
            Row(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 20),
                  //height: 500,
                  // width: 200,
                  child: CircleAvatar(
                    radius: 45.0,
                    backgroundImage: AssetImage('assets/examplepfp.jpeg'),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 30),
                  child: Text(
                    "Katherine Hua",
                    style: TextStyle(
                      fontFamily: "SF Pro Display Regular",
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 50, right: 10, top: 30, bottom: 30),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 30.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                //)
              ],
            ),

            //           Container (
            //
            //             //height: 300,
            //           margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
            //           child: ListTile(
            //           leading: Container(
            //             height: 500,
            //             // width: 200,
            //             child: CircleAvatar(
            //               radius: 50.0,
            //               backgroundImage: AssetImage(
            //                   'assets/examplepfp.jpeg'),
            //             ),
            //           ),
            //           title: Text( "Kathy",
            //
            //           ),
            //           //subtitle: Text("Kathy"),
            //           // onTap:  () => ,//Navigator.push(
            //           // //context,
            // //MaterialPageRoute(builder: (context) => ))
            // //),
            //           trailing:  Icon(
            //           Icons.arrow_forward_ios_rounded,
            //           size: 24.0,
            //
            //           color: Colors.black54,
            // ),
            //
            // ),
            // Expanded(
            //     flex: 35,
            //     child: Container(
            //         margin: EdgeInsets.only(top: 10),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Container(
            //               margin: EdgeInsets.only(bottom: 15),
            //               child: CircleAvatar(
            //                 backgroundColor: Colors.brown.shade800,
            //                 radius: 55,
            //                 child: const Text('KH'),
            //               ),
            //             ),
            //             // Container(
            //             //   margin: const EdgeInsets.only(bottom: 10),
            //             //   width: 150,
            //             //   alignment: Alignment.center,
            //             //   child: _enabled
            //             //       ? new TextFormField(controller: _name)
            //             //       : new FocusScope(
            //             //           node: new FocusScopeNode(),
            //             //           child: new TextFormField(
            //             //             textAlign: TextAlign.center,
            //             //             controller: _name,
            //             //             onChanged: (value) {
            //             //               setState(() {});
            //             //             },
            //             //             style: theme.textTheme.subhead.copyWith(
            //             //               color: Colors.black,
            //             //             ),
            //             //             decoration: new InputDecoration(
            //             //               hintText:
            //             //                   _enabled ? _name : 'Edit name',
            //             //             ),
            //             //           ),
            //             //         ),
            //             // ),
            //         Container(
            //           //margin: const EdgeInsets.only(bottom: 10),
            //           width: 150,
            //           alignment: Alignment.center,
            //           child: _enabled
            //               ? new TextFormField(controller: _name)
            //               : new FocusScope(
            //             node: new FocusScopeNode(),
            //             child: new TextFormField(
            //               textAlign: TextAlign.center,
            //               controller: _name,
            //               onChanged: (name_value) {
            //                 setState(() => userSettings.name = name_value);
            //                 _savedName();
            //               },
            //               // onSaved: (String value) {
            //               //   setState(() => userSettings.name = value);
            //               //   _savedName();
            //               //   // This optional block of code can be used to run
            //               //   // code when the user saves the form.
            //               // },
            //               // style: theme.textTheme.subhead.copyWith(
            //               //   color: Colors.black,
            //               // ),
            //               decoration: new InputDecoration(
            //                 hintText:
            //                 _enabled ? _name : userSettings.name ,
            //               ),
            //             ),
            //           ),
            //         ),
            //           ],
            //         )
            //         )),
            // ),
            // Expanded(
            //     flex: 30,
            //     child: ListView(
            //         //scrollDirection: Axis.vertical,
            //         children: [
            //           //languages != null ? _languageDropDownSection() : Text("Language"),
            //           _buildSliders()
            //         ])),
            Expanded(
                flex: 25,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      //languages != null ? _languageDropDownSection() : Text(""),
                      _buildSliders()
                    ]))),

            Expanded(
              flex: 45,
              child: Container(
                  //width: double.infinity,
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 35),
                  child: SizedBox(
                    // height: 125, //height of button
                    // width: 400, //width of button
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors
                                .blueGrey.shade300, //background color of button
                            //border width and color
                            elevation: 10, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(500)),
                            padding: EdgeInsets.all(
                                20) //content padding inside button
                            ),
                        onPressed: () async {
                          //playAudio();
                          //_listen();
                          if (!_isListening) {
                            startListening();
                          } else {
                            stopListening();
                          }
                        },
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 60.0,
                          // IconData),
                        )),
                  )),
            ),
          ],
        ),
      ),
    );

    // floatingActionButton: new FloatingActionButton(
    //     child: new Icon(icon),
    //     onPressed: () {
    //       setState(() {
    //         _enabled = !_enabled;
    //       });
    //     }
    // ),
    // This trailing comma makes auto-formatting nicer for build methods.
    //);
  }

  // Widget _languageDropDownSection() => Container(
  //     padding: EdgeInsets.only(top: 20.0),
  //     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       DropdownButton(
  //           //value: language,
  //           //items: getLanguageDropDownMenuItems(language),
  //           //onChanged: changedLanguageDropDownItem,
  //           )
  //     ]));

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              //margin: const EdgeInsets.only(top: 3.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  Widget _buildSliders() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Text(
            "Volume",
            style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
              color: Colors.black,
              //fontWeight: FontWeight.bold
            ),
          ),
        ),
        _volume(),
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Text(
            "Pitch",
            style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
              color: Colors.black,
              //fontWeight: FontWeight.bold
            ),
          ),
        ),
        _pitch(),
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Text(
            "Rate",
            style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
              color: Colors.black,
              //fontWeight: FontWeight.bold
            ),
          ),
        ),
        _rate()
      ],
    );
  }

  Widget _volume() {
    return Slider(
      value: TTSsettings.newVolume,
      onChanged: (newVolume) {
        setState(() => TTSsettings.newVolume = newVolume);
        _savedVolume();
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      //label: 'Volume: $_value',
      activeColor: Colors.grey.shade600,
      inactiveColor: Colors.grey.shade300,
    );
  }

  Widget _pitch() {
    return Slider(
      value: TTSsettings.newPitch,
      onChanged: (newPitch) {
        setState(() => TTSsettings.newPitch = newPitch);
        _savedPitch();
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      //label: "Pitch: $TTSsettings.newPitch,",
      activeColor: Colors.grey.shade600,
      inactiveColor: Colors.grey.shade300,
    );
  }

  Widget _rate() {
    return Slider(
      value: TTSsettings.newRate,
      onChanged: (newRate) {
        setState(() => TTSsettings.newRate = newRate);
        _savedRate();
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      //label: "Rate: $TTSsettings.newRate",
      activeColor: Colors.grey.shade600,
      inactiveColor: Colors.grey.shade300,
    );
  }
}
