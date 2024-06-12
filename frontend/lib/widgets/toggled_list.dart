import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/quarticle.dart';
import '../common/section_notifier.dart';
import '../common/styles.dart';

import '../widgets/icon_qbutton.dart';

class ToggledList extends StatelessWidget {
  final double width;
  final List<dynamic>? listData;
  final String? key1;
  final String? key2;
  final MainAxisAlignment mainAxisAlignment;

  const ToggledList({
    super.key,
    required this.listData,
    required this.width,
    required this.key1,
    this.key2 = '',
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: listData!.map((data) {
              return Visibility(
                visible: notifier.isExpanded(data['cID']),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: mainAxisAlignment,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QuarticleButton(
                        qStyle: QStyles.input,
                        onPressed: () => notifier.collapseSection(data['cID']),
                        child: Icon(
                          Icons.close,
                          color: TextStyles.qButton.color,
                          size: TextStyles.qButton.fontSize,
                        ),
                      ),
                      SizedBox(width: width / 96),
                      SizedBox(
                        width: width * 2 / 3,
                        child: QuarticleContainer(
                          style: notifier.isHighlighted(data['cID'])
                              ? QStyles.highlighted
                              : QStyles.tray,
                          child: SelectableText(
                            data[key1],
                            style: TextStyles.qButton,
                            maxLines: null,
                          ),
                        ),
                      ),
                      if (key2 != '' &&
                          data[key2] != null &&
                          data[key2] != '') ...[
                        SizedBox(width: width / 96),
                        SizedBox(
                          width: 36,
                          child: QuarticleContainer(
                            style: QStyles.dark,
                            child: Center(
                              child: Text(
                                data[key2],
                                style: TextStyles.qButton,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class ListExpandButton extends StatelessWidget {
  final List<dynamic>? listData;
  final double width;
  final String text;

  const ListExpandButton({
    super.key,
    required this.listData,
    required this.width,
    this.text = 'Expand all',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        bool isAnyCollapsed =
            listData!.any((data) => !notifier.isExpanded(data['cID']));
        return Visibility(
          visible: isAnyCollapsed,
          child: Column(
            children: [
              IconQButton(
                icon: Icons.expand_more_rounded,
                text: text,
                textStyle: TextStyles.qButton,
                qStyle: QStyles.input,
                onPressed: () {
                  for (var data in listData!) {
                    notifier.expandSection(data['cID']);
                  }
                },
              ),
              SizedBox(height: width / 96),
            ],
          ),
        );
      },
    );
  }
}
