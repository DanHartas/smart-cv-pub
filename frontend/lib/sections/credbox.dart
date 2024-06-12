import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/quarticle.dart';
import '../common/styles.dart';

class CredBox extends StatelessWidget {
  final double width;
  final void Function() close;

  const CredBox({
    super.key,
    required this.width,
    required this.close,
  });

  @override
  Widget build(BuildContext context) {
    return QuarticleDialog(
      qStyle: QStyles.label,
      boxWidth: width,
      close: close,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Thanks for taking an interest!",
            style: TextStyles.qButton,
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: TextStyles.qButton,
              children: [
                const TextSpan(
                    text:
                        "I wrote this app from scratch using Flutter; you can find my source code on "),
                WidgetSpan(
                  child: QuarticleButton(
                    qStyle: QStyles.input,
                    onPressed: () async {
                      Uri uri = Uri.parse(
                          'https://github.com/DanHartas/smart-cv-pub/');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        throw 'Could not launch $uri';
                      }
                    },
                    child: Text(
                      'GitHub',
                      style: TextStyles.qButton,
                    ),
                  ),
                ),
                const TextSpan(text: "."),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            "(If you think this means I have too much time on my hands, well, you're the hiring manager!)",
            style: TextStyles.qButton.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: TextStyles.qButton,
              children: [
                const TextSpan(
                    text:
                        "Or if you just clicked because you're curious about Flutter, take a look at "),
                WidgetSpan(
                  child: QuarticleButton(
                    qStyle: QStyles.input,
                    onPressed: () async {
                      Uri uri = Uri.parse('https://flutter.dev');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        throw 'Could not launch $uri';
                      }
                    },
                    child: Text(
                      'flutter.dev',
                      style: TextStyles.qButton,
                    ),
                  ),
                ),
                const TextSpan(text: ". Hope to hear from you, though!"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
