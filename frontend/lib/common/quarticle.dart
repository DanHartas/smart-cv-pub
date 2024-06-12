import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math';

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}

class QuarticlePath {
  final double width;
  final double height;

  QuarticlePath(this.width, this.height);

  Path getPath() {
    double cpDistParam = (4 / 3) * (pow(2, 3 / 4) - 1);

    double cornerFrame = min(width, height) / 2;
    double cpDist = cpDistParam * cornerFrame;

    double offset = width - height;
    String offsetDir = offset == 0
        ? "square"
        : offset > 0
            ? "horizontal"
            : "vertical";
    offset = offset.abs();

    Path path = Path();

    Offset lastPoint = Offset(cornerFrame, 0);
    path.moveTo(lastPoint.dx, lastPoint.dy);

    void moveToNext(double x, double y, [bool move = false]) {
      if (move) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      lastPoint = Offset(x, y);
    }

    void cubicToNext(
        Offset cp1, Offset cp2, Offset dest, bool move) {
      if (move) {
        path.moveTo(dest.dx, dest.dy);
      } else {
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, dest.dx, dest.dy);
      }
      lastPoint = dest;
    }

    moveToNext(cornerFrame, 0, true);
    if (offsetDir == "horizontal") {
      moveToNext(cornerFrame + offset, 0);
    }
    cubicToNext(
        Offset(lastPoint.dx + cpDist, 0),
        Offset(width, cornerFrame - cpDist),
        Offset(width, cornerFrame),
        false);

    if (offsetDir == "vertical") {
      moveToNext(width, lastPoint.dy + offset);
    }
    cubicToNext(
        Offset(width, lastPoint.dy + cpDist),
        Offset(width - cornerFrame + cpDist, height),
        Offset(width - cornerFrame, height),
        false);

    if (offsetDir == "horizontal") {
      moveToNext(cornerFrame, height);
    }
    cubicToNext(
        Offset(cornerFrame - cpDist, height),
        Offset(0, height - cornerFrame + cpDist),
        Offset(0, height - cornerFrame),
        false);

    if (offsetDir == "vertical") {
      moveToNext(0, cornerFrame);
    }
    cubicToNext(
        Offset(0, cornerFrame - cpDist),
        Offset(cornerFrame - cpDist, 0),
        Offset(cornerFrame, 0),
        false);

    return path;
  }
}

class QuarticleClipper extends CustomClipper<Path> {
  final double width;
  final double height;

  QuarticleClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    return QuarticlePath(width, height).getPath();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class QuarticlePainter extends CustomPainter {
  final double width;
  final double height;
  final Color fillColour;
  final Color strokeColour;
  final double strokeWeight;
  final Color shadowColour;
  final double shadowSize;

  QuarticlePainter(
      this.width,
      this.height,
      this.fillColour,
      this.strokeColour,
      this.strokeWeight,
      this.shadowColour,
      this.shadowSize);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = QuarticlePath(width, height).getPath();

    Paint fillPaint = Paint()
      ..color = fillColour
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = strokeColour
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWeight;

    Paint shadowPaint = Paint()
      ..color = shadowColour
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class QuarticleStyle {
  final Color fillColour;
  final Color strokeColour;
  final double strokeWeight;
  final Color shadowColour;
  final double shadowSize;
  final bool padding;

  const QuarticleStyle({
    this.fillColour = Colors.transparent,
    this.strokeColour = Colors.black,
    this.strokeWeight = 0.0,
    this.shadowColour = Colors.black,
    this.shadowSize = 10.0,
    this.padding = true,
  });

  QuarticleStyle copyWith({
    Color? fillColour,
    Color? strokeColour,
    double? strokeWeight,
    Color? shadowColour,
    double? shadowSize,
    bool? padding,
  }) {
    return QuarticleStyle(
      fillColour: fillColour ?? this.fillColour,
      strokeColour: strokeColour ?? this.strokeColour,
      strokeWeight: strokeWeight ?? this.strokeWeight,
      shadowColour: shadowColour ?? this.shadowColour,
      shadowSize: shadowSize ?? this.shadowSize,
      padding: padding ?? this.padding,
    );
  }
}

class QuarticleContainer extends StatefulWidget {
  final Widget child;
  final QuarticleStyle style;

  const QuarticleContainer({
    super.key,
    required this.style,
    required this.child,
  });

  @override
  QuarticleState createState() => QuarticleState();
}

class QuarticleState extends State<QuarticleContainer> {
  
  Size? childSize;

  @override
  Widget build(BuildContext context) {
    QuarticleStyle style = widget.style;

    return CustomPaint(
      painter: QuarticlePainter(
        childSize?.width ?? 0,
        childSize?.height ?? 0,
        style.fillColour,
        style.strokeColour,
        style.strokeWeight,
        style.shadowColour,
        style.shadowSize,
      ),
      child: ClipPath(
        clipper: QuarticleClipper(
          childSize?.width ?? 0,
          childSize?.height ?? 0,
        ),
        child: MeasureSize(
          onChange: (size) {
            setState(() {
              childSize = size;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(min(childSize?.width ?? 0, childSize?.height ?? 0) * (style.padding ? ((pow(2, 1 / 4) - 1) / 2).toDouble() : 0)),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class QuarticleButton extends StatefulWidget {
  final QuarticleStyle qStyle;
  final VoidCallback? onPressed;
  final Widget child;

  const QuarticleButton({
    super.key,
    required this.qStyle,
    required this.onPressed,
    required this.child,
  });

  @override
  QuarticleButtonState createState() => QuarticleButtonState();
}

class QuarticleButtonState extends State<QuarticleButton> {
  Size? childSize;

  @override
  Widget build(BuildContext context) {
    QuarticleStyle style = widget.qStyle;

    return MeasureSize(
      onChange: (size) {
        setState(() {
          childSize = size;
        });
      },
      child: CustomPaint(
        painter: QuarticlePainter(
          childSize?.width ?? 0,
          childSize?.height ?? 0,
          style.fillColour,
          style.strokeColour,
          style.strokeWeight,
          style.shadowColour,
          style.shadowSize,
        ),
        child: ClipPath(
          clipper: QuarticleClipper(
            childSize?.width ?? 0,
            childSize?.height ?? 0,
          ),
          child: FilledButton(
            onPressed: widget.onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              padding: WidgetStateProperty.all(
                EdgeInsets.all(min(childSize?.width ?? 0, childSize?.height ?? 0) * (style.padding ? ((pow(2, 1 / 4) - 1) / 2).toDouble() : 0)),
              ),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
              minimumSize: WidgetStateProperty.all(const Size(0, 0)),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class QuarticleDialog extends StatefulWidget{
  final QuarticleStyle qStyle;
  final bool greyOut;
  final Widget child;
  final Function() close;
  final double boxWidth;
  final Color xColour;

  const QuarticleDialog({
    super.key,
    required this.qStyle,
    required this.child,
    required this.close,
    required this.boxWidth,
    this.greyOut = true,
    this.xColour = Colors.white,
  });

  @override
  QuarticleDialogState createState() => QuarticleDialogState();
}

class QuarticleDialogState extends State<QuarticleDialog> {
  Size? childSize;

  @override
  Widget build(BuildContext context) {
    QuarticleStyle style = widget.qStyle;

    return Container( 
      width: double.infinity,
      height: double.infinity,
      color: widget.greyOut ? Colors.black.withOpacity(0.5) : Colors.transparent,
      child: Container(
        width: widget.boxWidth,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: childSize?.width,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 12),
              child: QuarticleButton(
                qStyle: widget.qStyle,
                onPressed: widget.close,
                child: Icon(
                  Icons.close,
                  color: widget.xColour,
                  size: 36,
                ),
              ),
            ),
            MeasureSize(
              onChange: (size) {
                setState(() {
                  childSize = size;
                });
              },
              child: CustomPaint(
                painter: QuarticlePainter(
                  childSize?.width ?? 0,
                  childSize?.height ?? 0,
                  style.fillColour,
                  style.strokeColour,
                  style.strokeWeight,
                  style.shadowColour,
                  style.shadowSize,
                ),
                child: ClipPath(
                  clipper: QuarticleClipper(
                    childSize?.width ?? 0,
                    childSize?.height ?? 0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(min(childSize?.width ?? 0, childSize?.height ?? 0) * (style.padding ? ((pow(2, 1 / 4) - 1) / 2).toDouble() : 0)),
                    child: SingleChildScrollView(
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
