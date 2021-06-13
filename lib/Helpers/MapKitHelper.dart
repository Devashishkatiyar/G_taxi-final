import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class MapKitHelper{

  static double getMarkerRotation(sourceLat,sourceLng,destinationLat,destinationLng){
    var rotation = mp.SphericalUtil.computeHeading(
        mp.LatLng(sourceLat, sourceLng),
        mp.LatLng(destinationLat, destinationLng)
    );
    return rotation;
  }

}