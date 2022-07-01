import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/entity/yemekler.dart';
import 'package:yemek_siparis_uygulamasi/repo/yemekler_dao_repository.dart';

class AnasayfaCubit extends Cubit<List<Yemekler>> {
  AnasayfaCubit():super(<Yemekler>[]);

  var krepo = YemeklerDaoRepository();

  Future<void> yemekleriYukle() async {
    var liste = await krepo.tumYemekleriAl();
    emit(liste);
  }

  }