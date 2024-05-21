import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/network_image_viewer.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe.dart';

class ShoeTile extends StatefulWidget {
  final Shoe shoe;
  final void Function()? onPressed;
  const ShoeTile({
    super.key,
    required this.shoe,
    required this.onPressed,
  });

  @override
  State<ShoeTile> createState() => _ShoeTileState();
}

class _ShoeTileState extends State<ShoeTile>
    with AutomaticKeepAliveClientMixin {
  late final Shoe shoe;
  @override
  void initState() {
    shoe = widget.shoe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onPressed,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: NetworkImageViewer(imgUrl: shoe.imageUrlList[0]),
              ),
              SizedBox(
                height: 0.0114 * context.mqSize.height,
              ),
              Text(
                shoe.name,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 0.0205 * context.mqSize.height,
                ),
              ),
              SizedBox(
                height: 0.0057 * context.mqSize.height,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: const Color(0xffFCD240),
                    size: 0.0194 * context.mqSize.height,
                  ),
                  SizedBox(
                    width: 0.0121 * context.mqSize.width,
                  ),
                  Text(
                    shoe.avgRating.toString(),
                    style: TextStyle(
                      fontSize: 0.0182 * context.mqSize.height,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff12121D),
                    ),
                  ),
                  SizedBox(
                    width: 0.0121 * context.mqSize.width,
                  ),
                  Text(
                    '(${shoe.totalReviews} Reviews)',
                    style: TextStyle(
                      fontSize: 0.0182 * context.mqSize.height,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffB7B7B7),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.003 * context.mqSize.height,
              ),
              Text(
                '\$${shoe.price}',
                style: TextStyle(
                  fontSize: 0.0228 * context.mqSize.height,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff101010),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 0.0365 * context.mqSize.width,
              top: 0.0262 * context.mqSize.height,
            ),
            child: SvgPicture.asset(
                'assets/logos/${shoe.brandName.toLowerCase()}_logo.svg'),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
