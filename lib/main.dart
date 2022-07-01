import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/entity/yemekler.dart';
import 'package:yemek_siparis_uygulamasi/pages/anasayfa.dart';

import 'cubit/anasayfa_cubit.dart';
import 'cubit/sepet_detay_cubit.dart';
import 'cubit/yemek_ekle_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SepetDetayCubit()),
        BlocProvider(create: (context) => YemekEkleCubit()),
        BlocProvider(create: (context) => AnasayfaCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AnaSayfa(),
      ),
    );
  }
}

