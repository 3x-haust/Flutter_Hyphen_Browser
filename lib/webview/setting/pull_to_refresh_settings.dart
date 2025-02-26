import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inapp;

class PullToRefreshSettings {
  static inapp.PullToRefreshController? initialize({required Future<void> Function() onRefresh}) {
    return kIsWeb || ![TargetPlatform.iOS, TargetPlatform.android].contains(defaultTargetPlatform)
        ? null
        : inapp.PullToRefreshController(
            settings: inapp.PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: onRefresh,
          );
  }
}