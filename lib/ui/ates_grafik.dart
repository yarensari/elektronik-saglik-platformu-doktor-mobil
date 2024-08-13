import 'package:elektronik_saglik_platformu_doktor/data/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_doktor/data/olcumDegerleri.dart';
import 'package:elektronik_saglik_platformu_doktor/renkler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class AtesGrafik extends StatefulWidget {
  const AtesGrafik({super.key});

  @override
  State<AtesGrafik> createState() => _AtesGrafikState();
}

class _AtesGrafikState extends State<AtesGrafik> {
  String secim = "BÜTÜN SONUÇLAR";
  var secimler = <String>[];
  var atesBilgisiGrafik = <OlcumDegerleri>[];
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
    print("Connecting to mysql server...");

    // create connection
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

    String butunDegerler = "SELECT * FROM test_fever ORDER BY date";
    String hafta1 = "SELECT * FROM test_fever WHERE date >= DATE_SUB(NOW(), INTERVAL 1 WEEK) ORDER BY date DESC";
    String hafta2 = "SELECT * FROM test_fever WHERE date >= DATE_SUB(NOW(), INTERVAL 2 WEEK) ORDER BY date DESC";
    String hafta3 = "SELECT * FROM test_fever WHERE date >= DATE_SUB(NOW(), INTERVAL 3 WEEK) ORDER BY date DESC";
    String ay1 = "SELECT * FROM test_fever WHERE date >= DATE_SUB(NOW(), INTERVAL 1 MONTH) ORDER BY date DESC";

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
    atesBilgisiGrafik.clear();
    for (final row in dataAtesBilgisi.rows) {
      var gelenDate = DateTime.parse(row.colByName("date").toString());
      var format = DateFormat('dd-MM-yyyy HH:mm');
      var guncellenmisDate = format.format(gelenDate);
      var data = OlcumDegerleri(
          ates: row.colByName("fever").toString(),
          solunum: "solunum",
          nabiz: "nabiz",
          spo2: "spo2",
          sys: "sys",
          dia: "dia",
          gun: guncellenmisDate
      );
      //print(data.ates);
      //print(data.gun);
      atesBilgisiGrafik.add(data);
      print(atesBilgisiGrafik.length);
    }

    return atesBilgisiGrafik;
  }


  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(title: const Text("Grafik Sonuçları"),),
        body: SingleChildScrollView(
          child: Column(
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
                                child: Text(sec, style: TextStyle(color: butunSonuclarYazi, fontSize: 12, fontWeight: FontWeight.bold),),
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
                 FutureBuilder<List<OlcumDegerleri>>(
                      future: verileriCek(secim),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var veriler = snapshot.data;
                          return SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelRotation: 90,
                              ),
                              title: const ChartTitle(
                                text: "Ateş Değerleri",
                                textStyle: TextStyle(fontSize: 25),
                              ),
                               tooltipBehavior: TooltipBehavior(enable: true),
                              //legend: Legend(isVisible: true),
                              series: <LineSeries<OlcumDegerleri, String>>[
                                LineSeries(
                                  name: "Ateş Değerleri",
                                  color: grafikSonuclariRenklerAtes,
                                  dataSource: atesBilgisiGrafik,
                                  xValueMapper: (OlcumDegerleri data, _) => data.gun,
                                  yValueMapper: (OlcumDegerleri data, _) => double.parse(data.ates),
                                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  markerSettings: MarkerSettings(
                                    isVisible: true,
                                    shape: DataMarkerType.circle,
                                    height: 10,
                                    width: 10,
                                    borderColor: grafikSonuclariRenklerAtes,
                                    borderWidth: 2,
                                    color: grafikSonuclariRenklerAtes,
                                  ),
                                ),
                              ]
                          );
                        }else {
                          return const Center();
                        }
                      },
                    ),
              ]),
        )
    );
  }
}