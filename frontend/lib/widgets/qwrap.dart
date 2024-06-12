import 'package:flutter/material.dart';

import '../common/styles.dart';
import '../common/quarticle.dart';

class QWrap extends StatelessWidget {
  final List<Widget> children;
  final QuarticleStyle qStyle;

  const QWrap({
    super.key,
    required this.children,
    this.qStyle = const QuarticleStyle(
      fillColour: Colours.cvGlassySilver,
      strokeColour: Colours.cvGlassySilver,
      shadowColour: Colours.cvGlassySilver,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return QuarticleContainer(
      style: qStyle,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: children,
      ),
    );
  }
}