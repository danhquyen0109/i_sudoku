import 'package:flutter/material.dart';

import '../themes/c_colors.dart';

class CContainer extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;
  final BoxShadow? boxShadow;
  final Color borderColor;
  final double borderWidth;
  final double? height;
  final double? width;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final Clip clipBehavior;
  final bool isCircle;
  final Alignment? alignment;

  const CContainer({
    super.key,
    this.color,
    this.alignment,
    this.constraints,
    this.gradient,
    this.borderRadius,
    this.boxShadow,
    this.borderColor = CColors.inkA100,
    this.borderWidth = 0,
    this.height,
    this.width,
    this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.border,
    this.isCircle = false,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        margin: margin,
        width: width,
        height: height,
        constraints: constraints,
        clipBehavior: clipBehavior,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          gradient: gradient,
          boxShadow: boxShadow != null ? [boxShadow!] : null,
          border:
              border ??
              Border.all(
                color: borderColor,
                width: borderWidth,
                style: borderWidth > 0 ? BorderStyle.solid : BorderStyle.none,
              ),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
