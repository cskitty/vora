import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vora/tflite/recognition.dart';
import 'package:vora/tflite/stats.dart';
import 'package:vora/ui/box_widget.dart';
import 'package:vora/ui/camera_view_singleton.dart';
import 'package:vora/speech_singleton.dart';
import 'camera_view.dart';
import 'package:vora/tflite/classifier.dart';
import '../app_theme.dart';

/// [HomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  SpeechSingleton _myTts = SpeechSingleton();
  bool _hasStarted = false;
  String _newVoiceText = "";
  List<String> _maxLabel;
  int _index = 0;
  int unfinished = 0;
  bool opened = false;

  /// Results to draw bounding boxes
  List<Recognition> results;

  /// Realtime stats
  Stats stats;

  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();
    _maxLabel = ["", "", ""];

    _myTts.setVolume(1.0);
    _myTts.speak("Started");
    _myTts.stop();
    CameraViewSingleton.startPredicting = true;
    _hasStarted = true;
  }

  Recognition _getObject(results) {
    Recognition maxObject;
    double maxSize = 0;

    for (var r in results) {
      double sz = r.renderLocation.width * r.renderLocation.width;
      if (sz > maxSize) {
        maxObject = r;
      }
    }
    return maxObject;
  }

  String _getLabel(Recognition r) {
    String maxLabel;

    if (r.position == 'middle') {
      maxLabel = r.label + " in the " + r.position;
    } else {
      maxLabel = r.label + " on the " + r.position;
    }

    return maxLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Recognizer'),
      ),
      key: scaffoldKey,
      backgroundColor: Colors.black87,
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraView(resultsCallback, statsCallback),

          // Bounding boxes
          boundingBoxes(results),

          Align(
            alignment: Alignment(0, 0.65),
            child: SizedBox(
                height: 125, //height of button
                width: 400, //width of button
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _hasStarted
                            ? Colors.red.shade300
                            : Colors.blue.shade300, //background color of button
                        side: BorderSide(
                            width: 2,
                            color: Colors.grey), //border width and color
                        elevation: 10, //elevation of button
                        shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(30)),
                        padding:
                            EdgeInsets.all(20) //content padding inside button
                        ),
                    onPressed: () {
                      setState(() {
                        if (_hasStarted) {
                          _hasStarted = false;

                          _myTts.speak("Stopped");
                          _myTts.stop();

                          CameraViewSingleton.startPredicting = false;
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text(_newVoiceText))),
          ),
        ],
      ),
    );
  }

  /// Returns Stack of bounding boxes
  Widget boundingBoxes(List<Recognition> results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
    );
  }

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    setState(() {
      this.results = results;
      Recognition maxObject = _getObject(results);
      if (maxObject != null &&
          maxObject.label != this._maxLabel[0] &&
          maxObject.label != this._maxLabel[1] &&
          maxObject.label != this._maxLabel[2]) {
        this._newVoiceText = _getLabel(maxObject);
        this._maxLabel[_index++ % 3] = maxObject.label;
        _myTts.speak(this._newVoiceText);
      }
    });
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    setState(() {
      this.stats = stats;
    });
  }
}

/// Row for one Stats field
class StatsRow extends StatelessWidget {
  final String left;
  final String right;

  StatsRow(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(left), Text(right)],
      ),
    );
  }
}
