import 'package:elektronik_saglik_platformu_doktor/data/doktorNotlariDegerler.dart';
import 'package:elektronik_saglik_platformu_doktor/data/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_doktor/renkler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';

class DoktorNotlari extends StatefulWidget {
  const DoktorNotlari({super.key});

  @override
  State<DoktorNotlari> createState() => _DoktorNotlariState();
}

class _DoktorNotlariState extends State<DoktorNotlari> {
  late String host;
  late int port;
  late String password;
  late String userName;
  late String databaseName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    MySQLBaglan baglan = MySQLBaglan();
    host = baglan.getHost();
    port = baglan.getPort();
    userName = baglan.getUserName();
    password = baglan.getPassword();
    databaseName = baglan.getDatabaseName();
  }

  Future<List<DoktorNotlariDegerler>> verileriCek() async {

  final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: userName,
      password: password,
      databaseName: databaseName
  );

  await conn.connect();

  print("Connected");

  var mesajBilgisiListe = <DoktorNotlariDegerler>[];
  var dataMesajBilgisi = await conn.execute("SELECT * FROM messages ORDER BY date DESC");
  for(final row in dataMesajBilgisi.rows) {
    var gelenDate = DateTime.parse(row.colByName("date").toString());
    var format = DateFormat('dd-MM-yyyy HH:mm');
    var guncellenmisDate = format.format(gelenDate);
    var data = DoktorNotlariDegerler(id: row.colByName("id").toString(), mesaj: row.colByName("message").toString(), tarih: guncellenmisDate);
    mesajBilgisiListe.add(data);
  }
    return mesajBilgisiListe;
  }

  Future<void> mesajiSil(String mesajId) async {

    final conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName
    );

    await conn.connect();

    print("Connected");

    int.parse(mesajId);
    await conn.execute("DELETE FROM message WHERE id = :id", {'id': mesajId});
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mesajınız başarıyla silindi."),
        duration: Duration(seconds: 3),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Gönderilen Notlar")),
      body: FutureBuilder<List<DoktorNotlariDegerler>>(
          future: verileriCek(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              var mesajlarListesi = snapshot.data;
              return ListView.builder(
                  itemCount: mesajlarListesi!.length,
                  itemBuilder: (context, indeks){
                    var mesaj = mesajlarListesi[indeks];
                    return Card(
                        color: gonderilenNotlarArkaPlan,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: ekranGenisligi/2,
                                    child: Text(mesaj.mesaj, style: TextStyle(color: gonderilenNotlarYazi, fontWeight: FontWeight.bold),)),
                                Text(mesaj.tarih)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: ekranGenisligi/2.5, height: ekranYuksekligi/30,
                                  child: ElevatedButton(style: ElevatedButton.styleFrom(
                                    backgroundColor: gonderilenNotlarMesajiSil,
                                  ),
                                      onPressed: (){
                                          mesajiSil(mesaj.id);

                                      },
                                      child: Text("Mesajı Sil", style: TextStyle(color: gonderilenNotlarMesajiSilYazi, fontWeight: FontWeight.bold),)
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      );
                  }
              );
            }else {
              return const Center();
            }
          },
        ),
    );
  }
}