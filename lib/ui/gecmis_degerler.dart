import 'package:elektronik_saglik_platformu_doktor/renkler.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/ates_grafik.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/ates_liste.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/solunum_grafik.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/solunum_liste.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/spo2_grafik.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/spo2_liste.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/tansiyon_grafik.dart';
import 'package:elektronik_saglik_platformu_doktor/ui/tansiyon_liste.dart';
import 'package:flutter/material.dart';

class GecmisDegerler extends StatefulWidget {
  const GecmisDegerler({super.key});

  @override
  State<GecmisDegerler> createState() => _GecmisDegerlerState();
}

class _GecmisDegerlerState extends State<GecmisDegerler> {
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(title: Text("Geçmiş Değerler"), backgroundColor: arkaPlan,),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: arkaPlan),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(ekranGenisligi/45),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: ekranGenisligi/45),
                            child: Text("ATEŞ SONUÇ", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox( width: 35, height: 35,
                              child: Image.asset("resimler/thermometer.png")),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.all(ekranGenisligi/45),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AtesGrafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerGrafikButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(color: gecmisDegerlerGrafikYazi, fontWeight: FontWeight.bold),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AtesListe())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(fontWeight: FontWeight.bold, color: gecmisDegerlerListeYazi),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(ekranGenisligi/45),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: ekranGenisligi/45),
                            child: Text("TANSİYON SONUÇ", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox( width: 35, height: 35,
                              child: Image.asset("resimler/blood-pressure.png")),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.all(ekranGenisligi/45),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TansiyonGrafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(color: gecmisDegerlerGrafikYazi, fontWeight: FontWeight.bold),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TansiyonListe())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(fontWeight: FontWeight.bold, color: gecmisDegerlerListeYazi),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(ekranGenisligi/45),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: ekranGenisligi/45),
                            child: Text("SPO2 SONUÇ", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox( width: 35, height: 35,
                              child: Image.asset("resimler/measurement.png")),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.all(ekranGenisligi/45),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Spo2Grafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(color: gecmisDegerlerGrafikYazi, fontWeight: FontWeight.bold),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Spo2Liste())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(fontWeight: FontWeight.bold, color: gecmisDegerlerListeYazi),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(ekranGenisligi/45),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: ekranGenisligi/45),
                            child: Text("SOLUNUM SONUÇ", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox( width: 35, height: 35,
                              child: Image.asset("resimler/respiratory-system.png")),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.all(ekranGenisligi/45),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SolunumGrafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(color: gecmisDegerlerGrafikYazi, fontWeight: FontWeight.bold),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SolunumListe())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(fontWeight: FontWeight.bold, color: gecmisDegerlerListeYazi),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}