import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class PriceRangeSlider extends StatefulWidget {
  final void Function(double, double) onRangeSelect;
  final int lowerValue;
  final int upperValue;
  const PriceRangeSlider({
    super.key,
    required this.onRangeSelect,
    required this.lowerValue,
    required this.upperValue,
  });

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  CustomRangeSliderThumbShape? _rangeSlider;
  RangeValues? _currentRangeValues;

  @override
  void initState() {
    initializeSlider();
    super.initState();
  }

  void initializeSlider() {
    _rangeSlider =
        CustomRangeSliderThumbShape(widget.lowerValue, widget.upperValue);
    _currentRangeValues =
        RangeValues(widget.lowerValue.toDouble(), widget.upperValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    initializeSlider();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            overlayColor: Colors.black.withOpacity(0.2), // Custom overlay color
            rangeThumbShape: _rangeSlider, // Custom th
            trackHeight: 3,
            valueIndicatorColor: Colors.transparent,
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: RangeSlider(
            values: _currentRangeValues!,
            min: 0,
            max: 1750,
            onChanged: (value) {
              _rangeSlider!.start = value.start.round();
              _rangeSlider!.end = value.end.round();
              setState(() {
                _currentRangeValues = value;
              });
              widget.onRangeSelect(
                (_rangeSlider!.start as int).toDouble(),
                (_rangeSlider!.end as int).toDouble(),
              );
            },
            activeColor: Colors.black,
            inactiveColor: const Color(0xffE6E6E6),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 0.034 * context.mqSize.width,
            right: 0.0045 * context.mqSize.width,
          ),
          child: Row(
            children: [
              Text(
                '\$0',
                style: TextStyle(
                  color: const Color(0xffAAAAAA),
                  fontSize: 0.0228 * context.mqSize.height,
                ),
              ),
              const Expanded(child: Row()),
              Text(
                '\$1750',
                style: TextStyle(
                  color: const Color(0xffAAAAAA),
                  fontSize: 0.0228 * context.mqSize.height,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomRangeSliderThumbShape<T> extends RangeSliderThumbShape {
  CustomRangeSliderThumbShape(this.start, this.end);

  static const double _thumbSize = 20.0; // Adjust size as needed
  T start;
  T end;
  TextPainter labelTextPainter = TextPainter()
    ..textDirection = TextDirection.ltr;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(_thumbSize, _thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = Colors.white // Fill color for the thumb
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.black // Border color for the thumb
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0; // Width of the border

    // Draw the filled circle
    canvas.drawCircle(center, _thumbSize / 2, fillPaint);

    // Draw the border circle
    canvas.drawCircle(center, _thumbSize / 2, borderPaint);
    final value = thumb == Thumb.start ? start : end;
    labelTextPainter.text = TextSpan(
      text: '\$$value',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
    labelTextPainter.layout();
    labelTextPainter.paint(
        canvas,
        center.translate(
            -labelTextPainter.width / 2, labelTextPainter.height + 7));
  }
}
