import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_not_defteri/kategori_islemleri.dart';
import 'package:flutter_not_defteri/models/kategori.dart';
import 'package:flutter_not_defteri/models/not.dart';
import 'package:flutter_not_defteri/not_detay.dart';
import 'package:flutter_not_defteri/utils/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var databaseHelper = DatabaseHelper();
    databaseHelper.kategoriGetir();
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.orange),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: notListesi(),
    );
  }
}

class notListesi extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.category),
                  title: Text("Kategori"),
                  onTap: () {
                    Navigator.pop(context);
                    _kategorilerSayfasinaGit(context);
                  },
                ),
              )
            ];
          })
        ],
        title: Center(
          child: Text("NOT SEPETİ"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Kategori Ekle",
            heroTag: "Kategori Ekle",
            child: Icon(
              Icons.add_box_outlined,
            ),
            onPressed: () {
              kategoriEkleDialog(context);
            },
            mini: true,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            tooltip: "Not Ekle",
            heroTag: "Not Ekle",
            child: Icon(Icons.add),
            onPressed: () {
              _deyatSayfasinaGit(context);
            },
          ),
        ],
      ),
      body: NotlarListele(),
    );
  }

  void _deyatSayfasinaGit(BuildContext context) {
    databaseHelper.kategoriGetir().then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotDetay(
            baslik: "Yeni Not",
          ),
        ),
      );
    });
  }

  void kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniKategori;
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori Ekle",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  onSaved: (yeniDeger) {
                    yeniKategori = yeniDeger;
                  },
                  validator: (value) {
                    if (value.length <= 3) {
                      return "En az 3 karakter giriniz";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Kategori Adı",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Vazgeç"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      databaseHelper
                          .kategoriEkle(Kategori(yeniKategori))
                          .then((value) {
                        if (value > 0) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Kategori Eklendi"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          debugPrint("kategori eklendi $value");
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: Text("Kaydet"),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Kategoriler()));
  }
}

class NotlarListele extends StatefulWidget {
  @override
  _NotlarListeleState createState() => _NotlarListeleState();
}

class _NotlarListeleState extends State<NotlarListele> {
  List<Not> tumNotlar;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumNotlar = List<Not>();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return FutureBuilder(
        future: databaseHelper.notListeGetir(),
        builder: (context, AsyncSnapshot<List<Not>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            tumNotlar = snapShot.data;
            sleep(Duration(milliseconds: 500));
            return ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    leading: _oncelikIconOlustur(tumNotlar[index].notOncelik),
                    title: Text(tumNotlar[index].notBaslik),
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Kategori:",
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    tumNotlar[index].kategoriBaslik,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Oluşturulma Tarihi:",
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(databaseHelper.dateFormat(
                                      DateTime.parse(
                                          tumNotlar[index].notTarih))),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Text(
                                "İçerik :\n" + tumNotlar[index].notIcerik,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _notSil(tumNotlar[index].notID),
                                  child: Text(
                                    "SİL",
                                    style:
                                        TextStyle(color: Colors.red.shade900),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deyatSayfasinaGit(
                                        context, tumNotlar[index]);
                                  },
                                  child: Text(
                                    "GÜNCELLE",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return Center(
              child: Text("Yükleniyor"),
            );
          }
        });
  }

  void _deyatSayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: "Notu Düzenle",
          duzenlenicekNot: not,
        ),
      ),
    );
  }

  _oncelikIconOlustur(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          child: Text(
            "Az",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade100,
        );
        break;
      case 1:
        return CircleAvatar(
          child: Text(
            "Orta",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade200,
        );
        break;
      case 2:
        return CircleAvatar(
          child: Text(
            "Acil",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade700,
        );
        break;
    }
  }

  _notSil(int notID) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Not Silindi")));
      }
      setState(() {});
    });
  }
}
