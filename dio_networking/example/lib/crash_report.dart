import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

///
///  crash_report.dart
///
///  Created by wushangkun on 6/23/21.
///  Copyright (c) 2021 chelun. All rights reserved.
//

class CrashReport {
  static const MethodChannel _channel =
      const MethodChannel('flutter_app_native');

  static runCrashGuarded<R>(R body()) {
    runZonedGuarded(() => body(), (error, stack) {
      var details = _makeErrorDetails(error, stack);
      _reportErrorAndLog(details);
    }, zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      _collectLog(line);
    }));
  }

  /// 收集日志
  static _collectLog(String line) {}

  /// 构建错误信息
  static FlutterErrorDetails _makeErrorDetails(Object error, StackTrace stack) {
    return FlutterErrorDetails(exception: error, stack: stack);
  }

  /// 上报日志和错误信息
  static _reportErrorAndLog(FlutterErrorDetails details) async {
    if (kDebugMode) {
      // debug模式下打印错误
      FlutterError.dumpErrorToConsole(details);
    } else {
      // 非debug模式下才上报
      try {
        await _channel.invokeMethod('reportCrash', {
          // 异常的名称
          'name': details.exception.runtimeType.toString(),
          // 异常的message
          'message': details.exception.toString(),
          // 异常的堆栈信息
          'stackTrace': details.stack.toString()
        });
      } catch (e) {}
    }
  }
}
