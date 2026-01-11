class Barang {
  String id;
  String nama;
  int stok;
  int harga;

  Barang({
    required this.id,
    required this.nama,
    required this.stok,
    required this.harga,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'stok': stok,
      'harga': harga,
    };
  }

  factory Barang.fromMap(String id, Map<String, dynamic> map) {
    return Barang(
      id: id,
      nama: map['nama'],
      stok: map['stok'],
      harga: map['harga'],
    );
  }
}
