import 'package:flutter/material.dart';

import '../widgets/qwrap.dart';
import '../widgets/toggle_button.dart';

class MainTray extends StatefulWidget {
  final double width;
  final Map<String, dynamic>? data;

  const MainTray({
    super.key,
    required this.width,
    required this.data,
  });

  @override
  MainTrayState createState() => MainTrayState();
}

class MainTrayState extends State<MainTray> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width * 5 / 6,
      child: QWrap(
        children: [
          const ExpandAllButton(),
          const CollapseAllButton(),
          ToggleButton(
            text: 'Chat Bot',
            icon: Icons.chat_bubble_rounded,
            cID: widget.data!['bot']['cID'],
            isExpander: true,
          ),
          ToggleButton(
            text: 'Profile',
            icon: Icons.person_rounded,
            cID: widget.data!['profile']['cID'],
            isExpander: true,
          ),
          ToggleButton(
            text: 'Experience',
            icon: Icons.work_rounded,
            cID: widget.data!['experience']['cID'],
            isExpander: true,
          ),
          ToggleButton(
            text: 'Skills',
            icon: Icons.star_rounded,
            cID: widget.data!['skills']['cID'],
            isExpander: true,
          ),
          ToggleButton(
            text: 'Education',
            icon: Icons.school_rounded,
            cID: widget.data!['education']['cID'],
            isExpander: true,
          ),
          ToggleButton(
            text: 'Publications',
            icon: Icons.article_rounded,
            cID: widget.data!['publications']['cID'],
            isExpander: true,
          ),
          ToggleButton(
            text: 'Get in Touch',
            icon: Icons.person_rounded,
            cID: widget.data!['contact']['cID'],
            isExpander: true,
          ),
        ],
      ),
    );
  }
}