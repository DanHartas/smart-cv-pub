import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/quarticle.dart';
import '../common/section_notifier.dart';
import '../common/styles.dart';

import '../widgets/icon_qbutton.dart';
import '../widgets/qwrap.dart';
import '../widgets/toggle_button.dart';

class Skills extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;

  const Skills({
    super.key,
    required this.width,
    required this.data,
  });

  @override
  SkillsState createState() => SkillsState();
}

class SkillsState extends State<Skills> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        bool isAnyCollapsed = widget.data['list']
            .any((data) => !notifier.isExpanded(data['cID']));
        return SizedBox(
          width: widget.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ToggleButton(
                text: 'Skills',
                icon: Icons.star_rounded,
                cID: widget.data['cID'],
                isExpander: false,
              ),
              SizedBox(height: widget.width / 96),
              QWrap(
                qStyle: QStyles.mahogany,
                children: [
                  for (var data in widget.data['list'])
                    Visibility(
                      visible: !notifier.isExpanded(data['cID']),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: IconQButton(
                          qStyle: QStyles.cyan,
                          onPressed: () {
                            notifier.toggleSection(data['cID']);
                          },
                          text: data['skill'],
                          icon: Icons.expand_more_rounded,
                          textStyle: TextStyles.qButton,
                        ),
                      ),
                    ),
                  Visibility(
                    visible: isAnyCollapsed,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: IconQButton(
                        icon: Icons.expand_more_rounded,
                        text: 'Expand all',
                        textStyle: TextStyles.qButton,
                        qStyle: QStyles.input,
                        onPressed: () {
                          for (var data in widget.data['list']) {
                            notifier.expandSection(data['cID']);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: widget.width / 96),
              for (var data in widget.data['list'])
                Visibility(
                  visible: notifier.isExpanded(data['cID']),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: widget.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconQButton(
                          qStyle: QStyles.cyan,
                          onPressed: () {
                            notifier.toggleSection(data['cID']);
                          },
                          text: data['skill'],
                          icon: Icons.expand_less_rounded,
                          textStyle: TextStyles.qButton,
                        ),
                        SizedBox(height: widget.width / 96),
                        Container(
                          width: widget.width * 5 / 6,
                          padding: const EdgeInsets.all(6),
                          child: QuarticleContainer(
                            style: notifier.isHighlighted(data['cID'])
                                ? QStyles.highlighted
                                : QStyles.tray,
                            child: SelectableText(
                              data['description'],
                              style: TextStyles.qButton,
                              maxLines: null,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
