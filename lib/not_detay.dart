import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/main.dart';
import 'package:flutter_not_defteri/models/kategori.dart';
import 'package:flutter_not_defteri/models/not.dart';
import 'package:flutter_not_defteri/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  Not duzenlenicekNot;
  NotDetay({this.baslik, this.duzenlenicekNot});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  DatabaseHelper databaseHelper;
  var formkey = GlobalKey<FormState>();
  List<Kategori> tumKategoriler;
  int kategoriId;
  String notBaslik, notIcerik;
  static var _secilenOncelikID;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKategoriler = List<Kategori>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kategoriGetir().then((kategoriMapListesi) {
      for (Map gelenKategori in kategoriMapListesi) {
        tumKategoriler.add(Kategori.fromMap(gelenKategori));
      }
      if (widget.duzenlenicekNot != null) {
        kategoriId = widget.duzenlenicekNot.kategoriID;
        _secilenOncelikID = widget.duzenlenicekNot.notOncelik;
      } else {
        kategoriId = 1;
        _secilenOncelikID = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.baslik),
      ),
      body: tumKategoriler.length <= 0
          ? CircularProgressIndicator()
          : Container(
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          child: Text(
                            "Kategori:",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.orangeAccent, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                items: kategoritemlerOlustur(),
                                value: kategoriId,
                                onChanged: (secilenKategoriID) {
                                  setState(() {
                                    kategoriId = secilenKategoriID;
                                  });
                                }),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        initialValue: widget.duzenlenicekNot != null
                            ? widget.duzenlenicekNot.notBaslik
                            : "",
                        validator: (text) {
                          if (text.length < 3) {
                            return "3 Karaterden fazla olmalı";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (text) {
                          notBaslik = text;
                        },
                        decoration: InputDecoration(
                          hintText: "Not Başlık Giriniz",
                          labelText: "Başlık",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        initialValue: widget.duzenlenicekNot != null
                            ? widget.duzenlenicekNot.notIcerik
                            : "",
                        onSaved: (text) => notIcerik = text,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Not İçerik Giriniz",
                          labelText: "İçerik",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          child: Text(
                            "Oncelik:",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.orangeAccent, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                items: _oncelik.map((e) {
                                  return DropdownMenuItem<int>(
                                    child: Text(
                                      e,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    value: _oncelik.indexOf(e),
                                  );
                                }).toList(),
                                value: _secilenOncelikID,
                                onChanged: (secilenOncelikiID) {
                                  setState(() {
                                    _secilenOncelikID = secilenOncelikiID;
                                  });
                                }),
                          ),
                        )
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.red;
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Vazgeç",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState.validate()) {
                              formkey.currentState.save();
                              var suan = DateTime.now();
                              if (widget.duzenlenicekNot == null) {
                                databaseHelper
                                    .notEkle(Not(kategoriId, _secilenOncelikID,
                                        notBaslik, notIcerik, suan.toString()))
                                    .then((value) {
                                  if (value != 0) {
                                    print(value);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            MyApp(),
                                      ),
                                    );
                                  }
                                });
                              } else {
                                databaseHelper
                                    .notGuncelle(Not.withID(
                                        widget.duzenlenicekNot.notID,
                                        kategoriId,
                                        _secilenOncelikID,
                                        notBaslik,
                                        notIcerik,
                                        suan.toString()))
                                    .then((value) {
                                  if (value != 0) {
                                    print(value);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            MyApp(),
                                      ),
                                    );
                                  }
                                });
                              }
                            }
                          },
                          child: Text(
                            "Kaydet",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategoritemlerOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem(
            value: kategori.kategoriID,
            child: Text(
              kategori.kategoriBaslik,
              style: TextStyle(fontSize: 20),
            )))
        .toList();
  }
}

/*
* Form(
        key: formkey,
        child: Column(
          children: [
            DropdownButtonHideUnderline(
              child: tumKategoriler.length <= 0
                  ? Center(
                      child: CircleAvatar(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        child: DropdownButton<int>(
                          items: kategoritemlerOlustur(),
                          value: kategoriId,
                          onChanged: (secilenKategoriID) {
                            setState(() {
                              kategoriId = secilenKategoriID;
                            });
                          },
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.orangeAccent, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      ),
                    ),
            ),
          ],
        ),
      ),
* */
