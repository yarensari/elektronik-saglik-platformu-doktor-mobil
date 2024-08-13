import 'package:elektronik_saglik_platformu_doktor/data/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_doktor/data/olcumDegerleri.dart';
import 'package:elektronik_saglik_platformu_doktor/renkler.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mysql_client/mysql_client.dart';

class TansiyonListe extends StatefulWidget {
  const TansiyonListe({super.key});

  @override
  State<TansiyonListe> createState() => _TansiyonListeState();
}

class _TansiyonListeState extends State<TansiyonListe> {
  String secim = "BÜTÜN SONUÇLAR";
  var secimler = <String>[];
  late String host;
  late int port;
  late String password;
  late String userName;
  late String databaseName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secimler.add("BÜTÜN SONUÇLAR");
    secimler.add("1 HAFTA");
    secimler.add("2 HAFTA");
    secimler.add("3 HAFTA");
    secimler.add("1 AY");
    MySQLBaglan baglan = MySQLBaglan();
    host = baglan.getHost();
    port = baglan.getPort();
    userName = baglan.getUserName();
    password = baglan.getPassword();
    databaseName = baglan.getDatabaseName();
  }

  Future<List<OlcumDegerleri>> verileriCek(String sinirlama) async{

    final conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName
    );

    await conn.connect();

    print("Connected");
    print("verileriCek secim : $secim");

    var atesBilgisiListe = <OlcumDegerleri>[];
    String butunDegerler = "SELECT * FROM test_tansiyon ORDER BY date_temp DESC";
    String hafta1 = "SELECT * FROM test_tansiyon WHERE date_temp >= DATE_SUB(NOW(), INTERVAL 1 WEEK) ORDER BY date_temp DESC";
    String hafta2 = "SELECT * FROM test_tansiyon WHERE date_temp >= DATE_SUB(NOW(), INTERVAL 2 WEEK) ORDER BY date_temp DESC";
    String hafta3 = "SELECT * FROM test_tansiyon WHERE date_temp >= DATE_SUB(NOW(), INTERVAL 3 WEEK) ORDER BY date_temp DESC";
    String ay1 = "SELECT * FROM test_tansiyon WHERE date_temp >= DATE_SUB(NOW(), INTERVAL 1 MONTH) ORDER BY date_temp DESC";

    String sorgu = "";
    if(sinirlama == "BÜTÜN SONUÇLAR") {
      sorgu = butunDegerler;
    }else if(sinirlama == "1 HAFTA") {
      sorgu = hafta1;
    }else if(sinirlama == "2 HAFTA") {
      sorgu = hafta2;
    }else if(sinirlama == "3 HAFTA") {
      sorgu = hafta3;
    }else if(sinirlama == "1 AY"){
      sorgu = ay1;
    }

    var dataAtesBilgisi = await conn.execute(sorgu);
    for (final row in dataAtesBilgisi.rows) {
      var data = OlcumDegerleri(
          ates: "ates",
          solunum: "solunum",
          nabiz: "nabiz",
          spo2: "spo2",
          sys: row.colByName("sys").toString(),
          dia: row.colByName("dia").toString(),
          gun: row.colByName("date_temp").toString());
      print(data.sys);
      print(data.dia);
      print(data.gun);
      atesBilgisiListe.add(data);
    }

    return atesBilgisiListe;
  }

  @override
  Widget build(BuildContext context) {
    print(secim);
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(title: Text("Tansiyon Liste Sonuçları"), backgroundColor: arkaPlan,),
        body: Column(
          children: [
            SizedBox(
              height: ekranYuksekligi/100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: ekranYuksekligi/20,
                  decoration: BoxDecoration(color: butunSonuclarArkaPlan, borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: DropdownButton(
                        value: secim,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: secimler.map((sec) {
                          return DropdownMenuItem(
                            value: sec,
                            child: Text(sec, style: TextStyle(color: butunSonuclarYazi, fontWeight: FontWeight.bold, fontSize: 12),),
                          );
                        }).toList(),
                        onChanged: (veri) {
                          setState(() {
                            secim = veri!;
                          });
                        }),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<OlcumDegerleri>>(
                future: verileriCek(secim),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var verilerListesi = snapshot.data;
                    return ListView.builder(
                        itemCount: verilerListesi!.length,
                        itemBuilder: (context, indeks){
                          var deger = verilerListesi[indeks];
                          return Card(
                              color: listeArkaPlan,
                              child: SizedBox(
                                  height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/10 : ekranGenisligi/10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("SYS ÖLÇÜLEN DEĞER  : ${deger.sys}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: listeYazi),),
                                            Text("DIA ÖLÇÜLEN DEĞER : ${deger.dia}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: listeYazi),)
                                          ],
                                        ),
                                        Text("ÖLÇÜLDÜĞÜ TARİH : ${deger.gun}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: listeYazi),)
                                      ],
                                    ),
                                  )
                              )
                          );
                        }
                    );
                  }else{
                    return const Center();
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}