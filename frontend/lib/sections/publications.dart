import 'package:flutter/material.dart';

import '../widgets/toggle_button.dart';
import '../widgets/toggled_list.dart';

class Publications extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;

  const Publications({
    super.key,
    required this.width,
    required this.data,
  });

  @override
  PublicationsState createState() => PublicationsState();
}

class PublicationsState extends State<Publications> {

  @override
  Widget build(BuildContext context) {
    final List<dynamic> listData = widget.data['list'];
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ToggleButton(
            text: 'Selected Publications',
            icon: Icons.article_rounded,
            cID: widget.data['cID'],
            isExpander: false,
          ),
          SizedBox(height: widget.width / 96),
          ListExpandButton(
            listData: listData,
            width: widget.width,  
          ),
          ToggledList(
            listData: listData,
            width: widget.width,
            key1: 'description',
          ),
        ]
      ),
    );
  }
}