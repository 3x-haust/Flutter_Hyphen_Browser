import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hyphen_browser/webview/setting/webview_settings.dart';
import 'package:hyphen_browser/webview/setting/pull_to_refresh_settings.dart'
    as ptrs;
import 'widgets/navigation_buttons.dart';
import 'widgets/url_input_field.dart';
import 'widgets/webview_container.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pullToRefreshController = ptrs.PullToRefreshSettings.initialize(
      onRefresh: _handleRefresh,
    );
  }

  Future<void> _handleRefresh() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      webViewController?.reload();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final currentUrl = await webViewController?.getUrl();
      webViewController?.loadUrl(urlRequest: URLRequest(url: currentUrl));
    }
  }

  void _updateUrl(String newUrl) {
    setState(() {
      url = newUrl;
      urlController.text = url;
    });
  }

  void _updateProgress(double newProgress) {
    setState(() {
      progress = newProgress;
      if (progress >= 1.0) pullToRefreshController?.endRefreshing();
    });
  }

  void _showSpotlightSearch(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (context) {
        final TextEditingController searchController = TextEditingController();
        return AlertDialog(
          alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.65),
          backgroundColor: const Color(0xFF161718),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: Color(0xFF4B4C4D)),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              style: const TextStyle(color: Color(0xFFE3E4E8)),
              cursorColor: const Color(0xFFE3E4E8),
              controller: searchController,
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Search or enter URL...",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color(0xFF505051),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              onSubmitted: (value) {
                WebViewSettings.loadUrl(webViewController, value);
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyT):
            const _OpenSpotlightSearchIntent(),
      },
      child: Actions(
        actions: {
          _OpenSpotlightSearchIntent:
              CallbackAction<_OpenSpotlightSearchIntent>(
            onInvoke: (_) => _showSpotlightSearch(context),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  UrlInputField(
                    controller: urlController,
                    onSubmitted: (value) =>
                        WebViewSettings.loadUrl(webViewController, value),
                  ),
                  Expanded(
                    child: WebViewContainer(
                      webViewKey: webViewKey,
                      initialUrl: "https://google.com",
                      settings: WebViewSettings.settings,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) =>
                          webViewController = controller,
                      onLoadStart: _updateUrl,
                      onLoadStop: _updateUrl,
                      onProgressChanged: _updateProgress,
                    ),
                  ),
                  NavigationButtons(
                    onBack: () => webViewController?.goBack(),
                    onForward: () => webViewController?.goForward(),
                    onRefresh: () => webViewController?.reload(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OpenSpotlightSearchIntent extends Intent {
  const _OpenSpotlightSearchIntent();
}
