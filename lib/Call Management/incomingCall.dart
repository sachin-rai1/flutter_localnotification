import 'dart:developer';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localnotification/NotificationService.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


SharedPreferences? prefs;

class GetIncomingCall extends StatefulWidget {
  const GetIncomingCall({Key? key}) : super(key: key);

  @override
  State<GetIncomingCall> createState() => _GetIncomingCallState();
}

class _GetIncomingCallState extends State<GetIncomingCall> {
  dynamic name;
  dynamic number;
  dynamic formatNumber;
  dynamic catchedNumber;
  dynamic callDuration;

  PhoneStateStatus status = PhoneStateStatus.NOTHING;

  bool granted = false;

  String incomingCall =
      "AsyncSnapshot<PhoneStateStatus?>(ConnectionState.active, PhoneStateStatus.CALL_INCOMING, null, null)";
  String callDeclined =
      "AsyncSnapshot<PhoneStateStatus?>(ConnectionState.active, PhoneStateStatus.CALL_ENDED, null, null)";
  String callReceived =
      "AsyncSnapshot<PhoneStateStatus?>(ConnectionState.active, PhoneStateStatus.CALL_STARTED, null, null)";

  var callPermission;

  Future<bool> requestPermission() async {
    log("I came Here");
    var status = await Permission.phone.request();
    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        prefs?.setBool("callPermission", true);
        return true;
    }
  }

  var overlayStatus;

  Future<bool?> requestOverLayPermission() async {

    overlayStatus = await FlutterOverlayWindow.isPermissionGranted();
    log("Is Permission Granted: $overlayStatus");
    prefs?.setBool("overlay", overlayStatus);

    final bool? res = await FlutterOverlayWindow.requestPermission();
    log("status: $res");

    if (await FlutterOverlayWindow.isActive()) {
      return null;
    }

    await FlutterOverlayWindow.showOverlay(
      height: 0,
      width: 0,
      enableDrag: false,
      overlayTitle: "PersonalApp",
      overlayContent: 'Started',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilitySecret,
      positionGravity: PositionGravity.right,
    );
    return null;
  }


  Future<void> getState()  async{
    overlayStatus = prefs?.get("overlay");
    callPermission = prefs?.get("callPermission");

  }



  Future<void> callbackDispatcher() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      Iterable<CallLogEntry> cLog = await CallLog.get();
      log('Queried call log entries :');
      int i = 0;
      for (CallLogEntry entry in cLog) {
        if (i == 0) {
          log('-------------------------------------');
          formatNumber = entry.formattedNumber;
          catchedNumber = {entry.cachedMatchedNumber};
          number = entry.number;
          name = entry.name ?? "Unknown";
          log("name :  $name");
          log("format : $formatNumber");
          log("Cached : $catchedNumber");
          log("Number $number");
          log('TYPE       : ${entry.callType}');
          log('DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}');
          callDuration = entry.duration;
          log('DURATION   : ${entry.duration}');
          log('ACCOUNT ID : ${entry.phoneAccountId}');
          log('ACCOUNT ID : ${entry.phoneAccountId}');
          log('SIM NAME   : ${entry.simDisplayName}');
          log('-------------------------------------');

          if (callDuration > 0) {
            await NotificationService().showNotification(name, number);
          }
        }
        i++;
      }
    } on PlatformException catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getState();
    if (Platform.isIOS) setStream();
    if(callPermission != true) {
      requestPermission();
    }
  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      setState(() {
        if (event != null) {
          status = event;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone State"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (Platform.isAndroid)
              MaterialButton(
                onPressed: !granted
                    ? () async {
                        bool temp = await requestPermission();
                        setState(() {
                          granted = temp;
                          if (granted) {
                            setStream();
                          }
                        });
                      }
                    : null,
                child: const Text("Request permission of Phone"),
              ),
            const Text(
              "Status of call",
              style: TextStyle(fontSize: 24),
            ),
            StreamBuilder<PhoneStateStatus?>(
              initialData: PhoneStateStatus.NOTHING,
              stream: PhoneState.phoneStateStream,
              builder: (BuildContext context,
                  AsyncSnapshot<PhoneStateStatus?> phoneStatus) {
                if (phoneStatus.toString() == incomingCall) {
                  return FloatingActionButton(onPressed: () {});
                }

                if (phoneStatus.toString() == callDeclined) {
                  callbackDispatcher();
                  return const Icon(Icons.clear);
                }

                if (phoneStatus.toString() == callReceived) {
                  return const Icon(Icons.add_call);
                }
                return Container();
              },
            ),
            ElevatedButton(
              onPressed: () {

                log(overlayStatus.toString());
                if (overlayStatus == false || overlayStatus == null) {
                  requestOverLayPermission();
                }

              },
              child: const Text("Get Data"),
            ),
          ],
        ),
      ),
    );
  }
}
