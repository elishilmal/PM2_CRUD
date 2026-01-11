import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/barang.dart';

class FirestoreService {
  final CollectionReference barangCollection =
      FirebaseFirestore.instance.collection('barang');

  // CREATE
  Future<void> tambahBarang(Barang barang) async {
    await barangCollection.add(barang.toMap());
  }

  // READ
  Stream<List<Barang>> getBarang() {
    return barangCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Barang.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateBarang(Barang barang) async {
    await barangCollection.doc(barang.id).update(barang.toMap());
  }

  // DELETE
  Future<void> hapusBarang(String id) async {
    await barangCollection.doc(id).delete();
  }
}
