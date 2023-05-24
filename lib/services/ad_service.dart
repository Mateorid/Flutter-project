import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_sitting/Models/Ad/ad.dart';

class AdService {
  final _adCollection =
      FirebaseFirestore.instance.collection('Ads').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Ad.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  Future<void> createNewAd(Ad ad) async {
    await _adCollection.add(ad);
  }

  Stream<Ad?> getAdByIdStream(String adId) {
    return _adCollection.doc(adId).snapshots().map((event) => event.data());
  }

  Future<Ad> getAdById(String adId) async {
    final doc = await _adCollection.doc(adId).get();
    return doc.data()!;
  }

  Future<void> deleteAd(String adId) {
    return _adCollection.doc(adId).delete();
  }

  Future<void> updateAd(String adId, Ad ad) async {
    await _adCollection.doc(adId).update(ad.toJson());
  }

  Stream<List<Ad>> get adStream =>
      _adCollection.snapshots().map((querySnapshot) =>
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
}
