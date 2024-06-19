import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/quarticle.dart';
import '../common/styles.dart';

import '../widgets/icon_qbutton.dart';
import '../widgets/toggle_button.dart';

class GetInTouch extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;

  const GetInTouch({
    super.key,
    required this.width,
    required this.data,
  });

  @override
  GetInTouchState createState() => GetInTouchState();
}

class GetInTouchState extends State<GetInTouch> {
  Future<void> externalLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButton(
              text: 'Get in Touch',
              icon: Icons.person_rounded,
              cID: widget.data['cID'],
              isExpander: false,
            ),
            SizedBox(height: widget.width / 96),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: IconQButton(
                    icon: Icons.email_rounded,
                    text: widget.data['email'],
                    textStyle: TextStyles.qButton,
                    qStyle: QStyles.turquoise,
                    onPressed: () =>
                        externalLink('mailto:${widget.data['email']}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: IconQButton(
                    icon: Icons.phone_rounded,
                    text: widget.data['phone'],
                    textStyle: TextStyles.qButton,
                    qStyle: QStyles.turquoise,
                    onPressed: () =>
                        externalLink('tel:${widget.data['phone']}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: IconQButton(
                    icon: Icons.location_on_rounded,
                    text: widget.data['address'],
                    textStyle: TextStyles.qButton,
                    qStyle: QStyles.turquoise,
                    onPressed: () => externalLink(
                        'https://www.google.com/maps/search/?api=1&query=${widget.data['address']}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: IconQButton(
                    icon: Icons.web_rounded,
                    text: widget.data['linkedin'],
                    textStyle: TextStyles.qButton,
                    qStyle: QStyles.turquoise,
                    onPressed: () => externalLink(widget.data['linkedin']),
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.width / 96),
            QuarticleContainer(
              style: QStyles.dark,
              child: Text(
                "references available on request",
                style: TextStyles.qButton,
              ),
            ),
          ]),
    );
  }
}
