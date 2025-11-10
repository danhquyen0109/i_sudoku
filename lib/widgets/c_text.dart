import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/c_colors.dart';
import '../themes/c_textstyle.dart';

class CText extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final EdgeInsets margin;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? minFontSize;
  final bool? softWrap;
  final bool? mandatory;
  final Gradient? gradient;
  final List<InlineSpan>? children;

  const CText(
    this.text, {
    super.key,
    this.textOverflow,
    this.softWrap,
    this.margin = EdgeInsets.zero,
    this.style = CTextStyles.base,
    this.textAlign = TextAlign.left,
    this.onTap,
    this.maxLines,
    this.gradient,
    this.mandatory,
    this.children,
    this.minFontSize,
  });

  CText copyWith({
    VoidCallback? onTap,
    String? text,
    EdgeInsets? margin,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
    double? minFontSize,
    bool? softWrap,
    Gradient? gradient,
    bool? mandatory,
    List<InlineSpan>? children,
  }) {
    return CText(
      text ?? this.text,
      mandatory: mandatory,
      gradient: gradient ?? this.gradient,
      margin: margin ?? this.margin,
      maxLines: maxLines ?? this.maxLines,
      minFontSize: minFontSize ?? this.minFontSize,
      onTap: onTap ?? this.onTap,
      softWrap: softWrap ?? this.softWrap,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      textOverflow: textOverflow ?? this.textOverflow,
      children: children ?? this.children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = minFontSize == null
        ? Text.rich(
            TextSpan(
              text: (text ?? '').tr,
              children: [
                if (children != null) ...children!,
                if (mandatory == true)
                  TextSpan(
                    text: ' *',
                    style: style?.copyWith(color: CColors.redA500),
                  ),
              ],
            ),
            textAlign: textAlign,
            softWrap: softWrap,
            style: style,
            overflow: textOverflow,
            maxLines: maxLines,
          )
        : AutoSizeText.rich(
            TextSpan(
              text: (text ?? '').tr,
              children: [
                if (children != null) ...children!,
                if (mandatory == true)
                  TextSpan(
                    text: ' *',
                    style: style?.copyWith(color: CColors.redA500),
                  ),
              ],
            ),
            textAlign: textAlign,
            softWrap: softWrap,
            style: style,
            minFontSize: minFontSize!,
            overflow: textOverflow,
            maxLines: maxLines,
          );
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: margin,
        child: gradient != null
            ? ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => gradient!.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: textWidget,
              )
            : textWidget,
      ),
    );
  }
}
