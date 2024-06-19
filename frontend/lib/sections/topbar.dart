import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../common/styles.dart';
import '../widgets/icon_qbutton.dart';

class TopBar extends StatefulWidget {
  final void Function() cred;

  const TopBar({
    super.key,
    required this.cred,
  });

  @override
  TopBarState createState() => TopBarState();
}

class TopBarState extends State<TopBar> {
  late PdfController pdfController;

  @override
  void initState() {
    super.initState();
    pdfController = PdfController(
      document: PdfDocument.openAsset('assets/feed-the-database.pdf'),
    );
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Colours.cvTeal,
            width: 2,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconQButton(
              icon: Icons.code_rounded,
              text: MediaQuery.of(context).size.width < 800
                  ? ''
                  : 'my source code',
              textStyle: TextStyles.qButton,
              qStyle: QStyles.label,
              onPressed: widget.cred,
            ),
          ),
          Text(
            '❖ SMART CV ❖',
            style: TextStyles.headbar,
            textAlign: TextAlign.center,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconQButton(
                  icon: Icons.download_rounded,
                  text: MediaQuery.of(context).size.width < 600
                      ? ''
                      : 'download PDF',
                  textStyle: TextStyles.qButton,
                  qStyle: QStyles.label,
                  onPressed: () async {
                    final pdfBytes =
                        await rootBundle.load('assets/feed-the-database.pdf');
                    final blob = html.Blob(
                        [pdfBytes.buffer.asUint8List()], 'application/pdf');
                    final url = html.Url.createObjectUrlFromBlob(blob);

                    // ignore: unused_local_variable
                    final anchor = html.AnchorElement(href: url)
                      ..setAttribute('download', 'feed-the-database.pdf')
                      ..click();

                    html.Url.revokeObjectUrl(url);
                  },
                ),
                const SizedBox(width: 24),
                IconQButton(
                  icon: Icons.share_rounded,
                  text: MediaQuery.of(context).size.width < 800 ? '' : 'share',
                  textStyle: TextStyles.qButton,
                  qStyle: QStyles.label,
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: 'URL'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.black.withOpacity(0.75),
                        content: Text(
                          'URL copied to clipboard',
                          textAlign: TextAlign.center,
                          style: TextStyles.qButtonBig,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
