import 'package:flutter/material.dart';

import 'package:qr_reader_app/src/pages/addres_page.dart';
import 'package:qr_reader_app/src/pages/maps_page.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';

import 'package:qrcode_reader/qrcode_reader.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
            
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _scanQR,
      ),
    );
  }

  _scanQR() async{
    
    // TODO: https://www.xataka.com/
    // TODO: geo:53.303697011226575,-6.286214737500018
      String futureString = 'https://www.xataka.com';

      
    /*  
    try{
      futureString = await new QRCodeReader().scan();
    }catch(e){
      futureString = e.toString();
    }

      print('FutureString: $futureString');
      
    */
    if(futureString != null){
        final scan = ScanModel(valor: futureString);
        DBProvider.db.newScan(scan);
      }

  }

  Widget _callPage(int actualPage) {
    switch (actualPage) {
      case 0:
        return MapsPage();
      case 1:
        return AddresPage();
      default:
        return MapsPage();
    }
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Maps')),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Address')),
      ],
    );
  }
}
