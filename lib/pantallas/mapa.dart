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
  Map<MarkerId, Marker> marcas = <MarkerId, Marker>{};
  Position posicion;
  String localizacion, pais, codigoPostal;
  void getMarcas(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(snippet: 'Dirección'));
    setState(() {
      marcas.clear();
      marcas[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Position currentPosicion =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      posicion = currentPosicion;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
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
                  final coordenadas =
                      new geoCo.Coordinates(tapped.latitude, tapped.longitude);
                  var direccion = await geoCo.Geocoder.local
                      .findAddressesFromCoordinates(coordenadas);
                  var direccionInicial = direccion.first;
                  getMarcas(tapped.latitude, tapped.longitude);
                  setState(() {
                    pais = direccionInicial.countryName;
                    codigoPostal = direccionInicial.postalCode;
                    localizacion = direccionInicial.addressLine;
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
                    target: LatLng(posicion.latitude.toDouble(),
                        posicion.longitude.toDouble()),
                    zoom: 15.0),
                markers: Set<Marker>.of(marcas.values),
              ),
            ),
            SizedBox(height: 10),
            Text('Dirección: $localizacion'),
            MaterialButton(
              minWidth: 140.0,
              height: 30.0,
              onPressed: () {
                inspeccionNotifier.currentInspeccion.lugar = localizacion;
                Navigator.pop(context, localizacion);
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
