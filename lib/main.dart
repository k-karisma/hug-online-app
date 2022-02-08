// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hug Online Thailand',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  final playerState = FlutterRadioPlayer.flutter_radio_paused;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  double volume = 0.8;
  FlutterRadioPlayer _flutterRadioPlayer = FlutterRadioPlayer();

  @override
  void initState() {
    super.initState();
    initRadioService();
  }

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init(
        "Flutter Radio Example",
        "Live",
        "http://27.254.119.26:8888/HugRadioThailand.m3u", //https://cdn-th2.livestreaming.in.th/shoutcast/8200
        "true", //http://27.254.119.26:8888/HugRadioThailand.m3u
      );
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          SizedBox(
              width: 250,
              height: 250,
              child: Image.asset("assets/images/new_logo.png")),
          Container(
              //decoration: BoxDecoration(color: Colors.lightGreen),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<String?>(
                    stream: _flutterRadioPlayer.isPlayingStream,
                    initialData: widget.playerState,
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      String? returnData = snapshot.data;
                      print("object data:$returnData");
                      switch (returnData) {
                        case FlutterRadioPlayer.flutter_radio_stopped:
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            child: Text("Start listening now"),
                            onPressed: () async {
                              await initRadioService();
                            },
                          );
                          break;
                        case FlutterRadioPlayer.flutter_radio_loading:
                          return Text("Loading stream...");
                        case FlutterRadioPlayer.flutter_radio_error:
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            child: Text("Retry ?"),
                            onPressed: () async {
                              await initRadioService();
                            },
                          );
                          break;
                        default:
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                iconSize: 64,
                                color: Colors.orange,
                                onPressed: () async {
                                  print("button press data: " +
                                      snapshot.data.toString());
                                  await _flutterRadioPlayer.playOrPause();
                                },
                                icon: snapshot.data ==
                                        FlutterRadioPlayer.flutter_radio_playing
                                    ? Icon(Icons.pause)
                                    : Icon(Icons.play_arrow),
                              ),
                            ],
                          );
                          break;
                      }
                    },
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 1.0,
                      onChanged: (value) => setState(
                        () {
                          volume = value;
                          _flutterRadioPlayer.setVolume(volume);
                        },
                      ),
                    ),
                  )
                ],
              )),
          Text("คลื่นหมีน่ารักฮักออนไลน์",
              style: TextStyle(fontSize: 18, color: Colors.black)),
          Text("Hug Online Thailand",
              style: TextStyle(fontSize: 18, color: Colors.black)),
          SizedBox(height: 5),
          SizedBox(
              width: 180,
              height: 180,
              child: Image.asset("assets/images/hugradio1.png")),
          SizedBox(height: 5),
          SizedBox(
            child: Image.asset("assets/images/coverDJ.jpg"),
          )
        ],
      ),
    ));
  }
}
