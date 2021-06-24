import 'dart:io';

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
  String localizacion;
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
    sleep(Duration(seconds: 1));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            mapa(),
            SizedBox(height: 10),
            Text('Dirección: $localizacion',
            maxLines: 2,),
            SizedBox(height: 10),
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

  Widget mapa(){
    double long = 0.0;
    double lat = 0.0;
    while(long == 0.0){
        lat = posicion.latitude.toDouble();
        long = posicion.longitude.toDouble();
    }
    return SizedBox(
              height: 550.0,
              child: GoogleMap(
                onTap: (tapped) async {
                  final coordenadas =
                      new geoCo.Coordinates(tapped.latitude, tapped.longitude);
                  var direccion = await geoCo.Geocoder.local
                      .findAddressesFromCoordinates(coordenadas);
                  var direccionInicial = direccion.first;
                  getMarcas(tapped.latitude, tapped.longitude);
                  setState(() {
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
                    target: LatLng(lat,
                        long),
                    zoom: 15.0),
                markers: Set<Marker>.of(marcas.values),
              ),
            );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
