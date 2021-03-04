import 'dart:async';

import 'package:appyHigh/pages/CallPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class waitingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _waitingState();
  }
}

class _waitingState extends State<waitingScreen> {
  Timer _timer;
  int counter = 15;
  String time='15';

  @override
  void initState() {
    intializeTimer();
    initializeFirebase();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void intializeTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      counter -= 1;
      if (counter == 0) {
        Fluttertoast.showToast(msg: 'Please try again later.');
        addToFirestore(ourChannelName, 'unavailable');
        Navigator.of(context).pop();
      } else {
        setState(() {
          time = '0$counter';
          time = time.substring(time.length - 2);
        });
      }
    });
  }

  void initializeFirebase() async {
    print('looool');
    DocumentSnapshot snap = await Firestore.instance
        .collection('CallDetails')
        .document('live')
        .get();
    Map<String, dynamic> details = snap.data ?? {};
    ourChannelName = 'randomCall${details.length}';
    bool foundWaiting = false;
    String channel;
    details.forEach((key, value) {
      if (!foundWaiting && value == 'waiting') {
        channel = key;
        foundWaiting = true;
      }
    });
    if (foundWaiting) {
      addToFirestore(channel, 'joining');
      onJoin(channel);
    } else {
      await addToFirestore(ourChannelName, 'waiting');
      Stream<DocumentSnapshot> subsrciption = Firestore.instance
          .collection('CallDetails')
          .document('live')
          .snapshots();
//      StreamBuilder();
      subsrciption.listen((event) async {
        DocumentSnapshot snap = await event.reference.get();
        if (snap[ourChannelName] == 'joining') {
          onJoin(ourChannelName);
        }
      });
    }
  }

  String ourChannelName = '';
  bool callStarted = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '00:$time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text('Looking for users...'),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          await addToFirestore(ourChannelName, 'unavailable');
          return true;
        });
  }

  Future<void> addToFirestore(String key, String val) {
//    Firest
    print('adding to bd... $key $val');
    Firestore.instance
        .collection('CallDetails')
        .document('live')
        .setData({key: val}, merge: true);
  }

  Future<void> onJoin(String channelName) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(channelName: channelName),
        ),
        (route) => route.isFirst);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
