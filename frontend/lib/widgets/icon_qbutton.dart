import 'package:flutter/material.dart';

import '../common/quarticle.dart';

class IconQButton extends StatelessWidget {
  final IconData icon;
  final String? text;
  final TextStyle textStyle;
  final QuarticleStyle qStyle;
  final Function() onPressed;

  const IconQButton({
    super.key,
    required this.icon,
    this.text,
    required this.textStyle,
    required this.qStyle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return QuarticleButton(
      qStyle: qStyle,
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: textStyle.fontSize! * 3 / 2,
            color: textStyle.color,
          ),
          SizedBox(width: text == null ? 0 : textStyle.fontSize! / 4),
          Text(
            text != null ? '$text ' : '',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
