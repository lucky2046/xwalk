import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Xwalk {
  static const MethodChannel _channel = const MethodChannel('xwalk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///打开简单的x5webview
  static Future<void> openWebActivity(String url,
      {String title,
        Map<String, String> headers,
        InterceptUrlCallBack callback}) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final Map<String, dynamic> params = <String, dynamic>{
        'title': title,
        'url': url,
        'headers': headers,
        'isUrlIntercept': callback != null
      };
      if (callback != null) {
        _channel.setMethodCallHandler((call) {
          try {
            if (call.method == "onUrlLoad") {
              print("onUrlLoad----${call.arguments}");
              Map arg = call.arguments;
              callback(arg["url"], Map<String, String>.from(arg["headers"]));
            }
          } catch (e) {
            print(e);
          }
          return;
        });
      }
      //这里很重要！
      return await _channel.invokeMethod("openWebActivity", params);
    } else {
      return;
    }
  }
}

typedef void InterceptUrlCallBack(String url, Map<String, String> headers);
