import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/quarticle.dart';
import '../common/styles.dart';

import '../widgets/icon_qbutton.dart';

class TopBar extends StatelessWidget {
  final void Function() cred;

  const TopBar({
    super.key,
    required this.cred,
  });

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
              text: 'my source code',
              textStyle: TextStyles.qButton,
              qStyle: QStyles.label,
              onPressed: cred,
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
                  text: 'download PDF',
                  textStyle: TextStyles.qButton,
                  qStyle: QStyles.label,
                  onPressed: () async {
                    const url = 'https://example.com/';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                const SizedBox(width: 24),
                IconQButton(
                  icon: Icons.share_rounded,
                  text: 'share',
                  textStyle: TextStyles.qButton,
                  qStyle: QStyles.label,
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: 'URL'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 2),
                        animation: AnimationController(
                          vsync: ScaffoldMessenger.of(context),
                          duration: const Duration(milliseconds: 500),
                        ),
                        content: Center(
                          child: QuarticleContainer(
                            style: QStyles.input,
                            child: Text(
                              'URL copied to clipboard',
                              style: TextStyles.qButtonBig,
                            ),
                          ),
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
