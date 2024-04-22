import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:human_resource/components/widget.dart';
import 'package:human_resource/viewmodel/personel_viewmodel.dart';

class PersonelListPage extends StatefulWidget {
  const PersonelListPage({super.key});

  @override
  State<PersonelListPage> createState() => _PersonelListPageState();
}

class _PersonelListPageState extends State<PersonelListPage> {

  final PersonelViewModel _personelViewModel = Get.put(PersonelViewModel());

  @override
  void initState() {
    super.initState();
    _personelViewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Personel Bilgileri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const Spacer(),
                  GestureDetector(
                    onTap: (){ _personelViewModel.insertPersonel(); },
                    child: butonContainer('Yeni Ekle', Colors.deepPurple),
                  )
                ],
              ),

              const SizedBox(height:16),
              const Divider(),

              Obx(() => 
                _personelViewModel.isLoading.value == true ? 
                const Center(child: CircularProgressIndicator()) :
                
                _personelViewModel.personelList.isEmpty ?
                const Center(child: Text('Kayıt Bulunamdı.')) :

                Expanded(
                  child: DataTable2(
                      columnSpacing: 8,
                      horizontalMargin: 8,
                      minWidth: Get.width,
                      columns: const [
                        DataColumn2(
                          label: Text('Sıra'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('KVKK'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Adı'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Hitap'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('e-Posta'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('Cep Telefonu'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Ünvanı'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(''),
                          size: ColumnSize.M,
                        ),
                      ],
                      rows: List<DataRow>.generate(_personelViewModel.personelList.length, (i) => 
                        DataRow(cells: [
                          DataCell(Text(_personelViewModel.personelList[i].id.toString())),
                          DataCell(
                            Icon(
                              _personelViewModel.personelList[i].kvkk == true ? Icons.check : Icons.close,
                              color: _personelViewModel.personelList[i].kvkk == true ? Colors.green : Colors.red,
                            ),
                          ),
                          DataCell(Text(_personelViewModel.personelList[i].adi.toString())),
                          DataCell(Text(_personelViewModel.personelList[i].hitap == 0 ? "Bey" : "Hanım")),
                          DataCell(Text(_personelViewModel.personelList[i].email.toString())),
                          DataCell(Text(_personelViewModel.personelList[i].cepTel.toString())),
                          DataCell(Text(_personelViewModel.personelList[i].unvanId.toString())),
                          DataCell(Row(
                            children: [
                              butonContainer('Güncelle', Colors.green),
                              const SizedBox(width:8),
                              butonContainer('Sil', Colors.red),
                            ],
                          )),
                        ]
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}