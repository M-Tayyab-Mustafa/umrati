import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'loading.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.path,
    this.fit,
    this.height,
    this.width,
    this.imageType = ImageType.network,
    this.borderRadius,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
    this.margin,
    this.padding,
    this.onTap,
    this.color,
    this.enableBorder = false,
    this.loadingHeight,
    this.loadingWidth,
    this.gradientBorder,
  });

  final String path;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final double? loadingHeight;
  final double? loadingWidth;
  final Color? color;
  final ImageType imageType;
  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip clipBehavior;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final GestureTapCallback? onTap;
  final bool enableBorder;
  final Gradient? gradientBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: borderRadius ?? BorderRadius.zero, border: enableBorder ? Border() : null),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            clipper: clipper,
            clipBehavior: clipBehavior,
            child: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: Center(
                  child:
                      path.isEmpty
                          ? SvgPicture.asset('assets/svg/logo.svg', height: height, width: width, colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn))
                          : imageType == ImageType.file
                          ? Image.file(File(path), height: height, width: width, fit: fit, color: color)
                          : imageType == ImageType.png
                          ? Image.asset(path, height: height, width: width, fit: fit, color: color)
                          : imageType == ImageType.svg
                          ? SvgPicture.asset(path, colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn), height: height, width: width, fit: fit ?? BoxFit.contain)
                          : CachedNetworkImage(
                            imageUrl: path,
                            width: width,
                            height: height,
                            fit: fit,
                            errorWidget:
                                (context, exception, stackTrace) =>
                                    SvgPicture.asset('assets/svg/logo.svg', height: height, width: width, colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn)),
                            placeholder: (context, _) => SizedBox(height: loadingHeight, width: loadingWidth, child: Loading()),
                          ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ImageType { file, png, svg, network }
