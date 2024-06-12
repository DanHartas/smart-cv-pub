import 'package:flutter/material.dart';

import '../sections/headline.dart';
import '../sections/main_tray.dart';
import '../sections/chatbot.dart';
import '../sections/profile.dart';
import '../sections/skills.dart';
import '../sections/experience.dart';
import '../sections/education.dart';
import '../sections/publications.dart';
import '../sections/get_in_touch.dart';

import '../widgets/collapsible_section.dart';

class Content extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;
  final String sessionId;
  final Map<int, List<int>> collapsibleParents;

  const Content({
    super.key,
    required this.width,
    required this.data,
    required this.sessionId,
    required this.collapsibleParents,
  });

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    double spacer = widget.width / 72;
    return Column(
      children: [
        SizedBox(height: spacer),
        Headline(width: widget.width, data: widget.data['header']),
        SizedBox(height: spacer),
        MainTray(width: widget.width, data: widget.data),
        SizedBox(height: spacer),
        CollapsibleSection(
          cID: widget.data['bot']['cID'],
          spacer: spacer,
          child: ChatBot(
            width: widget.width,
            data: widget.data['bot'],
            sessionId: widget.sessionId,
            collapsibleParents: widget.collapsibleParents,
          ),
        ),
        CollapsibleSection(
          cID: widget.data['profile']['cID'],
          spacer: spacer,
          child: Profile(width: widget.width, data: widget.data['profile']),
        ),
        CollapsibleSection(
          cID: widget.data['experience']['cID'],
          spacer: spacer,
          child:
              Experience(width: widget.width, data: widget.data['experience']),
        ),
        CollapsibleSection(
          cID: widget.data['skills']['cID'],
          spacer: spacer,
          child: Skills(width: widget.width, data: widget.data['skills']),
        ),
        CollapsibleSection(
          cID: widget.data['education']['cID'],
          spacer: spacer,
          child: Education(width: widget.width, data: widget.data['education']),
        ),
        CollapsibleSection(
          cID: widget.data['publications']['cID'],
          spacer: spacer,
          child: Publications(
              width: widget.width, data: widget.data['publications']),
        ),
        CollapsibleSection(
          cID: widget.data['contact']['cID'],
          spacer: spacer,
          child: GetInTouch(width: widget.width, data: widget.data['contact']),
        ),
      ],
    );
  }
}
