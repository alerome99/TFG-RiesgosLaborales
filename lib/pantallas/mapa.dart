import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position position;
  String addressLocation;
  String country;
  String postalCode;
  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(snippet: 'Address'));
    setState(() {
      //para que solo se pueda añadir una marca
      markers.clear();
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
      print(position.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 570.0,
              child: GoogleMap(
                onTap: (tapped) async {
                  final coordinated =
                      new geoCo.Coordinates(tapped.latitude, tapped.longitude);
                  var address = await geoCo.Geocoder.local
                      .findAddressesFromCoordinates(coordinated);
                  var firstAddress = address.first;
                  getMarkers(tapped.latitude, tapped.longitude);
                  setState(() {
                    country = firstAddress.countryName;
                    postalCode = firstAddress.postalCode;
                    addressLocation = firstAddress.addressLine;
                  });
                },
                mapType: MapType.normal,
                compassEnabled: true,
                trafficEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    googleMapController = controller;
                  });
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(position.latitude.toDouble(),
                        position.longitude.toDouble()),
                    zoom: 15.0),
                markers: Set<Marker>.of(markers.values),
              ),
            ),
            SizedBox(height: 10),
            Text('Address : $addressLocation'),
            MaterialButton(
              minWidth: 140.0,
              height: 30.0,
              onPressed: () {
                inspeccionNotifier.currentInspeccion.lugar = addressLocation;
                Navigator.pop(context, addressLocation);
              },
              color: Colors.blue,
              child: Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
