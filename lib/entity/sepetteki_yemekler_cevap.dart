import 'package:yemek_siparis_uygulamasi/entity/sepetteki_yemekler.dart';

class SepettekiYemeklerCevap {
  List<SepettekiYemekler> sepettekiyemekler;
  int success;

  SepettekiYemeklerCevap({required this.sepettekiyemekler,required this.success});

  factory SepettekiYemeklerCevap.fromJson(Map<String,dynamic> json){
    var jsonArray = json["sepet_yemekler"] as List;
    List<SepettekiYemekler> yemeklerListesi =
    jsonArray.map((jsonArrayNesnesi) => SepettekiYemekler.fromJson(jsonArrayNesnesi)).toList();
    return SepettekiYemeklerCevap(sepettekiyemekler: yemeklerListesi, success: json["success"] as int);
  }
}