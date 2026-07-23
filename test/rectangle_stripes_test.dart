import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inno_entry/src/feature/entry/presentation/widgets/rectangle_stripe_painter.dart';

void main() {
  group('Rectangle stripe tests:', () {
    test("Should return true", () {
      // get stripe coordinates
      final stripeCoordinates = RectangleStripePainter.stripes(size: Size(100, 100), gap: 5);
      if(stripeCoordinates.isEmpty) return false;
      final distanceVector = stripeCoordinates[0].top - stripeCoordinates[0].bottom;
      for(int index = 0; index < stripeCoordinates.length; index++) {
        final thisDistanceVector = stripeCoordinates[index].top - stripeCoordinates[index].bottom;
        if(thisDistanceVector != distanceVector) return false;
      }
      return true;
    });
  });
}