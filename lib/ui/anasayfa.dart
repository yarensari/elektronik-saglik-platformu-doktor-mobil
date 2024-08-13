  import 'package:elektronik_saglik_platformu_doktor/data/hastaBilgileri.dart';
import 'package:elektronik_saglik_platformu_doktor/data/mySQLBaglan.dart';
  import 'package:elektronik_saglik_platformu_doktor/data/olcumDegerleri.dart';
  import 'package:elektronik_saglik_platformu_doktor/renkler.dart';
  import 'package:elektronik_saglik_platformu_doktor/ui/doktor_notlari.dart';
  import 'package:elektronik_saglik_platformu_doktor/ui/gecmis_degerler.dart';
  import 'package:flutter/material.dart';
  import 'package:mysql1/mysql1.dart';
  import 'package:mysql_client/mysql_client.dart';


  class Anasayfa extends StatefulWidget {
    const Anasayfa({super.key});

    @override
    State<Anasayfa> createState() => _AnasayfaState();
  }

  class _AnasayfaState extends State<Anasayfa> {
    var tfDeger = TextEditingController();
    var gelenHastaBilgileri = Hastabilgileri(isim: "isim", soyisim: "soyisim", yas: "yas", boy: "boy", kilo: "kilo", bmi: "bmi");
    var gelenOlcumDegerleri = OlcumDegerleri(ates: "ates", solunum: "solunum", nabiz: "nabiz", spo2: "spo2", sys: "sys", dia: "dia", gun: "");
    late String mesajGeriDonus;
    late String host;
    late int port;
    late String password;
    late String userName;
    late String databaseName;

    void initState() {
      // TODO: implement initState
      super.initState();
      MySQLBaglan baglan = MySQLBaglan();
      host = baglan.getHost();
      port = baglan.getPort();
      userName = baglan.getUserName();
      password = baglan.getPassword();
      databaseName = baglan.getDatabaseName();
      main();
    }

    Future<void> main() async {

      final conn = await MySQLConnection.createConnection(
          host: host,
          port: port,
          userName: userName,
          password: password,
          databaseName: databaseName
      );

      await conn.connect();

      print("Connected");

      var dataHastaBilgileri = await conn.execute("SELECT name, surname, age, height, weight, bmi FROM info WHERE id=1");
      var dataAtesBilgisi = await conn.execute("SELECT fever FROM test_fever ORDER BY id DESC LIMIT 1");
      var dataSolunumBilgisi = await conn.execute("SELECT res_value FROM res_data_final ORDER BY id DESC LIMIT 1");
      var dataSpo2NabizBilgisi = await conn.execute("SELECT spo2, pulse FROM test_spo2 ORDER BY id DESC LIMIT 1");
      var dataSysDiaBilgisi = await conn.execute("SELECT sys, dia FROM test_bloodpressure ORDER BY id DESC LIMIT 1");

      setState(() {
        for (final row in dataHastaBilgileri.rows) {
          gelenHastaBilgileri.isim = row.colByName("name").toString();
          gelenHastaBilgileri.soyisim = row.colByName("surname").toString();
          gelenHastaBilgileri.yas = row.colByName("age").toString();
          gelenHastaBilgileri.kilo = row.colByName("weight").toString();
          gelenHastaBilgileri.boy = row.colByName("height").toString();
          gelenHastaBilgileri.bmi = row.colByName("bmi").toString();
        }
        for (final row in dataAtesBilgisi.rows) {
          gelenOlcumDegerleri.ates = row.colByName("fever").toString();
        }
        for (final row in dataSpo2NabizBilgisi.rows) {
          gelenOlcumDegerleri.spo2 = row.colByName("spo2").toString();
          gelenOlcumDegerleri.nabiz = row.colByName("pulse").toString();
        }
        for (final row in dataSolunumBilgisi.rows) {
          gelenOlcumDegerleri.solunum = row.colByName("res_value").toString();
        }
        for(final row in dataSysDiaBilgisi.rows) {
          gelenOlcumDegerleri.dia = row.colByName("dia").toString();
          gelenOlcumDegerleri.sys = row.colByName("sys").toString();
        }

      });

      await conn.close();
    }

    Future<void> mesajiGonder(String mesaj) async {

      final conn = await MySQLConnection.createConnection(
          host: host,
          port: port,
          userName: userName,
          password: password,
          databaseName: databaseName
      );

      await conn.connect();
      print("Connected");
      if(mesaj != "") {
        await conn.execute("INSERT INTO messages (message) VALUES (:gelenMesaj)",
          {
            "gelenMesaj" : mesaj,
          },
        );
        setState(() {
          mesajGeriDonus = "Mesajınız başarıyla gönderildi.";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Mesajınız başarıyla gönderildi."),
            duration: Duration(seconds: 3),
          ),
        );
      }else {
        setState(() {
          mesajGeriDonus = "Boş mesaj gönderilemez.";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Boş mesaj gönderilemez."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    @override
    Widget build(BuildContext context) {
      var ekranBilgisi = MediaQuery.of(context);
      final double ekranYuksekligi = ekranBilgisi.size.height;
      final double ekranGenisligi = ekranBilgisi.size.width;
      print(ekranYuksekligi);
      print(ekranGenisligi);
      print(gelenHastaBilgileri.isim);
      return Scaffold(
        appBar: AppBar(title: const Text("Elektronik Sağlık Platformu"), backgroundColor: arkaPlan,),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: arkaPlan),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 12),
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: hastaBilgileriGenelArkaPlan,),
                      child: Row(
                        children: [
                          SizedBox(width: 75, height: 75, child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("resimler/user.png"),
                          )),
                          Padding(
                            padding: EdgeInsets.only(right: ekranYuksekligi > ekranGenisligi ? 10.0 : 60, left: ekranYuksekligi > ekranGenisligi ? 0.0 : 20),
                            child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text("HASTA BİLGİLERİ", style: TextStyle(color: hastaBilgileriYaziRenk, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    Text("İSİM: ${gelenHastaBilgileri.isim}", style: TextStyle(color: hastaBilgileriYaziRenk, fontSize: 10, fontWeight: FontWeight.bold)),
                                    Text("SOYİSİM: ${gelenHastaBilgileri.soyisim}", style: TextStyle(color: hastaBilgileriYaziRenk, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                )
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan, borderRadius: BorderRadius.circular(8)),
                                    height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/43 : ekranYuksekligi/30, width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/6.5 : ekranGenisligi/6.5,
                                    child: Text("YAŞ: ${gelenHastaBilgileri.yas}", style: TextStyle(fontSize: 10, color: hastaBilgileriAyrintiYaziRenk, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan, borderRadius: BorderRadius.circular(8)),
                                    height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/43 : ekranYuksekligi/30, width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/6.5 : ekranGenisligi/6.5,
                                    child: Text("BOY: ${gelenHastaBilgileri.boy}", style: TextStyle(fontSize: 10, color: hastaBilgileriAyrintiYaziRenk, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan, borderRadius: BorderRadius.circular(8)),
                                    height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/43 : ekranYuksekligi/30, width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/6.5 : ekranGenisligi/6.5,
                                    child: Text("KİLO: ${gelenHastaBilgileri.kilo}", style: TextStyle(fontSize: 10, color: hastaBilgileriAyrintiYaziRenk, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  child: Container(
                                      decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan, borderRadius: BorderRadius.circular(8)),
                                      width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/2.3 : ekranYuksekligi/1.3,
                                      height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/43 : ekranYuksekligi/30,
                                      child: Text("VÜCUT KİTLE İNDEKSİ: ${gelenHastaBilgileri.bmi}", style: TextStyle(fontSize: 10, color: hastaBilgileriAyrintiYaziRenk, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ekranGenisligi/100, right: ekranGenisligi/100, bottom: ekranYuksekligi/60),
                  child: Container(
                    decoration: BoxDecoration(color: gecmisDegerlerArkaPlan, borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(width: ekranGenisligi-140,
                              child: ElevatedButton(style: ElevatedButton.styleFrom(
                                  backgroundColor: gecmisDegerlerButon,
                              ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GecmisDegerler())).then((value) {
                                      print("Anasayfaya dönüldü");
                                      main();
                                    });
                                  }, child: Text("Geçmiş Değerleri Görüntüle", style: TextStyle(color: gecmisDegerlerYazi, fontWeight: FontWeight.bold),)),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(width: 30, height: 30,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset("resimler/bar-chart.png"),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ekranGenisligi/100, right: ekranGenisligi/100, bottom: ekranYuksekligi/60),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: doktorNotlariArkaPlan, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(width: ekranGenisligi-140,
                                    child: ElevatedButton(style: ElevatedButton.styleFrom(
                                        backgroundColor: doktorNotlariButon
                                    ),
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DoktorNotlari()));
                                        }, child: Text("Doktor Notları", style: TextStyle(color: doktorNotlariYazi, fontWeight: FontWeight.bold),)),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(width: 30, height: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.asset("resimler/writing.png"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ekranYuksekligi/100,),
                          Container(decoration: BoxDecoration(color: notYazinizArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(controller: tfDeger, decoration: InputDecoration(hintText: "Not yazınız"), style: TextStyle(color: notYazinizYaziRenk, fontWeight: FontWeight.bold),),
                              )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(style: ElevatedButton.styleFrom(
                                  backgroundColor: gonderButon),
                                  onPressed: () {
                                    mesajiGonder(tfDeger.text);
                                  },
                                  child: Text("Gönder", style: TextStyle(color: gonderButonYazi, fontWeight: FontWeight.bold),)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ekranYuksekligi/60, left: ekranGenisligi/100, right: ekranGenisligi/100, bottom: ekranYuksekligi/100),
                  child: Container(width: ekranGenisligi,
                    decoration: BoxDecoration(color: hastaSonuclariArkaPlan, borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("HASTA SONUÇLARI", style: TextStyle(fontSize: 20, color: hastaSonuclariYazi, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ekranGenisligi/100, right: ekranGenisligi/100),
                  child: Container(
                    decoration: BoxDecoration(color: anlikSonuclarGenelArkaPlan, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi/100, right: ekranGenisligi/100),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(ekranYuksekligi/74.5),
                                    child: Container(height: ekranYuksekligi/6,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: anlikSonuclarArkaPlan),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: ekranYuksekligi/74.5),
                                                child: SizedBox(width: 45, height: 45,
                                                    child: Image.asset("resimler/ekg.png")
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: ekranYuksekligi/30),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("PRbpm", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                      Text("${gelenOlcumDegerleri.solunum}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: anlikSonuclarYazi)),
                                                      Text("/Min", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: ekranGenisligi/36,),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(ekranYuksekligi/74.5),
                                    child: Container(height: ekranYuksekligi/6,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: anlikSonuclarArkaPlan),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: ekranYuksekligi/74.5),
                                              child: SizedBox(width: 45, height: 45,
                                                  child: Image.asset("resimler/thermometer.png")
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: ekranYuksekligi/74.5),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("VÜCUT ISISI", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                    Text("${gelenOlcumDegerleri.ates} °C", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi/100, right: ekranGenisligi/100),
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(ekranYuksekligi/74.5),
                                    child: Container(height: ekranYuksekligi/6,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: anlikSonuclarArkaPlan),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: ekranYuksekligi/74.5),
                                                child: SizedBox(width: 45, height: 45,
                                                    child: Image.asset("resimler/measurement.png")
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: ekranYuksekligi/30),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("SPO2", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                      Text("%${gelenOlcumDegerleri.spo2}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: ekranGenisligi/36,),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(ekranYuksekligi/74.5),
                                    child: Container(height: ekranYuksekligi/6,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: anlikSonuclarArkaPlan,),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: ekranYuksekligi/74.5),
                                              child: SizedBox(width: 45, height: 45,
                                                  child: Image.asset("resimler/blood-pressure.png")
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: ekranYuksekligi/20),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("DIA", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                    Text("${gelenOlcumDegerleri.dia}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: anlikSonuclarYazi)),
                                                    Text("mmHg", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi/100, right: ekranGenisligi/100),
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(ekranYuksekligi/74.5),
                                    child: Container(height: ekranYuksekligi/6,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: anlikSonuclarArkaPlan),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: ekranYuksekligi/74.5),
                                                child: SizedBox(width: 45, height: 45,
                                                    child: Image.asset("resimler/blood-pressure.png")
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: ekranYuksekligi/20),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("SYS", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                      Text("${gelenOlcumDegerleri.sys}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: anlikSonuclarYazi)),
                                                      Text("mmHg", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: ekranGenisligi/36,),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(ekranYuksekligi/74.5),
                                    child: Container(height: ekranYuksekligi/6,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: anlikSonuclarArkaPlan,),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: SizedBox(width: 45, height: 45,
                                                  child: Image.asset("resimler/respiratory-system.png")
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: ekranYuksekligi/20),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("SOLUNUM", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),),
                                                    Text("${gelenOlcumDegerleri.solunum}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: anlikSonuclarYazi)),
                                                    Text("bpm", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: anlikSonuclarYazi),)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }