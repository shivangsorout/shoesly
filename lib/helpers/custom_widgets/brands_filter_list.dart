import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/brand_filter_tile.dart';
import 'package:shoesly_app/helpers/custom_widgets/horizontal_filter_list.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';

class BrandsFilterList extends StatelessWidget {
  final List<Brand> brandsList;
  final Brand? selectedBrand;
  final void Function(dynamic) onSelect;

  const BrandsFilterList({
    super.key,
    required this.brandsList,
    required this.selectedBrand,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return HorizontalFilterList(
      itemsList: brandsList,
      selectedItem: selectedBrand,
      onSelect: onSelect,
      listViewHeight: 0.1198 * context.mqSize.height,
      paddingRight: 0.0243 * context.mqSize.width,
      childWidget: (index) {
        return BrandFilterTile(
          brandName: brandsList[index].brandName,
          items: brandsList[index].totalShoes,
          isSelected: selectedBrand == brandsList[index],
        );
      },
    );
  }
}
