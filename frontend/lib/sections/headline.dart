import 'package:flutter/material.dart';
import '../common/quarticle.dart';

import '../common/styles.dart';

class Headline extends StatelessWidget {
  final Map<String, dynamic> data;
  final double width;

  const Headline({
    super.key,
    required this.data,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: QuarticleContainer(
        style: QStyles.label,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            QuarticleContainer(
              style: QStyles.label.copyWith(
                padding: false,
                shadowSize: 0,
              ),
              child: Image.network(
                data['photo'],
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              data['name'],
              style: TextStyles.name,
              softWrap: true,
            ),
            SizedBox(height: TextStyles.tagline.fontSize! / 2),
            Wrap(
              alignment: WrapAlignment.center,
              children: data['tagline'].map<Widget>((tagline) {
                return Padding(
                  padding: const EdgeInsets.all(6),
                  child: QuarticleContainer(
                    style: QStyles.dark,
                    child: Text(
                      tagline,
                      style: TextStyles.tagline,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
