// ignore_for_file: annotate_overrides, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'key.dart';
import 'dialogLib.dart';
import 'global.dart' as global;
import 'portLib.dart';
import 'setting.dart';

bool kDebugMode = true;

void debugPrint(var msg) {
  if (global.isInDebug) {
    print(msg);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key}) : super(key: key);
  _SerialApp createState() => _SerialApp();
}

class _SerialApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SerialPort'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DialogLib _DialogLib = DialogLib();
  PortLib _PortLib = PortLib();
  Setting _Setting = Setting();

  void Fn_startPollingTimer() {
    int counter = 0;
    Timer.periodic(const Duration(seconds: 1), (pollingTimer) {
      global.ports = SerialPort.getAvailablePorts();
      if (global.ports.contains(global.selectedPort) == false) {
        _PortLib.Fn_closePort();
        if (kDebugMode) {
          debugPrint("port lost");
        }
      }
      debugPrint("timer($counter)");
      counter++;
    });
  }

  //========================================
  Widget widget_writeData() {
    var btn = Padding(
        padding: EdgeInsets.all(10.sp),
        child: TextButton.icon(
          icon: Icon(Icons.send, size: 24.sp),
          label: Text('Write', style: TextStyle(fontSize: 24.sp)),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(width: 2, color: Colors.black12),
            primary: Colors.white,
            backgroundColor: Colors.black,
          ),
          onPressed: () async {
            await _PortLib.Fn_writeKey(KEYID.BTN_OkKey);
          },
        ));
    return btn;
  }

  @override
  void initState() {
    global.ports = SerialPort.getAvailablePorts();
    if (global.ports.isNotEmpty) {
      debugPrint("Available port: ${global.ports}");
      global.selectedPort = global.ports[0];
    }
    _DialogLib.initPackageInfo();
    super.initState();
    //-----------------------
    Fn_startPollingTimer();
    //--------------------
  }

  @override
  void dispose() {
    _PortLib.port.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(600, 800));
    ScreenUtil().setSp(16 * ScreenUtil().scaleWidth);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 28.sp),
        ),
        actions: <Widget>[
          Row(
            children: [
              Text(global.MCU_ver, style: TextStyle(fontSize: 16.sp)),
            ],
          ),
          SizedBox(width: 20.sp),
          Row(
            children: [
              Text(global.statusText, style: TextStyle(fontSize: 24.sp)),
            ],
          ),
          _Setting.widget_selectPort(context),
        ],
      ),
      body: Row(
        children: [
          widget_writeData(),
        ],
      ),
    );
  }
}
