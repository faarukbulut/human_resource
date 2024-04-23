import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CityViewModel extends GetxController{
  Map<String, dynamic> jsonData = {};
  RxList<String> sehirler = RxList<String>();
  RxList<String> ilceler = RxList<String>();

  RxString secilenSehir = "".obs;
  RxString secilenIlce = "".obs;

  final TextEditingController sehirSearchController = TextEditingController();
  final TextEditingController ilceSearchController = TextEditingController();

  Future<void> sehirListeAl() async {
    String data = await rootBundle.loadString('assets/json/il-ilce.json');
    jsonData = jsonDecode(data);
    Map<String, dynamic> sehirData = jsonData['data'];
    List<String> sehirlerList = sehirData.keys.toList();
    sehirler.assignAll(sehirlerList);
  }

  Future<void> ilceListeAl(String sehir) async{
    ilceler.value = jsonData['data'][sehir].cast<String>();
  }



}