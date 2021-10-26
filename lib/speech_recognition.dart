import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vora/ui/home_view.dart';
import 'package:vora/facetime.dart';
import 'package:vora/settings.dart';
import 'package:vora/speech_singleton.dart';
import 'app_theme.dart';

class SpeechRecognitionPage extends StatefulWidget {
  SpeechRecognitionPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SpeechRecognitionPageState createState() => _SpeechRecognitionPageState();
}

class _SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  bool _isListening = false;
  StreamSubscription _volumeButtonSubscription;
  String _text = 'Press the button and start speaking';
  bool _hasSpeech = false;
  SpeechSingleton _myTts = SpeechSingleton();

  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = '';
  final SpeechToText speech = SpeechToText();

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

      if (tmp.contains("settings") || tmp.contains("setting")) {
        stopListening();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SettingPage(title: "Settings")));
      }

      if (tmp.contains("help") && tmp.contains("me")) {
        stopListening();
        _myTts.speak(
            "Finding volunteers. Volunteer Katherine is ready to help. Press buttom part to start facetime with her.");
        _myTts.stop();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyFaceTimePage()));
      }

      _confidence = result.confidence;

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
  }

  @override
  void dispose() {
    super.dispose();
    // be sure to cancel on dispose
    _volumeButtonSubscription?.cancel();
  }

  //static AudioCache player = new AudioCache();
  // FlutterTts tts = FlutterTts();

  Map<String, HighlightedWord> words = {
    'Object Detector': HighlightedWord(
      onTap: () {
        print('Object Detector');
      },
      textStyle: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'Object Recognition': HighlightedWord(
      onTap: () {
        print('Object Recognition');
      },
      textStyle: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'Text Recognition': HighlightedWord(
      onTap: () {
        print('Text Recognition');
      },
      textStyle: TextStyle(
        color: Colors.indigoAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'Letter Recognition': HighlightedWord(
      onTap: () {
        print('Letter Recognition');
      },
      textStyle: TextStyle(
        color: Colors.indigoAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'Settings': HighlightedWord(
      onTap: () {
        print('Settings');
      },
      textStyle: TextStyle(
        color: Colors.deepPurpleAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  double _confidence = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.blue_grey,
        title: Text(
            '${lastStatus} [${(_confidence * 100.0).toStringAsFixed(1)}%]'),
      ),

      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //floatingActionButton: AvatarGlow(
      //animate: _isListening,
      //glowColor: Theme.of(context).primaryColor,
      //endRadius: 75.0,
      //duration: const Duration(milliseconds: 2000),
      //repeatPauseDuration: const Duration(milliseconds: 100),
      //repeat: true,
      //child: FloatingActionButton(
      //onPressed: _listen,
      //child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      //),
      //),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 70,
              child: Container(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(50.0, 30.0, 30.0, 150.0),
                    child: TextHighlight(
                      text: _text,
                      words: words,
                      textStyle: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 70,
                child: Container(
                  //width: double.infinity,
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 35),
                  child: SizedBox(
                      height: 125, //height of button
                      width: 400, //width of button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:
                                Colors.blueAccent, //background color of button
                            side: BorderSide(
                                width: 3,
                                color:
                                    Colors.lightBlue), //border width and color
                            elevation: 10, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(200)),
                            padding: EdgeInsets.all(
                                20) //content padding inside button
                            ),
                        onPressed: () async {
                          if (!_isListening) {
                            _myTts.speak("Voice command started");
                            _myTts.stop();
                            startListening();
                          } else {
                            _myTts.speak("Stopped listening");
                            _myTts.stop();
                            stopListening();
                          }
                        },
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 70.0,
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
