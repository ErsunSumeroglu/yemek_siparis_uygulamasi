
import 'package:flutter_bloc/flutter_bloc.dart';
import '../entity/sepetteki_yemekler.dart';
import '../entity/yemekler.dart';
import '../repo/yemekler_dao_repository.dart';

class SepetDetayCubit extends Cubit<List<SepettekiYemekler>>{
  SepetDetayCubit() :super(<SepettekiYemekler>[]);

  var krepo = YemeklerDaoRepository();

  Future<void> SepettekiYemekleriAl() async {
    var liste = await krepo.SepettekiYemekleriAl("ersunSepet");
      emit(liste);

  }

  Future<void> SepettenUrunsil(String sepet_yemek_id, String kullanici_adi) async {
    await krepo.SepettekiYemekSil(sepet_yemek_id, kullanici_adi);
    await SepettekiYemekleriAl();
  }
}