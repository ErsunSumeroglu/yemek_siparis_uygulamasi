import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uygulamasi/cubit/sepet_detay_cubit.dart';

import '../entity/sepetteki_yemekler.dart';
var toplamsepetucreti=0;
var sepetimBosMu;

class SepetSayfa extends StatefulWidget {
  const SepetSayfa({Key? key}) : super(key: key);

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {

  void initState() {
    super.initState();
    context.read<SepetDetayCubit>().SepettekiYemekleriAl();
  }


  @override
  Widget build(BuildContext context) {
    return sepetimBosMu ==true ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_bag_outlined),
        Text("Sepetiniz Boş"),
      ],
    ):BlocBuilder<SepetDetayCubit,List<SepettekiYemekler>>(
      builder: (context,SepettekiYemeklerListesi){
        if(toplamsepetucreti==0){
          toplamsepetucreti=0;
          for (int i = 0; i < SepettekiYemeklerListesi.length; i++) {
            toplamsepetucreti +=
                int.parse(SepettekiYemeklerListesi[i].yemek_siparis_adet)
                    * int.parse(SepettekiYemeklerListesi[i].yemek_fiyat);
          }
        }
        if(SepettekiYemeklerListesi.isNotEmpty){
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: SepettekiYemeklerListesi.length,
                itemBuilder: (context,indeks){
                  var sepetyemek = SepettekiYemeklerListesi[indeks];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage("https://t1.pixers.pics/img-1fb6f67c/pleksi-baskilar-kirmizi-gingham-dikissiz-desen-masa-ortuleri-giysiler-gomlekler-elbiseler-kagitlar-yatak-takimlari-battaniyeler-yorganlar-ve-diger-tekstil-urunleri-icin-eskenar-dortgen-kareler-icin-doku-vektor-illustrasyonu.jpg?H4sIAAAAAAAAA3VOW27EIAy8DkhpbIcQshxgf_cIUSBkSzcPBGm76unrtOpnbY1sjzQzhvetjHMAH7YjZFjjNC0B5rjwVWwOJX4FgZXulLTMLgIRpd0_QvZ5T-JFY3Wiox9I-zmycB3zQ7weRyoWoKg6xSe78fAF_FqgQboAEehp0hob553xbkhLeJTIbk-NddruFZ4t_55oEav2DD9yXAV_s3POId7SXcI_Wb87sAquNyAD1IBG6AnoJIfrjQw1GnuiQbmgQotunpVrjR65OtN4ans_O7qYmoO-AUO8od0tAQAA"),
                              radius: 50,
                              child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${sepetyemek.yemek_resim_adi}"),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text("${sepetyemek.yemek_adi}",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w400),),
                                Text("adet: ${sepetyemek.yemek_fiyat} ₺",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text("${sepetyemek.yemek_siparis_adet} adet: ${int.parse(sepetyemek.yemek_fiyat)*int.parse(sepetyemek.yemek_siparis_adet)} ₺",style: TextStyle(color: Colors.teal,fontSize: 14),)),
                          IconButton(onPressed: (){

                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Emin misiniz?'),
                                content: Text('${sepetyemek.yemek_adi} ürününü silmek ister misiniz?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Vazgeç'),
                                    child: const Text('Vazgeç'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if(SepettekiYemeklerListesi.length==1){
                                        setState((){
                                          sepetimBosMu=true;
                                          toplamsepetucreti=0;
                                        });
                                      }
                                      else{


                                        setState((){
                                          toplamsepetucreti -= int.parse(sepetyemek.yemek_fiyat) * int.parse(sepetyemek.yemek_siparis_adet);
                                        });

                                      }
                                      context.read<SepetDetayCubit>().SepettenUrunsil(sepetyemek.sepet_yemek_id,"ersunSepet");
                                      return Navigator.pop(context, 'Sil');
                                    },
                                    child: const Text('Sil'),
                                  ),
                                ],
                              ),
                            );

                          }, icon: Icon(Icons.delete_sweep_rounded))
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
              sepetimBosMu ==true ? SizedBox():GestureDetector(
                onTap: (){




                  setState((){
                    toplamsepetucreti=0;
                    for (int i = 0; i < SepettekiYemeklerListesi.length; i++) {
                      context.read<SepetDetayCubit>().SepettenUrunsil(SepettekiYemeklerListesi[i].sepet_yemek_id,"ersunSepet");
                    }
                    toplamsepetucreti=0;
                    sepetimBosMu=true;
                  });


                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Tebrikler'),
                      content: const Text('Siparişiniz onaylandı.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {

                            return Navigator.pop(context, 'Tamam');
                          },
                          child: const Text('Tamam'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.shade100,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(3, 10),
                          blurRadius: 25,
                          color: Colors.redAccent,
                        )
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.payments_sharp),
                              SizedBox(width: 10),
                              Text("Ödemeye gidin")
                            ],
                          ),
                          Text("Toplam ücret: $toplamsepetucreti ₺",style: TextStyle(fontSize: 20,color: Colors.deepPurple),),
                        ],
                      ),
                    )),
              )
            ],
          );
        }else{
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined),
              Text("Sepetiniz Boş"),
            ],
          );
        }
      },
    );

  }
}
