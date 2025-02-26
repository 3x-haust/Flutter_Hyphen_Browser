import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewSettings {
  static final settings = InAppWebViewSettings(
    userAgent:
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  static void loadUrl(InAppWebViewController? controller, String value) {
    var url = WebUri(value);
    if (url.scheme.isEmpty) {
      url = WebUri("https://google.com/search?q=$value");
    }
    controller?.loadUrl(urlRequest: URLRequest(url: url));
  }

  static Future<PermissionResponse> onPermissionRequest(
      InAppWebViewController controller, PermissionRequest request) async {
    return PermissionResponse(
      resources: request.resources,
      action: PermissionResponseAction.GRANT,
    );
  }

  static Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      InAppWebViewController controller, NavigationAction navigationAction) async {
    final uri = navigationAction.request.url!;
    if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
        .contains(uri.scheme)) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return NavigationActionPolicy.CANCEL;
      }
    }
    return NavigationActionPolicy.ALLOW;
  }

  static void onConsoleMessage(InAppWebViewController controller, ConsoleMessage message) {
    if (kDebugMode) {
      print(message);
    }
  }
}