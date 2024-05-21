import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly_app/constants/key_constants.dart';

class Brand {
  final String documentId;
  final String brandName;
  final String logoUrl;
  final int totalShoes;

  Brand({
    required this.documentId,
    required this.brandName,
    required this.logoUrl,
    required this.totalShoes,
  });

  Brand.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        brandName = snapshot.data()[keyBrandName] as String,
        logoUrl = snapshot.data()[keyLogoURL] as String,
        totalShoes = snapshot.data()[keyTotalShoes] as int;

  toJson() => {
        keyDocumentId: documentId,
        keyBrandName: brandName,
        keyLogoURL: logoUrl,
        keyTotalShoes: totalShoes,
      };

  @override
  bool operator ==(covariant Brand other) => brandName == other.brandName;

  @override
  int get hashCode => documentId.hashCode;
}
