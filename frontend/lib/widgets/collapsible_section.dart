import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/section_notifier.dart';

class CollapsibleSection extends StatelessWidget {
  final int cID;
  final Widget child;
  final double spacer;

  const CollapsibleSection({
    super.key,
    required this.cID,
    required this.child,
    required this.spacer,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, sectionNotifier, _) {
        return Offstage(
          offstage: !sectionNotifier.isExpanded(cID),
          child: Padding(
            padding: EdgeInsets.only(bottom: spacer),
            child: child,
          ),
        );
      },
    );
  }
}
