import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/section_notifier.dart';
import '../common/styles.dart';

import 'icon_qbutton.dart';

class ToggleButton extends StatelessWidget {
  final int cID;
  final bool isExpander;
  final IconData icon;
  final String text;

  const ToggleButton({
    super.key,
    required this.cID,
    required this.isExpander,
    required this.icon,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        bool isExpanded = notifier.isExpanded(cID);

        return Visibility(
          visible: isExpander ? !isExpanded : isExpanded,
          child: Padding(
            padding: isExpanded ? const EdgeInsets.only(top: 72, bottom: 6) : const EdgeInsets.all(6),
            child: IconQButton(
              icon: icon,
              text: text,
              textStyle: isExpander ? TextStyles.qButtonMid : TextStyles.qButtonBig,
              qStyle: QStyles.label,
              onPressed: () {
                if (isExpander) {
                  notifier.expandSection(cID);
                } else {
                  notifier.collapseSection(cID);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class ExpandAllButton extends StatelessWidget {
  const ExpandAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        return Visibility(
          visible: !notifier.allExpanded(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: IconQButton(
              icon: Icons.expand_more_rounded,
              text: 'Expand all',
              textStyle: TextStyles.qButtonMid,
              qStyle: QStyles.input,
              onPressed: () {
                notifier.expandAll();
              },
            ),
          ),
        );
      },
    );
  }
}

class CollapseAllButton extends StatelessWidget {

  const CollapseAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        return Visibility(
          visible: !notifier.allCollapsed(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: IconQButton(
              icon: Icons.expand_less_rounded,
              text: 'Collapse all',
              textStyle: TextStyles.qButtonMid,
              qStyle: QStyles.input,
              onPressed: () {
                notifier.collapseAll();
              },
            ),
          ),
        );
      },
    );
  }
}

