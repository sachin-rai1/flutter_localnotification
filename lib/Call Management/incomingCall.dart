import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localnotification/NotificationService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

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


  var name ;
  var number;
  var formatNumber;

  Future<void> getRecentCalls() async {
    final Iterable<CallLogEntry> cLog = await CallLog.get();

    for (CallLogEntry entry in cLog) {
       name = entry.name;
       number = entry.number;
       formatNumber = entry.formattedNumber;

    }
  }

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

  @override
  void initState() {
    super.initState();
    getRecentCalls();
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
                  return NotificationService()
                      .showNotification(Uuid().v4(), "");
                }
                if (phoneStatus.toString() == callReceived) {
                  return const Icon(Icons.add_call);
                }
                return Container();
              },
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 100,
                    itemBuilder: (BuildContext context, int index) {
                      {
                        print(formatNumber.toString());
                        return Column(
                            children:  [
                              Text(name),
                              Text(formatNumber),
                            ]);
                      }
                    }))
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
