import 'package:flutter/material.dart';

import 'package:serial_port_win32/serial_port_win32.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'key.dart';
import 'global.dart' as global;

class PortStatus with ChangeNotifier {
  get portStatus => global.statusText;
  void setStatus(String msg) {
    global.statusText = msg;
  }
}

class PortLib {
  late SerialPort port;
  List<int> inBytes = [];
  // late PackageInfo _packageInfo;
  //----------------------------------
  static final PortLib _instance = PortLib._internal();
  factory PortLib() => _instance;
  //------------------------------------------
  PortLib._internal() {
    port = SerialPort(
      global.selectedPort,
      BaudRate: 115200,
      openNow: false,
      ByteSize: 8,
      StopBits: 0,
      Parity: 0,
    );
  }
  void debugPrint(var msg) {
    if (global.isInDebug) {
      print(msg);
    }
  }

  Future<void> Fn_writeKey(KEYID id) async {
    String msg = 'K ${id.index.toString().padLeft(3, '0')}\r\n';
    if (port.isOpened) {
      port.writeBytesFromString(msg);
    }
  }

  Future<void> Fn_writeMsg(String msg) async {
    String data = '${msg}\r\n';
    if (port.isOpened) {
      port.writeBytesFromString(data);
    }
  }

  void Fn_dataParser(var value) {
    if (value[0] == 10) {
      String msg = String.fromCharCodes(inBytes);
      debugPrint("${msg}");
      //----------------------------------------
      if (msg.contains('SW Version:')) {
        global.MCU_ver = msg.replaceAll('SW Version:', '');
        // setState(() {});
      }
      inBytes.clear();
    } else if (value[0] == 13) {
    } else {
      inBytes.addAll(value);
    }
  }

  bool Fn_openPort(BuildContext context) {
    port = SerialPort(
      global.selectedPort,
      BaudRate: 115200,
      openNow: false,
      ByteSize: 8,
      StopBits: 0,
      Parity: 0,
    );
    if (port.isOpened) {
      port.close();
    }
    try {
      port.open();
      port.readOnListenFunction = (value) {
        Fn_dataParser(value);
      };
      debugPrint("Open(${port.isOpened}) : ${port.portName}");
      global.statusText = port.portName;

      return true;
    } catch (e) {
      debugPrint("open error ${e.toString()}");
      return false;
    }
  }

  void Fn_closePort() {
    port = SerialPort(global.selectedPort);
    port.close();

    global.statusText = "Port Not Open";

    debugPrint("Close : ${port.portName}");
  }
}


// class PoetWidget extends StatefulWidget {
//   @override
//   _PoetWidget createState() => _PoetWidget();
// }

// class _PoetWidget extends State<PortStatus> {}
