
import 'package:flutter/material.dart';

/// Rectangle stripe painter
/// 
class RectangleStripePainter extends CustomPainter {

  final Color backGroundColor;
  final Color stripeColor;
  final double gap;

  RectangleStripePainter({super.repaint, required this.stripeColor, required this.backGroundColor, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the rectangle first
    canvas.drawRect(Offset.zero & size, Paint()..color = backGroundColor);

    final maxX = size.width; final maxY = size.height;
    Offset top = Offset(maxX, maxY); // bottom right
    Offset bottom = Offset(maxX, maxY); // bottom right

    Paint paint = Paint()
      ..strokeWidth = 5
      ..color = stripeColor;

    
    while(top.dy + gap >= 0 && top.dx + gap >= 0) {
      // Paint
      canvas.drawLine(top, bottom, paint);
      // Calculate next positions
      top = Offset(top.dx - (top.dy <= 0 ? gap : 0.0), top.dy - (top.dy >= 0 ? gap : 0.0));
      bottom = Offset(bottom.dx - (bottom.dx >= 0 ? gap : 0), bottom.dy - (bottom.dx <= 0 ? gap : 0));
    }

  }

  @override
  bool shouldRepaint(covariant RectangleStripePainter oldDelegate) {
    if(oldDelegate.stripeColor != stripeColor || gap != oldDelegate.gap) return true;
    return false;
  }
  
}

