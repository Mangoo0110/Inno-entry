import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inno_entry/src/feature/entry/presentation/widgets/rectangle_stripe_painter.dart';

void main() {
  group('Rectangle stripe tests:', () {
    // get stripe coordinates
    final stripeCoordinates = RectangleStripePainter.stripes(size: Size(200000, 100), gap: 5);

    test("List is not empty.", () {
      expect(true, stripeCoordinates.isNotEmpty);
    });

    test("Different stripes!", () {
      bool yes = true;
      for(int index = 1; index < stripeCoordinates.length; index++) {
        if(stripeCoordinates[index] == stripeCoordinates[index -1]) {
          yes = false; break;
        }
      }

      expect(true, yes);
    });

    test("Stripes should be parallel to each other", () {
      bool isParellerAndEqualGaps() {
        if(stripeCoordinates.isEmpty) return false;
        final slope = (stripeCoordinates[0].top.dy - stripeCoordinates[0].bottom.dy) / (stripeCoordinates[0].top.dx - stripeCoordinates[0].bottom.dx);
          for(int index = 1; index < stripeCoordinates.length; index++) {
            final thisSlope = (stripeCoordinates[0].top.dy - stripeCoordinates[0].bottom.dy) / (stripeCoordinates[0].top.dx - stripeCoordinates[0].bottom.dx);
            if(thisSlope != slope) return false;
            //if(thisDistanceVector != distanceVector) return false;
          }
          return true;
      }

      expect(true, isParellerAndEqualGaps());
      
    });
  });
}