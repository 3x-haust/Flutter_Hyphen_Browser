import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hyphen_browser/webview/setting/webview_settings.dart';
import '../../main.dart';

class WebViewContainer extends StatefulWidget {
  final GlobalKey webViewKey;
  final String initialUrl;
  final InAppWebViewSettings settings;
  final PullToRefreshController? pullToRefreshController;
  final void Function(InAppWebViewController) onWebViewCreated;
  final void Function(String) onLoadStart;
  final void Function(String) onLoadStop;
  final void Function(double) onProgressChanged;

  const WebViewContainer({
    super.key,
    required this.webViewKey,
    required this.initialUrl,
    required this.settings,
    this.pullToRefreshController,
    required this.onWebViewCreated,
    required this.onLoadStart,
    required this.onLoadStop,
    required this.onProgressChanged,
  });

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          key: widget.webViewKey,
          webViewEnvironment: webViewEnvironment,
          initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
          initialSettings: widget.settings,
          pullToRefreshController: widget.pullToRefreshController,
          onWebViewCreated: widget.onWebViewCreated,
          onLoadStart: (controller, url) => widget.onLoadStart(url.toString()),
          onPermissionRequest: WebViewSettings.onPermissionRequest,
          shouldOverrideUrlLoading: WebViewSettings.shouldOverrideUrlLoading,
          onLoadStop: (controller, url) => widget.onLoadStop(url.toString()),
          onReceivedError: (controller, request, error) =>
              widget.pullToRefreshController?.endRefreshing(),
          onProgressChanged: (controller, progress) {
            setState(() {
              this.progress = progress / 100;
            });
            widget.onProgressChanged(progress / 100);
          },
          onUpdateVisitedHistory: (controller, url, _) => widget.onLoadStop(url.toString()),
          onConsoleMessage: WebViewSettings.onConsoleMessage,
        ),
        if (progress < 1.0)
          LinearProgressIndicator(value: progress),
      ],
    );
  }
}