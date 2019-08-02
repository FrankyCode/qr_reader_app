


import 'dart:async';

import 'package:qr_reader_app/src/bloc/validator.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';

class ScansBloc with Validators{
  
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    // Get Scans of Database
    takeAllScans();

  }


  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);




  takeAllScans() async {
      _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  addScan(ScanModel scan)async{
    await DBProvider.db.newScan(scan);
    takeAllScans();
  }

  deleteScan(int id)async{
    await DBProvider.db.deleteScan(id);
    takeAllScans();
  }

  deleteAllScans()async {
    await DBProvider.db.deleteAll();
    takeAllScans();
  }

  
  dispose(){
    _scansController?.close();
  }

}