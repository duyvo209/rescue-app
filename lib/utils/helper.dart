import 'dart:math';

class Helper {
  static double getDistanceBetween(
      double lat1, double lng1, double lat2, double lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat1 - lat2) * p) / 2 +
        c(lat1 * p) * c(lat1 * p) * (1 - c((lng1 - lng2) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
