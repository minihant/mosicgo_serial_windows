// ignore_for_file: annotate_overrides, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'key.dart';
import 'dialogLib.dart';
import 'global.dart' as global;
import 'portLib.dart';
import 'setting.dart';

bool kDebugMode = true;
const borderColor = Color(0xFF805306);

void debugPrint(var msg) {
  if (global.isInDebug) {
    print(msg);
  }
}

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(600, 800);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "mosicgo serial";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // _SerialApp createState() => _SerialApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      // home: const MyHomePage(title: 'SerialPort'),

      home: Scaffold(
        body: WindowBorder(
          color: borderColor,
          width: 1,
          child: Row(
            children: [const LeftSide(), MyHomePage()],
          ),
        ),
      ),
    );
  }
}

// class _SerialApp extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // title: 'Flutter Demo',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       // ),
//       // home: const MyHomePage(title: 'SerialPort'),
//       home: Scaffold(
//         body: WindowBorder(
//           color: borderColor,
//           width: 1,
//           child: Row(
//             children: const [LeftSide(), RightSide()],
//             // children: [MyHomePage()],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  // const MyHomePage({Key? key, required this.title}) : super(key: key);
  MyHomePage({Key? key}) : super(key: key);
  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DialogLib _DialogLib = DialogLib();
  final PortLib _PortLib = PortLib();

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
      setState(() {});
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

    return
        // ChangeNotifierProvider(
        //   create: (BuildContext context) {},
        //   child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'ttt',
        //     style: TextStyle(fontSize: 28.sp),
        //   ),
        //   actions: <Widget>[
        //     Row(
        //       children: [
        //         Text(global.MCU_ver, style: TextStyle(fontSize: 16.sp)),
        //       ],
        //     ),
        //     SizedBox(width: 20.sp),
        //     Row(
        //       children: [
        //         Text(global.statusText, style: TextStyle(fontSize: 24.sp)),
        //       ],
        //     ),
        //     _Setting.widget_selectPort(context),
        //   ],
        // ),
        Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: [0.0, 1.0]),
        ),
        child: Column(children: [
          WindowTitleBarBox(
            child: Row(
              children: [Expanded(child: MoveWindow()), const WindowButtons()],
            ),
          ),
          widget_writeData(),
        ]),
      ),
    );
  }
}

const sidebarColor = Color(0xFFF6A00C);

class LeftSide extends StatelessWidget {
  const LeftSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Setting settingLib = Setting();
    final PortLib _PortLib = PortLib();
    final DialogLib _DialogLib = DialogLib();
    return SizedBox(
        width: 150,
        child: Container(
            color: sidebarColor,
            child: Column(
              children: [
                WindowTitleBarBox(child: MoveWindow()),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: Icon(Icons.info, size: 24.sp),
                  label: Text('About', style: TextStyle(fontSize: 20.sp)),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(width: 2, color: Colors.black12),
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    debugPrint(
                        "App Version: ${_DialogLib.getPackageVersion()}");
                    _DialogLib.showAppInfo(context);
                  },
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: Icon(Icons.info, size: 24.sp),
                  label: Text('Open Port', style: TextStyle(fontSize: 20.sp)),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(width: 2, color: Colors.black12),
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    settingLib.Fn_showPortInfo(context);
                  },
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: Icon(Icons.close, size: 24.sp),
                  label: Text('Close Port', style: TextStyle(fontSize: 20.sp)),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    // fixedSize: ,
                    // side: const BorderSide(width: 2, color: Colors.black12),
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    _PortLib.Fn_closePort();
                  },
                ),
              ],
            )));
  }
}

const backgroundStartColor = Color(0xFFFFD500);
const backgroundEndColor = Color(0xFFF6A00C);

class RightSide extends StatelessWidget {
  const RightSide({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: [0.0, 1.0]),
        ),
        child: Column(children: [
          WindowTitleBarBox(
            child: Row(
              children: [Expanded(child: MoveWindow()), const WindowButtons()],
            ),
          )
        ]),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  _WindowButtonsState createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
