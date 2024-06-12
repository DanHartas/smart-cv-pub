import 'package:flutter/material.dart';

import '../common/quarticle.dart';
import '../common/styles.dart';

import '../widgets/toggle_button.dart';

class Profile extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;

  const Profile({
    super.key,
    required this.width,
    required this.data,
  });

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width * 11 / 12,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButton(
              text: 'Profile',
              icon: Icons.person_rounded,
              cID: widget.data['cID'],
              isExpander: false,
            ),
            SizedBox(height: widget.width / 96),
            QuarticleContainer(
              style: QStyles.cyan,
              child: SelectableText(
                widget.data['text'],
                style: TextStyles.qButton,
                textAlign: TextAlign.center,
                maxLines: null,
              ),
            ),
          ]),
    );
  }
}
