import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_resource/view/personel/personel_list.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonelListPage(),
    );
  }
}
