import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/models/kategori.dart';
import 'package:flutter_not_defteri/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  @override
  _KategorilerState createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler = List<Kategori>();
      kategoriListesiGuncelle();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategoriler"),
      ),
      body: ListView.builder(
        itemCount: tumKategoriler.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => kategoriGuncelleDialog(context, tumKategoriler[index]),
            title: Text(tumKategoriler[index].kategoriBaslik),
            trailing: GestureDetector(
              child: Icon(Icons.delete_forever_outlined),
              onTap: () => kategoriSil(tumKategoriler[index].kategoriID),
            ),
          );
        },
      ),
    );
  }

  void kategoriListesiGuncelle() {
    databaseHelper.kategoriListeGetir().then((kategorileriIcerenListe) {
      setState(() {
        tumKategoriler = kategorileriIcerenListe;
      });
    });
  }

  kategoriSil(int kategoriID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Kategori Sil"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Kategori silindiğinde alakalı tüm notlarda silinecektir."),
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "İptal",
                        style: TextStyle(color: Colors.green.shade400),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        databaseHelper.kategoriSil(kategoriID).then((value) {
                          if (value != 0) {
                            setState(() {
                              kategoriListesiGuncelle();
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      child: Text(
                        "Sil",
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void kategoriGuncelleDialog(
      BuildContext context, Kategori guncellenicekKategori) {
    var formKey = GlobalKey<FormState>();
    String guncellenicekKategoriAdi;
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori Güncelle",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  initialValue: guncellenicekKategori.kategoriBaslik,
                  onSaved: (yeniDeger) {
                    guncellenicekKategoriAdi = yeniDeger;
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
                          .kategoriGuncelle(Kategori.withID(
                              guncellenicekKategori.kategoriID,
                              guncellenicekKategoriAdi))
                          .then((value) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Kategori Güncellendi"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      });
                      kategoriListesiGuncelle();
                      Navigator.pop(context);
                    } else {
                      debugPrint("buraya girmiyor ");
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
}
