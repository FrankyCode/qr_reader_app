import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';

import 'package:qr_reader_app/src/pages/addres_page.dart';
import 'package:qr_reader_app/src/pages/maps_page.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

import 'package:qrcode_reader/qrcode_reader.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
            
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _scanQR(context),
      ),
    );
  }

  _scanQR(BuildContext context) async{
    
    // TODO: https://www.xataka.com/
    // TODO: geo:40.724233047051705,-74.00731459101564
    // String futureString = 'https://www.xataka.com';
    String futureString;

     
    try{
      futureString = await new QRCodeReader().scan();
    }catch(e){
      futureString = e.toString();
    }

      print('FutureString: $futureString');
      
    
    if(futureString != null){
        final scan = ScanModel(valor: futureString);
        scansBloc.addScan(scan);

        if(Platform.isIOS){
          Future.delayed(Duration(milliseconds: 750), (){
            utils.openScan(context, scan);
          });
        }else{
          utils.openScan(context, scan);
        }
        
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
