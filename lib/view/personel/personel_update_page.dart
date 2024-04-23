import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:human_resource/model/personels/personel.dart';
import 'package:human_resource/utils/arrays.dart';
import 'package:human_resource/utils/colors.dart';
import 'package:human_resource/utils/components.dart';
import 'package:human_resource/viewmodel/city_viewmodel.dart';
import 'package:human_resource/viewmodel/personel_viewmodel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class PersonelUpdatePage extends StatefulWidget {
  final int id;
  const PersonelUpdatePage({super.key, required this.id});

  @override
  State<PersonelUpdatePage> createState() => _PersonelUpdatePageState();
}

class _PersonelUpdatePageState extends State<PersonelUpdatePage> {

  final PersonelViewModel _personelViewModel = Get.put(PersonelViewModel());
  final CityViewModel _cityViewModel = CityViewModel();
  final UnvanList _unvanList = UnvanList();
  late Personel _personel = Personel();

  tarihSecim(String tur) async{
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );

    if(dateTime != null){
      DateTime selectedDate = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute
      );

      if(tur == "giris"){
        _personelViewModel.iseGirisController.text = '${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}';
        _personel.iseGiris = selectedDate;
      }
      else if(tur == "cikis"){
        _personelViewModel.isCikisController.text = '${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}';
        _personel.istenCikis = selectedDate;
      }

    }

  }

  @override
  void initState() {
    super.initState();
    _personel = Personel();
    _cityViewModel.sehirListeAl();
    loadPersonel();
  }

  loadPersonel() async{
    Personel? personel = await _personelViewModel.getPersonel(widget.id);
    _personel = personel;
    _personelViewModel.adController.text = personel.adi!;
    _cityViewModel.secilenSehir.value = _cityViewModel.sehirler[personel.il! - 1];
    _cityViewModel.ilceListeAl(_cityViewModel.secilenSehir.value);
    _cityViewModel.secilenIlce.value = _cityViewModel.ilceler[personel.ilce! - 1];
    _personelViewModel.iseGirisController.text = '${personel.iseGiris!.day} - ${personel.iseGiris!.month} - ${personel.iseGiris!.year} ${personel.iseGiris!.hour}:${personel.iseGiris!.minute}';
    personel.istenCikis != null ? _personelViewModel.isCikisController.text = '${personel.istenCikis!.day} - ${personel.istenCikis!.month} - ${personel.istenCikis!.year} ${personel.istenCikis!.hour}:${personel.istenCikis!.minute}' : _personelViewModel.isCikisController.text = '';
    _personelViewModel.telefonController.text = personel.cepTel!;
    _personelViewModel.ePostaController.text = personel.email!;
    _personelViewModel.secilenHitap.value = personel.hitap!;
    _personelViewModel.secilenKvkk.value = personel.kvkk!;
    _personelViewModel.secilenUnvan.value = _unvanList.unvanlar[personel.unvanId! - 1];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _personelViewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  const Text('Yeni Personel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              
                  const SizedBox(height:16),
                  const Divider(),
              
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Boş Bırakılamaz' : null,
                    controller: _personelViewModel.adController,
                    onChanged: (val) => _personel.adi = val,
                    decoration: textFieldNormalDecoration('Ad Soyad'),
                  ),

                  const SizedBox(height:12),
              
                  Obx(() => 
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryLight,
                        border: Border.all(color: kPrimaryLight, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: const Text('Şehir Seçiniz', style: TextStyle(fontSize: 14)),
                          isExpanded: true,
                          value: _cityViewModel.secilenSehir.value != "" ? _cityViewModel.secilenSehir.value : null,
                          items: _cityViewModel.sehirler.map(menuItemStr).toList(),
                          onChanged: (val) {
                            _cityViewModel.secilenSehir.value = val!.toString();
                            _personel.il = _cityViewModel.sehirler.indexOf(val) + 1;
                            _cityViewModel.ilceListeAl(val.toString());
                          },
                          dropdownSearchData: DropdownSearchData(
                            searchMatchFn: (item, searchValue) {
                              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                            },
                            searchController: _cityViewModel.sehirSearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: _cityViewModel.sehirSearchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Şehir',
                                  hintStyle: const TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height:12),

                  Obx(() => 
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryLight,
                        border: Border.all(color: kPrimaryLight, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: const Text('İlçe Seçiniz', style: TextStyle(fontSize: 14)),
                          isExpanded: true,
                          value: _cityViewModel.secilenIlce.value != "" ? _cityViewModel.secilenIlce.value : null,
                          items: _cityViewModel.ilceler.map(menuItemStr).toList(),
                          onChanged: (val) {
                            _cityViewModel.secilenIlce.value = val!.toString();
                            _personel.ilce = _cityViewModel.ilceler.indexOf(val) + 1;
                          },
                          dropdownSearchData: DropdownSearchData(
                            searchMatchFn: (item, searchValue) {
                              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                            },
                            searchController: _cityViewModel.ilceSearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: _cityViewModel.ilceSearchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'İlçe',
                                  hintStyle: const TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height:12),
              
                  TextFormField(
                    onTap: (){ tarihSecim('giris'); },
                    validator: (val) => val!.isEmpty ? 'Boş Bırakılamaz' : null,
                    controller: _personelViewModel.iseGirisController,
                    keyboardType: TextInputType.none,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: textFieldNormalDecoration('İşe Giriş Tarihi'),
                  ),

                  const SizedBox(height:12),
              
                  TextFormField(
                    onTap: (){ tarihSecim('cikis'); },
                    controller: _personelViewModel.isCikisController,
                    keyboardType: TextInputType.none,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: textFieldNormalDecoration('İşten Çıkış Tarihi'),
                  ),

                  const SizedBox(height:12),

                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Boş Bırakılamaz' : null,
                    controller: _personelViewModel.telefonController,
                    onChanged: (value) => _personel.cepTel = value,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '### ### ## ##', 
                        filter: { "#": RegExp(r'[0-9]') },
                        type: MaskAutoCompletionType.lazy
                      )
                    ],
                    decoration: textFieldNormalDecoration('Cep Telefonu'),
                  ),

                  const SizedBox(height:12),
              
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Boş Bırakılamaz' : null,
                    controller: _personelViewModel.ePostaController,
                    onChanged: (value) => _personel.email = value,
                    decoration: textFieldNormalDecoration('E-Posta'),
                  ),
                  const SizedBox(height:12),
              
                  Obx(() => 
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryLight,
                        border: Border.all(color: kPrimaryLight, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Padding(
                            padding: EdgeInsets.only(left:15),
                            child: Text('Hitap Seçiniz', style: TextStyle(fontSize: 14)),
                          ),
                          value: _personelViewModel.secilenHitap.value != 0 ? _personelViewModel.secilenHitap.value : null,
                          isExpanded: true,
                          items: [
                            menuItemInt(1, "Bey"),
                            menuItemInt(2, "Hanım")
                          ],
                          onChanged: (val){
                            _personelViewModel.secilenHitap.value = val!;
                            _personel.hitap = val;
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height:12),
              
                  Obx(() => 
                    CheckboxListTile(
                      title: const Text('KVKK', style: TextStyle(fontSize: 14)),
                      value: _personelViewModel.secilenKvkk.value,
                      activeColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val){
                        _personelViewModel.secilenKvkk.value = val!;
                        _personel.kvkk = val;
                      },
                    ),
                  ),

                  const SizedBox(height:12),
              
                  Obx(() => 
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryLight,
                        border: Border.all(color: kPrimaryLight, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: const Text('Ünvan Seçiniz', style: TextStyle(fontSize: 14)),
                          isExpanded: true,
                          value: _personelViewModel.secilenUnvan.value != "" ? _personelViewModel.secilenUnvan.value : null,
                          items: _unvanList.unvanlar.map(menuItemStr).toList(),
                          onChanged: (val) {
                            _personelViewModel.secilenUnvan.value = val!.toString();
                            _personel.unvanId = _unvanList.unvanlar.indexOf(val.toString()) + 1;
                          },
                          dropdownSearchData: DropdownSearchData(
                            searchMatchFn: (item, searchValue) {
                              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                            },
                            searchController: _personelViewModel.unvanSearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: _personelViewModel.unvanSearchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Ünvan',
                                  hintStyle: const TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:12),
              
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){ 
                          if(
                            _personelViewModel.formKey.currentState!.validate() && 
                            _cityViewModel.secilenSehir.value != "" && 
                            _cityViewModel.secilenIlce.value != "" && 
                            _personelViewModel.secilenHitap.value != 0 &&
                            _personelViewModel.secilenUnvan.value != ""
                          ){
                            _personelViewModel.updatePersonel(widget.id, _personel);
                          }
                        },
                        child: butonContainer('Güncelle', Colors.green),
                      ),
                      const SizedBox(width:12),
                      GestureDetector(
                        onTap: (){ Get.back(); },
                        child: butonContainer('İptal', Colors.red),
                      ),
                    ],
                  )
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}