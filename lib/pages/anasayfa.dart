import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/pages/sepet_sayfa.dart';
import 'package:yemek_siparis_uygulamasi/pages/yemek_detay_sayfa.dart';

import '../cubit/anasayfa_cubit.dart';
import '../entity/yemekler.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  var currentIndex=0;
  var pageController = PageController();
  var appBarTitle = "Yemekler ve İçecekler";

  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().yemekleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:  Text(appBarTitle),backgroundColor: Colors.deepPurple,),
        body: Container(
          color: Colors.purple.shade100,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
                if(index==0){
                  appBarTitle = "Yemekler ve İçecekler";
                }
                if(index==1){
                  appBarTitle= "Sepetim";
                }
              }
              );
            },
            children:[
              BlocBuilder<AnasayfaCubit,List<Yemekler>>(
              builder: (context,yemeklerListesi){
                if(yemeklerListesi.isNotEmpty){
                  return ListView.builder(
                    itemCount: yemeklerListesi.length,
                    itemBuilder: (context,indeks){
                      var yemek = yemeklerListesi[indeks];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YemekDetaySayfasi(yemekler: yemek)))
                              .then((value){ context.read<AnasayfaCubit>().yemekleriYukle(); });
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage("https://t1.pixers.pics/img-1fb6f67c/pleksi-baskilar-kirmizi-gingham-dikissiz-desen-masa-ortuleri-giysiler-gomlekler-elbiseler-kagitlar-yatak-takimlari-battaniyeler-yorganlar-ve-diger-tekstil-urunleri-icin-eskenar-dortgen-kareler-icin-doku-vektor-illustrasyonu.jpg?H4sIAAAAAAAAA3VOW27EIAy8DkhpbIcQshxgf_cIUSBkSzcPBGm76unrtOpnbY1sjzQzhvetjHMAH7YjZFjjNC0B5rjwVWwOJX4FgZXulLTMLgIRpd0_QvZ5T-JFY3Wiox9I-zmycB3zQ7weRyoWoKg6xSe78fAF_FqgQboAEehp0hob553xbkhLeJTIbk-NddruFZ4t_55oEav2DD9yXAV_s3POId7SXcI_Wb87sAquNyAD1IBG6AnoJIfrjQw1GnuiQbmgQotunpVrjR65OtN4ans_O7qYmoO-AUO8od0tAQAA"),
                                    radius: 50,
                                    child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}"),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text("${yemek.yemek_adi}",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w400),),
                                      Text("${yemek.yemek_fiyat} ₺",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }else{
                  return const Center();
                }
              },
            ),
              SepetSayfa()
            ]
          ),
        ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          if(index==0){
            appBarTitle = "Yemekler ve İçecekler";
          }
          if(index==1){
            appBarTitle= "Sepetim";
          }
          currentIndex = index;
          pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items:
        [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Yiyecekler'),
            activeColor: Colors.purpleAccent,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.shopping_basket_sharp),
            title: Text('Sepetim'),
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}



