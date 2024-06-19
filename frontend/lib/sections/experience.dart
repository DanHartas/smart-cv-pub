import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/quarticle.dart';
import '../common/section_notifier.dart';
import '../common/styles.dart';

import '../widgets/toggled_list.dart';
import '../widgets/toggle_button.dart';

class Experience extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;

  const Experience({
    super.key,
    required this.width,
    required this.data,
  });

  @override
  ExperienceState createState() => ExperienceState();
}

class ExperienceState extends State<Experience> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        final List<dynamic> listData = widget.data['roles'];
        return SizedBox(
          width: widget.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ToggleButton(
                text: 'Experience',
                icon: Icons.work_rounded,
                cID: widget.data['cID'],
                isExpander: false,
              ),
              SizedBox(height: widget.width / 96),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: listData.map((data) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 6),
                    child: Column(
                      children: [
                        QuarticleContainer(
                          style: QStyles.mahogany,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: QuarticleContainer(
                                  style: notifier.isHighlighted(data['cID'])
                                      ? QStyles.input
                                      : QStyles.cyan,
                                  child: Text(
                                    data['header'],
                                    style: TextStyles.qButtonMid
                                        .copyWith(fontSize: 24),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: QuarticleContainer(
                                  style: QStyles.label,
                                  child: Text(
                                    data['company'],
                                    style: TextStyles.qButtonMid,
                                  ),
                                ),
                              ),
                              for (var i = 0; i < data['jobs'].length; i++)
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: QuarticleContainer(
                                        style: QStyles.dark,
                                        child: Text(
                                          data['jobs'][i]['title'],
                                          style: TextStyles.qButton,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: QuarticleContainer(
                                        style: QStyles.dark,
                                        child: Text(
                                          data['jobs'][i]['dates'],
                                          style: TextStyles.qButton,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (data['description'] != null &&
                                  data['description'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: ListExpandButton(
                                    listData: data['description'],
                                    width: widget.width,
                                    text: 'Show description',
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ToggledList(
                          listData: data['description'],
                          width: widget.width,
                          key1: 'text',
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
