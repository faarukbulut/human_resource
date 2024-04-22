class Personel {
  int? id;
  String? adi;
  int? il;
  int? ilce;
  DateTime? iseGiris;
  DateTime? istenCikis;
  String? cepTel;
  String? email;
  int? hitap;
  bool? kvkk;
  int? unvanId;

  Personel({this.id, this.adi, this.il, this.ilce, this.iseGiris, this.istenCikis, this.cepTel, this.email, this.hitap, this.kvkk, this.unvanId});

  factory Personel.fromJson(Map<String, dynamic> json){
    return Personel(
      id: json['id'],
      adi: json['adi'],
      il: json['il'],
      ilce: json['ilce'],
      iseGiris: json['iseGiris'] != null ? DateTime.parse(json['iseGiris']) : null,
      istenCikis: json['istenCikis'] != null ? DateTime.parse(json['istenCikis']) : null,
      cepTel: json['cepTel'],
      email: json['email'],
      hitap: json['hitap'],
      kvkk: json['kvkk'] == 1 ? true : false,
      unvanId: json['unvanId'],
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adi'] = adi;
    data['il'] = il;
    data['ilce'] = ilce;
    data['iseGiris'] = iseGiris?.toIso8601String();
    data['istenCikis'] = istenCikis?.toIso8601String();
    data['cepTel'] = cepTel;
    data['email'] = email;
    data['hitap'] = hitap;
    data['kvkk'] = kvkk ?? false ? 1 : 0;
    data['unvanId'] = unvanId;
    return data;
  }


}