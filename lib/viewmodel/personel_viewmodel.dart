import 'package:get/get.dart';
import 'package:human_resource/model/personels/personel.dart';
import 'package:human_resource/services/personel_database.dart';

class PersonelViewModel extends GetxController{

  final PersonelDatabaseMethod _databaseMethod = PersonelDatabaseMethod();
  RxList<Personel> personelList = <Personel>[].obs;
  RxBool isLoading = true.obs;


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

  Future<void> insertPersonel() async{

    Personel personel = Personel(
      adi: 'Faruk Bulut',
      il: 09,
      ilce: 01,
      iseGiris: DateTime.now(),
      istenCikis: null,
      cepTel: '05350535226',
      email: 'faarukbulut@gmail.com',
      hitap: 0,
      kvkk: true,
      unvanId: 2,
    );

    var personelId = await _databaseMethod.insert(personel);

    if(personelId == 0){
      // Veri ekleme işleminde hata oluştu.
    }else{
      personel.id = personelId;
      personelList.add(personel);
    }

  }

}