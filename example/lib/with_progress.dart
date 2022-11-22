import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class WithProgress extends StatefulWidget {
  WithProgress({Key key}) : super(key: key);

  @override
  State<WithProgress> createState() => _WithProgressState();
}

class _WithProgressState extends State<WithProgress> {
  bool _isLoading = true;
  PDFDocument document;
  DownloadProgress downloadProgress;

  @override
  void initState() {
    loadDocument();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void loadDocument() async {
    /// Clears the cache before download, so [PDFDocument.fromURLWithDownloadProgress.downloadProgress()]
    /// is always executed (meant only for testing).
    await DefaultCacheManager().emptyCache();

    PDFDocument.fromURLWithDownloadProgress(
      'https://www.africau.edu/images/default/sample.pdf',
      downloadProgress: (downloadProgress) => setState(() {
        this.downloadProgress = downloadProgress;
      }),
      onDownloadComplete: (document) => setState(() {
        this.document = document;
        _isLoading = false;
      }),
    );
  }

  Widget buildProgress() {
    if (downloadProgress == null) return SizedBox();

    String parseBytesToKBs(int bytes) {
      return '${(bytes / 1000).toStringAsFixed(2)} KBs';
    }

    String progressString = parseBytesToKBs(downloadProgress.downloaded);
    if (downloadProgress.totalSize != null) {
      progressString += '/ ${parseBytesToKBs(downloadProgress.totalSize)}';
    }

    return Column(
      children: [
        SizedBox(height: 20),
        Text(progressString),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    buildProgress(),
                  ],
                ),
              )
            : PDFViewer(
                document: document,
                numberPickerConfirmWidget: const Text(
                  "Confirm",
                ),
              ),
      ),
    );
  }
}
