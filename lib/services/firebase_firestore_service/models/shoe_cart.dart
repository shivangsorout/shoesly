import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly_app/constants/key_constants.dart';

class ShoeCart {
  final String documentId;
  final String shoeName;
  final String brandName;
  final String imgUrl;
  final MapEntry<String, dynamic> colorSelected;
  final num selectedSize;
  int quantity;
  final double price;

  ShoeCart({
    required this.documentId,
    required this.shoeName,
    required this.brandName,
    required this.imgUrl,
    required this.colorSelected,
    required this.selectedSize,
    required this.quantity,
    required this.price,
  });

  ShoeCart.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        shoeName = snapshot.data()[keyShoeName],
        brandName = snapshot.data()[keyBrandName],
        imgUrl = snapshot.data()[keyImgUrl],
        colorSelected = snapshot.data()[keyColorSelected],
        selectedSize = snapshot.data()[keySelectedSize],
        quantity = snapshot.data()[keyQuantity],
        price = snapshot.data()[keyShoePrice];

  toJson() => {
        keyDocumentId: documentId,
        keyShoeName: shoeName,
        keyBrandName: brandName,
        keyImgUrl: imgUrl,
        keyColorSelected: {colorSelected.key: colorSelected.value},
        keySelectedSize: selectedSize,
        keyQuantity: quantity,
        keyShoePrice: price,
      };

  @override
  bool operator ==(covariant ShoeCart other) => documentId == other.documentId;

  @override
  int get hashCode => documentId.hashCode;
}
