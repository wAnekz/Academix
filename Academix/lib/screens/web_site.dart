import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UniversityWebView extends StatefulWidget {
  final dynamic university;

  UniversityWebView({required this.university});

  @override
  _UniversityWebViewState createState() => _UniversityWebViewState();
}

class _UniversityWebViewState extends State<UniversityWebView> {
  late final WebViewController _controller;
  bool _isLoading = true; // Add a loading indicator

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Handle web resource errors
            print('Web resource error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading page: ${error.description}'),
              ),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            // Control navigation within the WebView
            if (request.url.startsWith('https://www.youtube.com/')) {
              // Prevent navigation to YouTube links (example)return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.university['web_pages'] != null &&
            widget.university['web_pages'].isNotEmpty
            ? widget.university['web_pages'][0]
            : 'https://www.example.com'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.university['name'] ?? 'N/A', style:
          TextStyle(fontFamily: 'Exo-regular'),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}