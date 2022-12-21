import 'dart:isolate';
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localnotification/NotificationService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:workmanager/workmanager.dart';

dynamic name;
dynamic number;
dynamic formatNumber;
dynamic catchedNumber;

const String countKey = 'count';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolateCall';

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();

SharedPreferences? prefs;

void callbackDispatcher() {
  Workmanager().executeTask((dynamic task, dynamic inputData) async {
    try {
      final Iterable<CallLogEntry> cLog = await CallLog.get();
      print('Queried call log entries :');
      int i = 0;
      for (CallLogEntry entry in cLog) {
        if (i == 0) {
          print('-------------------------------------');
          formatNumber = entry.formattedNumber;
          catchedNumber = {entry.cachedMatchedNumber};
          number = entry.number;
          name = entry.name;
          print("name :  $name");
          print("format : $formatNumber");
          print("Cactched : $catchedNumber");
          print("Number $number");
          print('TYPE       : ${entry.callType}');
          print(
              'DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}');
          print('DURATION   : ${entry.duration}');
          print('ACCOUNT ID : ${entry.phoneAccountId}');
          print('ACCOUNT ID : ${entry.phoneAccountId}');
          print('SIM NAME   : ${entry.simDisplayName}');
          print('-------------------------------------');

          NotificationService()
              .showNotification(name.toString(), formatNumber.toString());
        }
        i++;
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      return true;
    }
    return true;
  });
}

class GetIncomingCall extends StatefulWidget {
  const GetIncomingCall({Key? key}) : super(key: key);

  @override
  State<GetIncomingCall> createState() => _GetIncomingCallState();
}

class _GetIncomingCallState extends State<GetIncomingCall> {
  PhoneStateStatus status = PhoneStateStatus.NOTHING;
  bool granted = false;
  String incomingCall =
      "AsyncSnapshot<PhoneStateStatus?>(ConnectionState.active, PhoneStateStatus.CALL_INCOMING, null, null)";
  String callDeclined =
      "AsyncSnapshot<PhoneStateStatus?>(ConnectionState.active, PhoneStateStatus.CALL_ENDED, null, null)";
  String callReceived =
      "AsyncSnapshot<PhoneStateStatus?>(ConnectionState.active, PhoneStateStatus.CALL_STARTED, null, null)";

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();
    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
    }
  }

  int _counter = 0;

  Future<void> _incrementCounter() async {
    developer.log('Increment counter!');
    // Ensure we've loaded the updated count from the background isolate.
    await prefs?.reload();

    setState(() {
      _counter++;
    });
  }

  static SendPort? uiSendPort;

  @pragma('vm:entry-point')
  static Future<void> callback() async {
    developer.log('Incoming Call Arrived!');

    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);

    Workmanager().registerOneOffTask(
      DateTime.now().millisecondsSinceEpoch.toString(),
      'simpleTask',
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  @override
  void initState() {
    super.initState();
    port.listen((_) async => await _incrementCounter());
    if (Platform.isIOS) setStream();
    requestPermission();
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
                  callback();
                  return const Icon(Icons.clear);
                }
                if (phoneStatus.toString() == callReceived) {
                  return const Icon(Icons.add_call);
                }
                return ElevatedButton(
                  onPressed: () {
                    Workmanager().registerOneOffTask(
                      DateTime.now().millisecondsSinceEpoch.toString(),
                      'simpleTask',
                      existingWorkPolicy: ExistingWorkPolicy.replace,
                    );
                  },
                  child: const Text("Get Data"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcons() {
    switch (status) {
      case PhoneStateStatus.NOTHING:
        print("Mai kuchh nhi Karunga");
        return Icons.clear;
      case PhoneStateStatus.CALL_INCOMING:
        print("Call aa gaya");
        return Icons.add_call;
      case PhoneStateStatus.CALL_STARTED:
        return Icons.call;
      case PhoneStateStatus.CALL_ENDED:
        return Icons.call_end;
    }
  }

  Color getColor() {
    switch (status) {
      case PhoneStateStatus.NOTHING:
      case PhoneStateStatus.CALL_ENDED:
        return Colors.red;
      case PhoneStateStatus.CALL_INCOMING:
        return Colors.green;
      case PhoneStateStatus.CALL_STARTED:
        return Colors.orange;
    }
  }
}
