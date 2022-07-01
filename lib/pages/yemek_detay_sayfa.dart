import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/entity/sepetteki_yemekler.dart';
import 'package:yemek_siparis_uygulamasi/entity/yemekler.dart';
import 'package:yemek_siparis_uygulamasi/pages/sepet_sayfa.dart';
import '../cubit/sepet_detay_cubit.dart';
import '../cubit/yemek_ekle_cubit.dart';

class YemekDetaySayfasi extends StatefulWidget {
  Yemekler yemekler;
  YemekDetaySayfasi({required this.yemekler});

  @override
  _YemekDetaySayfasiState createState() => _YemekDetaySayfasiState();
}

class _YemekDetaySayfasiState extends State<YemekDetaySayfasi> {
  var yemek;
  int counter = 0;
  var yemekOncedenEklendiMi=false;
  @override
  void initState() {
    super.initState();
    toplamsepetucreti=0;
    yemek = widget.yemekler;
    counter = 0;
    yemekOncedenEklendiMi=false;
    context.read<SepetDetayCubit>().SepettekiYemekleriAl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${yemek.yemek_adi} Detayları"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            children: [
              SizedBox(height: 15),
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://t1.pixers.pics/img-1fb6f67c/pleksi-baskilar-kirmizi-gingham-dikissiz-desen-masa-ortuleri-giysiler-gomlekler-elbiseler-kagitlar-yatak-takimlari-battaniyeler-yorganlar-ve-diger-tekstil-urunleri-icin-eskenar-dortgen-kareler-icin-doku-vektor-illustrasyonu.jpg?H4sIAAAAAAAAA3VOW27EIAy8DkhpbIcQshxgf_cIUSBkSzcPBGm76unrtOpnbY1sjzQzhvetjHMAH7YjZFjjNC0B5rjwVWwOJX4FgZXulLTMLgIRpd0_QvZ5T-JFY3Wiox9I-zmycB3zQ7weRyoWoKg6xSe78fAF_FqgQboAEehp0hob553xbkhLeJTIbk-NddruFZ4t_55oEav2DD9yXAV_s3POId7SXcI_Wb87sAquNyAD1IBG6AnoJIfrjQw1GnuiQbmgQotunpVrjR65OtN4ans_O7qYmoO-AUO8od0tAQAA"),
                  radius: 120,
                  child: Image.network(
                      "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}"),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      "${yemek.yemek_adi}",
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${yemek.yemek_fiyat} ₺",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$counter",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 21),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                counter++;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (counter > 0) counter--;
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    Text(
                        "Toplam Ürün Fiyatı:${counter * int.parse(yemek.yemek_fiyat)} ₺",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 19)),
                    SizedBox(height: 20),
                    BlocBuilder<SepetDetayCubit, List<SepettekiYemekler>>(
                        builder: (context, yemeklerListesi) {
                      return GestureDetector(
                        onTap: () async{


                            setState((){
                              toplamsepetucreti=0;
                            });


                          for(int i=0;i<yemeklerListesi.length;i++){
                            if(yemeklerListesi[i].yemek_adi == yemek.yemek_adi) {
                              yemekOncedenEklendiMi = true;
                            }
                          }
                          if (counter > 0) {
                            if(!yemekOncedenEklendiMi || sepetimBosMu == true) {

                              if(sepetimBosMu==true){
                                setState((){
                                  toplamsepetucreti=int.parse(yemek.yemek_fiyat)*counter;
                                });
                              }
                              else{

                                setState((){
                                  for (int i = 0; i < yemeklerListesi.length; i++) {
                                    toplamsepetucreti +=
                                        int.parse(yemeklerListesi[i].yemek_siparis_adet)
                                            * int.parse(yemeklerListesi[i].yemek_fiyat);
                                  }
                                   toplamsepetucreti+=int.parse(yemek.yemek_fiyat)*counter;
                                });
                              }

                             await context.read<YemekEkleCubit>().ekle(
                                  yemek.yemek_adi,
                                  yemek.yemek_resim_adi,
                                  int.parse(yemek.yemek_fiyat),
                                  counter,
                                  "ersunSepet");
                              setState((){
                                sepetimBosMu=false;
                              });



                            }
                            else {ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                Text("Hata, ürün zaten sepetinizde bulunmaktadır"),
                                backgroundColor: Colors.red));
                            }
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                Text("Hata, ürün sipariş adetiniz 0 olamaz"),
                                backgroundColor: Colors.red));
                          }
                          yemekOncedenEklendiMi = true;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(3, 10),
                                blurRadius: 25,
                                color: Colors.purple,
                              )
                            ],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sepete Ekle",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.add_shopping_cart, size: 30),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
