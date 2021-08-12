class Not {
  int notID, kategoriID, notOncelik;
  String notBaslik, notIcerik, notTarih, kategoriBaslik;
//verileri yazarken
  Not(this.kategoriID, this.notOncelik, this.notBaslik, this.notIcerik,
      this.notTarih);
//verileri okurken
  Not.withID(this.notID, this.kategoriID, this.notOncelik, this.notBaslik,
      this.notIcerik, this.notTarih);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["notID"] = notID;
    map["kategoriID"] = kategoriID;
    map["notBaslik"] = notBaslik;
    map["notIcerik"] = notIcerik;
    map["notTarih"] = notTarih;
    map["notOncelik"] = notOncelik;
    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    this.notID = map["notID"];
    this.kategoriID = map["kategoriID"];
    this.notBaslik = map["notBaslik"];
    this.notIcerik = map["notIcerik"];
    this.notTarih = map["notTarih"];
    this.kategoriBaslik = map["kategoriBaslik"];
    this.notOncelik = map["notOncelik"];
  }

  @override
  String toString() {
    return 'Not{notID: $notID, kategoriID: $kategoriID, notOncelik: $notOncelik, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih}';
  }
}
