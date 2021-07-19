import 'package:flutter/material.dart';

class ChatBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;

  ChatBubble({
    @required this.color,
    this.alignment
  });

  var _radius = 10.0;
  var _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 8,
            size.height,
            bottomRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill

      );
      var path = new Path();
      path.moveTo(size.width - _x, size.height - 10);
      path.lineTo(size.width - _x, size.height);
      path.lineTo(size.width, size.height);
      canvas.clipPath(path);
      path.close();
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
      );
      var path = new Path();
      path.moveTo(0, size.height);
      path.lineTo(_x, size.height);
      path.lineTo(_x, size.height - 10);
      canvas.clipPath(path);
      path.close();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}