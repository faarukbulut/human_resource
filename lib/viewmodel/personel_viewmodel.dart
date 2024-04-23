import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_resource/model/personels/personel.dart';
import 'package:human_resource/services/personel_database.dart';
import 'package:human_resource/view/personel/personel_list_page.dart';

class PersonelViewModel extends GetxController{

  final PersonelDatabase _databaseMethod = PersonelDatabase();
  RxList<Personel> personelList = <Personel>[].obs;
  RxBool isLoading = true.obs;

  final formKey = GlobalKey<FormState>();
  final TextEditingController adController = TextEditingController();
  final TextEditingController iseGirisController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController ePostaController = TextEditingController();
  RxInt secilenHitap = 0.obs;
  RxBool secilenKvkk = false.obs;
  RxString secilenUnvan = "".obs;
  final TextEditingController unvanSearchController = TextEditingController();


  init() async{
    await _databaseMethod.open();
    await getPersonelList();
    isLoading.value = false;
  }

  Future<void> getPersonelList() async{
    final result = await _databaseMethod.getList();
    personelList.clear();
    personelList.addAll(result.map((json) => Personel.fromJson(json)));
  }

  Future<void> insertPersonel(Personel personel) async{
    var personelId = await _databaseMethod.insert(personel);

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
    var result = await _databaseMethod.delete(id);

    if(result == 0){
      // Veri silme işleminde hata oluştu
    }else{
      personelList.removeWhere((personel) => personel.id == id);
    }
  }


}