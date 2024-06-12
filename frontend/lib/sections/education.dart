import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/quarticle.dart';
import '../common/section_notifier.dart';
import '../common/styles.dart';

import '../widgets/toggled_list.dart';
import '../widgets/toggle_button.dart';

class Education extends StatefulWidget {
  final double width;
  final Map<String, dynamic> data;

  const Education({
    super.key, 
    required this.width,
    required this.data,
  });

  @override
  EducationState createState() => EducationState();
}

class EducationState extends State<Education> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(
      builder: (context, notifier, child) {
        final List<dynamic> listData = widget.data['qualifications'];
        return SizedBox(
          width: widget.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ToggleButton(
                text: 'Education',
                icon: Icons.school_rounded,
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
                            children:[
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: QuarticleContainer(
                                  style: notifier.isHighlighted(data['cID']) ? QStyles.input : QStyles.cyan,
                                  child: Text(
                                    data['qualification'],
                                    style: TextStyles.qButtonMid,
                                  ),
                                ),
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: QuarticleContainer(
                                      style: QStyles.dark,
                                      child: Text(
                                        data['school'],
                                        style: TextStyles.qButton,
                                      ),
                                    ),
                                  ),
                                  if (data['headline grade'] != null && data['headline grade'].isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: QuarticleContainer(
                                      style: QStyles.dark,
                                      child: Text(
                                        data['headline grade'],
                                        style: TextStyles.qButton,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: QuarticleContainer(
                                      style: QStyles.dark,
                                      child: Text(
                                        data['dates'],
                                        style: TextStyles.qButton,
                                      ),
                                    ),
                                  ),
                                  if (data['courses'] != null && data['courses'].isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: ListExpandButton(
                                      listData: data['courses'],
                                      width: widget.width,
                                      text: 'Show courses'
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ToggledList(
                          listData: data['courses'],
                          width: widget.width / 2,
                          key1: 'subject',
                          key2: 'grade',
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