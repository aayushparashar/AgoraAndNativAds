import 'package:appyHigh/utils/AppID.dart';
import 'package:appyHigh/pages/waitingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'CallPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nativeAdController = NativeAdmobController();
  final myController = TextEditingController();
  bool _validateError = false;

  @override
  void initState() {
//    _nativeAdmob = NativeAdmob(adUnitID: adUnitId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply High'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Image(
                    image: AssetImage('assets/appyHigh.png'),
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  child: NativeAdmob(
                    adUnitID: adUnitId,
                    loading: Center(child: CircularProgressIndicator()),
                    error: Text("Failed to load the ad"),
                    type: NativeAdmobType.full,
                    controller: _nativeAdController,
                    numberAds: 3,
                    options: NativeAdmobOptions(
                      ratingColor: Colors.red,

                      // Others ...
                    ),
                  ),
                  height: 200,
                  width: 200,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: MaterialButton(
                    elevation: 5,
                    shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: onJoin,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                    height: 40,
                    color: Colors.redAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Get Started',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {

//    await _handleCameraAndMic(Permission.camera);
//    await _handleCameraAndMic(Permission.microphone);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => waitingScreen()//CallPage(channelName: 'randomVideoCall'),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
