
import 'dart:math';

import 'package:flutter/material.dart';

class StripeCoordinates {
  final Offset top;
  final Offset bottom;

  StripeCoordinates({required this.top, required this.bottom});

  @override
  String toString() {
    return ''' 
    top: $top,
    bottom: $bottom \n
    ''';
  }
}

/// Rectangle stripe painter
/// 
class RectangleStripePainter extends CustomPainter {

  final Color backGroundColor;
  final Color stripeColor;
  final double gap;
  final double stripeWidth;

  RectangleStripePainter({super.repaint, required this.stripeColor, this.stripeWidth = 5, required this.backGroundColor, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the rectangle first
    canvas.drawRect(Offset.zero & size, Paint()..color = backGroundColor);

    Paint paint = Paint()
      ..strokeWidth = stripeWidth
      //..strokeCap = StrokeCap.round
      ..color = stripeColor;
    
    List<StripeCoordinates> coordinates = stripes(size: size, gap: gap);
    for(final coordinate in coordinates) {
      canvas.drawLine(coordinate.top, coordinate.bottom, paint);
    }

  }



  static List<StripeCoordinates> stripes({required Size size, required double gap}) {
    List<StripeCoordinates> coordinates = [];
    size = Size(size.width + gap, size.height + gap);

    Offset top = Offset(size.width, size.height); // bottom right
    Offset bottom = Offset(size.width, size.height); // bottom right
 
    debugPrint("mmm");
    int totalStripes = (max(size.height, size.width) / gap).ceil() * 2 ;
    while(totalStripes >= 0) {
      debugPrint(
        ''' 
        $top,
        $bottom
        '''
      ); 
      coordinates.add(StripeCoordinates(top: top, bottom: bottom));
      // Calculate next positions
      top = Offset(top.dx - (top.dy < - bottom.dy % gap ? gap : 0.0),  top.dy - (top.dy >= - bottom.dy % gap ? gap : 0.0));
      bottom = Offset(bottom.dx - ((bottom.dx >=  -bottom.dx % gap) ? gap : 0),  bottom.dy - (bottom.dx <  -bottom.dx % gap ? gap : 0));
      totalStripes--;
    }

    return coordinates;
  }

  @override
  bool shouldRepaint(covariant RectangleStripePainter oldDelegate) {
    if(oldDelegate.stripeColor != stripeColor || gap != oldDelegate.gap) return true;
    return false;
  }
  
}

