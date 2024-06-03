export 'dart:io';
export 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class Global {
  static bool isMobile = false;
  static bool isMacOS = Platform.isMacOS;
  static bool isWindows = Platform.isWindows;
  static dynamic token;
  static SharedPreferences? prefs;

  static Future init() async {
    // iOS和Android端
    try {
      token = await getStorage('token');
      isMobile = Platform.isAndroid || Platform.isIOS;

      if (Platform.isMacOS || Platform.isWindows) {
        WidgetsFlutterBinding.ensureInitialized();
        // 必须加上这一行。
        await windowManager.ensureInitialized();
        WindowOptions windowOptions = const WindowOptions(
          minimumSize: Size(900, 626),
          size: Size(900, 626),
          center: true,
          backgroundColor: Colors.transparent,
          skipTaskbar: false,
          titleBarStyle: TitleBarStyle.hidden,
        );
        windowManager.waitUntilReadyToShow(windowOptions, () async {
          await windowManager.show();
          await windowManager.focus();
        });
      }

    } catch (e) {
      isMobile = false;
    }
  }

  static _init() async {
    try {
      prefs ??= await SharedPreferences.getInstance();
    } catch (e) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  static setStorage(String key, dynamic value) async {
    await _init();
    String type;
    if (value is Map || value is List) {
      type = 'String';
      value = jsonDecode(value);
    } else {
      type = value.runtimeType.toString();
    }

    switch (type) {
      case 'String':
        prefs?.setString(key, value);
        break;
      case 'int':
        prefs?.setInt(key, value);
        break;
      case 'double':
        prefs?.setDouble(key, value);
        break;
      case 'bool':
        prefs?.setBool(key, value);
        break;
    }
  }

  static Future<dynamic> getStorage(String key) async {
    // json 格式未解决
    await _init();
    dynamic value = prefs?.get(key);
    // if (value == null) return 'null';
    if (_isJson(value)) {
      return const JsonDecoder().convert(value);
    } else {
      return value;
    }
  }

  static Future<bool> removeStorage(String key) async {
    await _init();
    if (await hasKey(key) != null) {
      await prefs?.remove(key);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> clear() async {
    await _init();
    prefs?.clear();
    return true;
  }

  // static Future<bool?> hasKey(String key) async {
  //   await _init();
  //   return prefs?.containsKey(key);
  // }
  static Future<bool?> hasKey(String key) async {
    await _init();
    return prefs?.containsKey(key);
  }

  static bool _isJson(dynamic value) {
    try {
      // 如果value是一个json的字符串 则不会报错 返回true
      JsonDecoder().convert(value);
      return true;
    } catch (e) {
      // 如果value不是json的字符串 则报错 进入catch 返回false
      return false;
    }
  }
}
