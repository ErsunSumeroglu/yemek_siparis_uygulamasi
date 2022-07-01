import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/repo/yemekler_dao_repository.dart';

class YemekEkleCubit extends Cubit<void> {
  YemekEkleCubit():super(0);

  var krepo = YemeklerDaoRepository();

  Future<void> ekle(String yemek_adi,String yemek_resim_adi,
      int yemek_fiyat,int yemek_siparis_adet,String kullanici_adi) async {
    await krepo.SepeteYemekEkle(yemek_adi,yemek_resim_adi,
        yemek_fiyat,yemek_siparis_adet,kullanici_adi);
  }
}