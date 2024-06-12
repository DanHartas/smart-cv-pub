import 'package:flutter/material.dart';

import '../common/styles.dart';

import 'background.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: Center(
        child: CircularProgressIndicator(
          color: Colours.cvGlassyTurquoise,
          strokeWidth: 4,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}