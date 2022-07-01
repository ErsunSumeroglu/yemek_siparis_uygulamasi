import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yemek_siparis_uygulamasi/entity/yemekler.dart';

import '../entity/sepetteki_yemekler.dart';
import '../entity/sepetteki_yemekler_cevap.dart';
import '../entity/yemekler_cevap.dart';

class YemeklerDaoRepository {

  List<Yemekler> parseYemeklerCevap(String cevap){
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler;
  }

  List<SepettekiYemekler> parseSepettekiYemeklerCevap(String cevap){
    return SepettekiYemeklerCevap.fromJson(json.decode(cevap)).sepettekiyemekler;
  }

  Future<void> SepeteYemekEkle(String yemek_adi,String yemek_resim_adi,
      int yemek_fiyat,int yemek_siparis_adet,String kullanici_adi) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php");
    var veri = {
      "yemek_adi":yemek_adi,
      "yemek_resim_adi":yemek_resim_adi,
      "yemek_fiyat":yemek_fiyat.toString(),
      "yemek_siparis_adet":yemek_siparis_adet.toString(),
      "kullanici_adi":kullanici_adi};

    var cevap = await http.post(url,body: veri);
    print("Yemek ekle : ${cevap.body}");
  }

  Future<List<SepettekiYemekler>> SepettekiYemekleriAl(String kullanici_adi) async{
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php");
    var veri = {"kullanici_adi":kullanici_adi};
    var cevap = await http.post(url,body: veri);
    print("Sepetten yemek al : ${cevap.body}");
    return parseSepettekiYemeklerCevap(cevap.body);
  }

  Future<List<Yemekler>> tumYemekleriAl() async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php");
    var cevap = await http.get(url);
    return parseYemeklerCevap(cevap.body);
  }

  Future<void> SepettekiYemekSil(String sepet_yemek_id,String kullanici_adi) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php");
    var veri = {"sepet_yemek_id":sepet_yemek_id,"kullanici_adi":kullanici_adi};
    var cevap = await http.post(url,body: veri);
    print("Yemek sil : ${cevap.body}");
  }
}