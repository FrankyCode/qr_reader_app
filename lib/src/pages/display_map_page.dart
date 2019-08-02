import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:qr_reader_app/src/models/scan_model.dart';

class DisplayMapPage extends StatefulWidget {

  @override
  _DisplayMapPageState createState() => _DisplayMapPageState();
}

class _DisplayMapPageState extends State<DisplayMapPage> {
  final MapController map = new MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('Coordenadas QR'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                map.move(scan.getLatLng(), 15);
              },
            )
          ],
        ),
        body: _createFlutterMap(scan),
        floatingActionButton: _createFloatingButton(context),
        );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(center: scan.getLatLng(), zoom: 15),
      layers: [
        _createMap(),
        _createMarc(scan),
      ],
    );
  }

  Widget _createFloatingButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
       onPressed: (){
        // streets, dark , lisght, outdoors, stellite
        if (tipoMapa == 'streets'){
          tipoMapa = 'dark';
        }else if (tipoMapa == 'dark'){
          tipoMapa = 'light';
        }else if (tipoMapa == 'light'){
          tipoMapa = 'outdoors';
        }else if (tipoMapa == 'outdoors'){
          tipoMapa = 'satellite';
        }else{
          tipoMapa = 'streets';
        }
        setState(() {
          
        });
      },
    );
  }

  _createMap() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiZnJhbmt5Y29kZSIsImEiOiJjanl0eTdrN3cwOGlqM25temM4dG1oMzVvIn0.RJyf0HNYegojYwoHhpX66A',
          'id': 'mapbox.$tipoMapa' 
        });
  }

  _createMarc(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 65.0,
                  color: Theme.of(context).primaryColor,
                ),
              )),
    ]);
  }
}
