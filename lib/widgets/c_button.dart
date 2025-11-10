// ignore_for_file: sized_box_for_whitespace

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

import '../themes/c_colors.dart';
import '../themes/c_textstyle.dart';
import 'c_container.dart';
import 'c_text.dart';

class CButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color color;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final FlexFit fit;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double space;
  final TextStyle textStyle;
  final BoxShadow? boxShadow;
  final BoxBorder? border;
  final Gradient? gradient;
  final bool isCanvas;
  final MainAxisAlignment mainAxisAlignment;
  final bool isOnlyIcon;
  final TextAlign? textAlign;
  final int? maxLines;

  const CButton({
    super.key,
    this.onTap,
    this.maxLines,
    this.width = 180,
    this.height = 50,
    this.text = "sample",
    this.borderRadius = BorderRadius.zero,
    this.color = CColors.inkA400,
    this.backgroundColor = CColors.transparent,
    this.fit = FlexFit.loose,
    this.prefixWidget,
    this.suffixWidget,
    this.margin,
    this.padding,
    this.space = 4.0,
    this.textStyle = CTextStyles.base,
    this.boxShadow,
    this.border,
    this.gradient,
    this.isCanvas = false,
    this.isOnlyIcon = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.textAlign = TextAlign.left,
  });

  factory CButton.base(
    String text, {
    double? width = 160,
    double? height = 48,
    VoidCallback? onTap,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? color,
    BoxShadow? boxShadow,
    Border? border,
    Gradient? gradient,
    TextStyle? textStyle,
    bool outline = true,
  }) => CButton(
    text: text,
    width: width,
    height: height,
    gradient: gradient,
    onTap: onTap,
    borderRadius: borderRadius ?? BorderRadius.circular(height ?? 0),
    color: color ?? CColors.primaryA500,
    textStyle: textStyle ?? CTextStyles.baseWhite.w500(16),
    margin: margin,
    padding: padding,
    backgroundColor: backgroundColor,
    boxShadow: boxShadow,
    border: outline ? (border ?? Border.all(color: CColors.primaryA500)) : null,
  );

  factory CButton.inkwell({
    Widget? child,
    VoidCallback? onTap,
    double radius = 0,
    double? width,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? backgroundColor,
  }) => CButton(
    text: "",
    width: width,
    height: height,
    onTap: onTap,
    margin: margin,
    padding: padding,
    borderRadius: BorderRadius.circular(radius),
    color: CColors.transparent,
    backgroundColor: backgroundColor ?? CColors.transparent,
    textStyle: CTextStyles.base.w600(20),
    space: 0,
    prefixWidget: child,
    isOnlyIcon: true,
  );

  factory CButton.icon(
    Widget icon, {
    double? width = 50,
    double? height = 50,
    VoidCallback? onTap,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? color,
    BoxShadow? boxShadow,
    Border? border,
    Gradient? gradient,
  }) => CButton(
    text: "",
    width: width,
    height: height,
    onTap: onTap,
    gradient: gradient,
    borderRadius: borderRadius ?? BorderRadius.circular(height ?? 0),
    color: color ?? CColors.primaryA500,
    textStyle: CTextStyles.base.w600(20),
    margin: margin,
    padding: padding,
    backgroundColor: backgroundColor,
    boxShadow: boxShadow,
    border: border,
    space: 0,
    prefixWidget: icon,
    isOnlyIcon: true,
  );

  factory CButton.defaultBtn(
    String text, {
    double? width = 160,
    double? height = 50,
    VoidCallback? onTap,
    BorderRadius borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(24),
    ),
    EdgeInsets? margin,
    Color? backgroundColor,
    BoxShadow? boxShadow,
  }) => CButton(
    text: text,
    width: width,
    height: height,
    onTap: onTap,
    borderRadius: borderRadius,
    color: CColors.primaryA500,
    textStyle: CTextStyles.base.w600(20),
    margin: margin,
    backgroundColor: backgroundColor,
    boxShadow: boxShadow,
  );

  @override
  Widget build(BuildContext context) {
    final childWidget = isOnlyIcon
        ? prefixWidget
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: mainAxisAlignment,
            children: [
              if (prefixWidget != null)
                Padding(
                  padding: EdgeInsets.only(right: space),
                  child: prefixWidget,
                ),
              Flexible(
                fit: fit,
                child: CText(
                  text,
                  style: textStyle,
                  textAlign: textAlign,
                  maxLines: maxLines,
                ),
              ),
              if (suffixWidget != null)
                Padding(
                  padding: EdgeInsets.only(left: space),
                  child: suffixWidget,
                ),
            ],
          );
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Opacity(
        opacity: onTap == null ? 0.7 : 1,
        child: CContainer(
          gradient: gradient,
          borderRadius: borderRadius,
          clipBehavior: Clip.none,
          color: backgroundColor ?? CColors.transparent,
          child: CupertinoButton(
            onPressed: onTap,
            color: color,
            minimumSize: Size(0, 0),
            padding: EdgeInsets.zero,
            borderRadius: borderRadius,
            disabledColor: CColors.inkA300,
            child: isCanvas
                ? Container(
                    width: width,
                    height: height,
                    child: CustomPaint(
                      size: Size(
                        // 100,
                        // 20,
                        width ?? 180,
                        ((width ?? 180) * 0.31216931216931215).toDouble(),
                      ),
                      painter: RPSCustomPainter(),
                      child: childWidget,
                    ),
                  )
                : Container(
                    width: width,
                    height: height,
                    padding: padding,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: border,
                      boxShadow: boxShadow != null ? [boxShadow!] : null,
                      gradient: gradient,
                    ),
                    child: childWidget,
                  ),
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.008);
    path_0.lineTo(size.width * 0.002, size.height * 0.008);
    path_0.lineTo(size.width * 0.002, size.height);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width, size.height * 0.4);
    path_0.lineTo(size.width * 0.88, size.height * 0.008);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = CColors.primaryA500;
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.88, size.height * 0.4);
    path_1.lineTo(size.width * 0.88, size.height * 0.008);
    path_1.lineTo(size.width, size.height * 0.4);
    path_1.lineTo(size.width * 0.88, size.height * 0.4);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.95, size.height * 0.2),
      Offset(size.width * 0.88, size.height * 0.4),
      [const Color(0xff736759), const Color(0xffFFB802)],
      [0, 1],
    );
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
