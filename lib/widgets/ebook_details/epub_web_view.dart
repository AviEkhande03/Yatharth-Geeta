// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yatharthageeta/const/constants/constants.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.epubWebViewUrl});
  final String epubWebViewUrl;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String url = '';
  late WebViewController controller;
  @override
  void initState() {
    url = widget.epubWebViewUrl;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        // style: ButtonStyle(
        //     overlayColor: MaterialStateProperty.all(Colors.transparent)),
        child: Container(
          margin: EdgeInsets.only(top: 22.h, right: 5),
          child: const Icon(
            Icons.close,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButtonAnimator: NoScalingFabAnimator(),
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text(
      //     'Yatharth Geeta',
      //     style: TextStyle(
      //       fontSize: 25,
      //       fontWeight: FontWeight.w500,
      //       color: Colors.black,
      //     ),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: const Color(0xffE49C28),
      // ),
      body: SafeArea(
          child: WebViewWidget(
        controller: controller,
      )),
    );
  }
}

class NoScalingFabAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset(
      {required Offset begin, required Offset end, required double progress}) {
    return end; // No animation, return the final position immediately
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return parent; // No scaling animation
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return parent; // No rotation animation
  }
}

// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({super.key});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// int _stackIndex = 0;

// class _WebViewScreenState extends State<WebViewScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: Text("Yatharth Geeta"),
//       ),
//       body: IndexedStack(
//         index: _stackIndex,
//         children: [
//           InAppWebView(
//             initialUrlRequest: URLRequest(
//                 url: Uri.parse(
//                     'https://incomparable-piroshki-c9754e.netlify.app/')),
//             initialOptions: InAppWebViewGroupOptions(
//               crossPlatform:
//                   InAppWebViewOptions(useShouldOverrideUrlLoading: true),
//             ),
//             onLoadStop: (_, __) {
//               setState(() {
//                 _stackIndex = 0;
//               });
//             },
//             onLoadError: (_, __, ___, ____) {
//               setState(() {
//                 _stackIndex = 0;
//               });
//               //TODO: Show error alert message (Error in receive data from server)
//             },
//             onLoadHttpError: (_, __, ___, ____) {
//               setState(() {
//                 _stackIndex = 0;
//               });
//               //TODO: Show error alert message (Error in receive data from server)
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
