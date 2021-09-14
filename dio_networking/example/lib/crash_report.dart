import 'dart:async';
import 'dart:isolate';
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
    // 处理FlutterError.onError回调的异常
    FlutterError.onError = (FlutterErrorDetails details) {
      // 将FlutterError的异常处理中转至runZoned的异常处理handler中, 因为两者的处理方式是一样的, 如果处理方式不一样, 可以分开来处理
      Zone.current.handleUncaughtError(details.exception, details.stack);
    };

    // 处理Isolate回调的异常, 只针对main isolate或者root isolate生效
    // 通过Isolate.spawn()创建的isolate中的异常需要调用方自己捕获
    // 不过目前还没有发现什么操作才会在这里回调异常
    Isolate.current.addErrorListener(RawReceivePort((dynamic pair) {
      List<dynamic> errors = pair as List<dynamic>;
      // 同样, Isolate中的异常也中转至runZoned的异常处理handler中
      Zone.current.handleUncaughtError(errors.first, errors.last);
    }).sendPort);

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
