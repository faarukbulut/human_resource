import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_resource/model/personels/personel.dart';
import 'package:human_resource/services/personel_database.dart';
import 'package:human_resource/view/personel/personel_list_page.dart';

class PersonelViewModel extends GetxController{

  final PersonelDatabase _personelDatabase = PersonelDatabase();
  RxList<Personel> personelList = <Personel>[].obs;
  RxBool isLoading = true.obs;

  final formKey = GlobalKey<FormState>();
  final TextEditingController adController = TextEditingController();
  final TextEditingController iseGirisController = TextEditingController();
  final TextEditingController isCikisController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController ePostaController = TextEditingController();
  RxInt secilenHitap = 0.obs;
  RxBool secilenKvkk = false.obs;
  RxString secilenUnvan = "".obs;
  final TextEditingController unvanSearchController = TextEditingController();


  init() async{
    await _personelDatabase.open();
    await getPersonelList();
    isLoading.value = false;
  }

  Future<void> getPersonelList() async{
    final result = await _personelDatabase.getList();
    personelList.clear();
    personelList.addAll(result.map((json) => Personel.fromJson(json)));
  }

  Future<void> insertPersonel(Personel personel) async{
    var personelId = await _personelDatabase.insert(personel);

    if(personelId == 0){
      // Veri ekleme işleminde hata oluştu.
    }else{
      personel.id = personelId;
      personelList.add(personel);

      adController.clear();
      iseGirisController.clear();
      telefonController.clear();
      ePostaController.clear();
      unvanSearchController.clear();
      secilenHitap.value = 0;
      secilenKvkk.value = false;
      secilenUnvan.value = "";
    }

    Get.offAll(() => const PersonelListPage());
  }

  Future<void> deletePersonel(int id) async{
    var result = await _personelDatabase.delete(id);

    if(result == 0){
      // Veri silme işleminde hata oluştu
    }else{
      personelList.removeWhere((personel) => personel.id == id);
    }
  }

  Future<Personel> getPersonel(int id) async{
    final result = await _personelDatabase.get(id);
    return Personel.fromJson(result);
  }

  Future<void> updatePersonel(int id, Personel personel) async{
    var personelId = await _personelDatabase.update(id, personel);

    if(personelId == 0){
      // Veri güncelleme işleminde hata oluştu.
    }else{
      adController.clear();
      iseGirisController.clear();
      telefonController.clear();
      ePostaController.clear();
      unvanSearchController.clear();
      secilenHitap.value = 0;
      secilenKvkk.value = false;
      secilenUnvan.value = "";
    }

    Get.offAll(() => const PersonelListPage());    
  }

}