import 'package:approncelizz/services/firestore_service.dart';
import 'package:flutter/material.dart';
import '../models/barang.dart';
import '../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController stokCtrl = TextEditingController();
  final TextEditingController hargaCtrl = TextEditingController();

  void _tambahBarang() {
    firestoreService.tambahBarang(
      Barang(
        id: '',
        nama: namaCtrl.text,
        stok: int.parse(stokCtrl.text),
        harga: int.parse(hargaCtrl.text),
      ),
    );
    namaCtrl.clear();
    stokCtrl.clear();
    hargaCtrl.clear();
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _dialogEdit(Barang barang) {
    namaCtrl.text = barang.nama;
    stokCtrl.text = barang.stok.toString();
    hargaCtrl.text = barang.harga.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Barang"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaCtrl,
              decoration: _inputStyle("Nama", Icons.inventory),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: stokCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputStyle("Stok", Icons.storage),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: hargaCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputStyle("Harga", Icons.monetization_on),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB6C7F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              firestoreService.updateBarang(
                Barang(
                  id: barang.id,
                  nama: namaCtrl.text,
                  stok: int.parse(stokCtrl.text),
                  harga: int.parse(hargaCtrl.text),
                ),
              );

              namaCtrl.clear();
              stokCtrl.clear();
              hargaCtrl.clear();

              Navigator.pop(context);
            },
            child: const Text("Ubah"),
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapus(Barang barang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Konfirmasi Hapus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Apakah kamu yakin ingin menghapus "${barang.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreService.hapusBarang(barang.id);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Barang"),
        centerTitle: true,
        backgroundColor: const Color(0xFFB6C7F4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// CARD INPUT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: namaCtrl,
                    decoration: _inputStyle("Nama Barang", Icons.inventory_2),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: stokCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputStyle("Stok", Icons.storage),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: hargaCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputStyle("Harga", Icons.attach_money),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFFF4B6C2), // pastel pink
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _tambahBarang,
                      child: const Text(
                        "Tambah Barang",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// LIST DATA
            Expanded(
              child: StreamBuilder<List<Barang>>(
                stream: firestoreService.getBarang(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final barang = data[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          title: Text(
                            barang.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Stok: ${barang.stok} | Harga: ${barang.harga}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _dialogEdit(barang),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _konfirmasiHapus(barang),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
