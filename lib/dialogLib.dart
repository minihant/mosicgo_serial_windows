import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'global.dart' as global;

class DialogLib {
  //----------------------------------
  static final DialogLib _instance = DialogLib._internal();
  factory DialogLib() => _instance;
  //------------------------------------------
  late PackageInfo _packageInfo;
  DialogLib._internal() {
    _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown',
    );
  }
  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;

    //-------------------------------------------------
    final prefs = await SharedPreferences.getInstance();
    String? User = prefs.getString('UserName');
    String? Password = prefs.getString('UserPassword');
    // bool? _RememberMe = prefs.getBool('RememberMe');
    // _LIB.isRemberMe = prefs.getBool('RememberMe')!;
    // if (_User == null) {
    //   User_Name = global.DEFAULT_USERNAME;
    //   User_Password = global.DEFAULT_PASSWORD;
    //   _LIB.Login_User = global.DEFAULT_USERNAME;
    //   _LIB.Login_Password = global.DEFAULT_PASSWORD;
    //   _User = global.DEFAULT_USERNAME;
    //   _Password = global.DEFAULT_PASSWORD;
    //   await prefs.setString('UserName', global.DEFAULT_USERNAME);
    //   await prefs.setString('UserPassword', global.DEFAULT_PASSWORD);
    //   await prefs.setBool('RememberMe', false);
    // } else {
    //   if (_LIB.isRemberMe == true) {
    //     _LIB.Login_User = _User;
    //     _LIB.Login_Password = _Password!;
    //   } else {
    //     // _LIB.Login_User = '';
    //     // _LIB.Login_Password = '';
    //   }
    // }
    print("locl User: $User");
    print("local password: $Password");
    // print("Remember me: ${_LIB.isRemberMe}");
  }

  String getPackageVersion() {
    return _packageInfo.version;
  }

  String getPackageBuildNumber() {
    return _packageInfo.buildNumber;
  }

  String getPackageAppName() {
    return _packageInfo.appName;
  }

  Widget _appInfoWidget() {
    String version = getPackageVersion();
    String buildNumber = getPackageBuildNumber();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('App version: $version',
            style: TextStyle(
              fontSize: 28.sp,
            )),
        Container(height: 10.sp),
        Text(
          global.COMPANY_NAME,
          style: TextStyle(fontSize: 16.sp),
        ),
        Text(
          global.MOSICGO_NAME,
          style: TextStyle(fontSize: 16.sp),
        ),
        Text(
          global.COMPANY_URL,
          style: TextStyle(fontSize: 16.sp),
        ),
        Text(
          global.COPYRIGHT,
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    );
  }

  void showAppInfo(BuildContext context) {
    String appName = getPackageAppName();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: (Text(appName, style: TextStyle(fontSize: 28.sp))),
              content: _appInfoWidget(),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text('Close', style: TextStyle(fontSize: 24.sp)),
                ),
              ],
            ));
  }
}
