import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebViewApp extends StatefulWidget {
  const MyWebViewApp({super.key});

  @override
  State<MyWebViewApp> createState() => _MyWebViewAppState();
}

class _MyWebViewAppState extends State<MyWebViewApp> {
  WebViewController controller = WebViewController();
  int loadingpercentage = 0;

  @override
  void initState() {
    controller.loadRequest(Uri.parse('https://flutter.c/'));
    controller.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        setState(() {
          loadingpercentage = 0;
        });
      },
      onProgress: (progress) {
        setState(() {
          loadingpercentage = progress;
        });
      },
      onPageFinished: (url) {
        loadingpercentage = 100;
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messanger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Flutter Dev',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
      ),
      backgroundColor: Colors.indigo,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () async {
              if (await controller.canGoBack()) {
                await controller.goBack();
              } else {
                messanger.showSnackBar(const SnackBar(
                  content: Text('No back history item'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            splashRadius: 20,
          ),
          IconButton(
            onPressed: () async {
              if (await controller.canGoForward()) {
                await controller.goForward();
              } else {
                messanger.showSnackBar(const SnackBar(
                  content: Text('No forward history item'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            icon: const Icon(Icons.arrow_forward),
            color: Colors.white,
            splashRadius: 20,
          ),
          IconButton(
            onPressed: () async {
              await controller.reload();
            },
            icon: const Icon(Icons.replay),
            color: Colors.white,
            splashRadius: 20,
          ),
          IconButton(
            onPressed: () async {
              // await controller.clearCache();
              // await controller.setJavaScriptMode(JavaScriptMode.disabled);
              // messanger.showSnackBar( SnackBar(
              //     content: Text(await controller.getTitle()?? 'No Title'),
              //   ));
              messanger.showSnackBar(SnackBar(
                content: Text(await controller.currentUrl() ?? 'No Url'),
              ));
            },
            icon: const Icon(Icons.clear),
            color: Colors.white,
            splashRadius: 20,
          )
        ],
      ),
      body: Center(
          child: loadingpercentage < 100
              ? CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                  value: loadingpercentage / 100,
                )
              : WebViewWidget(controller: controller)),
    );
  }
}
