import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'global.dart' as global;
import 'dialogLib.dart';
import 'portLib.dart';

class Setting {
  final DialogLib _DialogLib = DialogLib();
  final PortLib _PortLib = PortLib();

  void Fn_showPortInfo(BuildContext context) {
    int items = global.ports.length;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select Port"),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(global.ports[index]),
                      onTap: () async {
                        global.selectedPort = global.ports[index];
                        var result = _PortLib.Fn_openPort(context);
                        result
                            ? (global.statusText = global.selectedPort)
                            : (global.statusText = "Can Not Open");

                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  void Fn_setupSelect(BuildContext context, int item) {
    switch (item) {
      case 0:
        debugPrint("App Version: ${_DialogLib.getPackageVersion()}");
        _DialogLib.showAppInfo(context);
        break;
      case 1:
        Fn_showPortInfo(context);
        break;
      case 2:
        _PortLib.Fn_closePort();
        break;
    }
  }

  Widget widget_selectPort(BuildContext context) {
    var popupMenuButton = PopupMenuButton<int>(
      icon: const Icon(Icons.settings),
      iconSize: 40.sp,
      color: Colors.lightBlueAccent,
      onSelected: (item) => Fn_setupSelect(context, item),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.info_outline),
              SizedBox(width: 8.sp),
              Text('About', style: TextStyle(fontSize: 28.sp)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.info_outline),
              SizedBox(width: 8.sp),
              Text('Open Port', style: TextStyle(fontSize: 28.sp)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.info_outline),
              SizedBox(width: 8.sp),
              Text('Close Port', style: TextStyle(fontSize: 28.sp)),
            ],
          ),
        ),
        // PopupMenuItem<int>(
        //   value: 2,
        //   child: Row(
        //     children: [
        //       const Icon(Icons.settings),
        //       SizedBox(width: 8.sp),
        //       Text(
        //         'User & Password',
        //         style: TextStyle(fontSize: 28.sp),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
    return popupMenuButton;
  }
}
