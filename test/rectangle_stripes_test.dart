import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inno_entry/src/feature/entry/presentation/widgets/rectangle_stripe_painter.dart';

void main() {
  group('Rectangle stripe tests:', () {
    final size = Size(200, 1000);
    double gap = 5;
    // get stripe coordinates
    final stripeCoordinates = RectangleStripePainter.stripes(size: size, gap: gap);

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
        final slope = (stripeCoordinates[0].top.dy - stripeCoordinates[0].bottom.dy) / (stripeCoordinates[0].top.dx - stripeCoordinates[0].bottom.dx);
          for(int index = 1; index < stripeCoordinates.length; index++) {
            final thisSlope = (stripeCoordinates[0].top.dy - stripeCoordinates[0].bottom.dy) / (stripeCoordinates[0].top.dx - stripeCoordinates[0].bottom.dx);
            if(thisSlope != slope) {
              debugPrint('''
              slope : $slope,
              thisSlope: $thisSlope
              ''');
              return false;
            }
            //if(thisDistanceVector != distanceVector) return false;
          }
          return true;
      }

      expect(true, isParellerAndEqualGaps());
      
    });

    test("No side gaps inside the rectangle of the stripes", (){
      bool yes = true;

      for(int index = 0; index < stripeCoordinates.length; index++) {
        final coordinate = stripeCoordinates[index];

        if((coordinate.top.dx >= size.width || coordinate.top.dy <= 0) 
          && 
          (coordinate.bottom.dx <= 0 || coordinate.bottom.dy >= size.height)
        ) {
          continue;
        }else{
          debugPrint("flagged at: ${coordinate.toString()}");
          yes = false; break;
        }
      }
      expect(true, yes);
    });
  });
}
