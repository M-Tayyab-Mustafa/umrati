import '../export.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.path,
    this.fit,
    this.size,
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
    this.border,
  });

  final String path;
  final BoxFit? fit;
  final double? size;
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
  final Border? border;
  final Gradient? gradientBorder;

  ColorFilter? get _colorFilter => color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn);

  @override
  Widget build(BuildContext context) {
    Widget imageChild = _buildImage();

    if (borderRadius != null || clipper != null) {
      imageChild = ClipRRect(borderRadius: borderRadius ?? BorderRadius.zero, clipper: clipper, clipBehavior: clipBehavior, child: imageChild);
    }

    if (padding != null) {
      imageChild = Padding(padding: padding!, child: imageChild);
    }

    if (size != null || height != null || width != null) {
      imageChild = SizedBox(height: size ?? height, width: size ?? width, child: Center(child: imageChild));
    }

    if (enableBorder) {
      imageChild = Container(decoration: BoxDecoration(borderRadius: borderRadius ?? BorderRadius.zero, border: border ?? const Border()), child: imageChild);
    }

    if (onTap != null) {
      imageChild = GestureDetector(onTap: onTap, child: imageChild);
    }

    if (margin != null) {
      return Padding(padding: margin!, child: imageChild);
    }
    return imageChild;
  }

  Widget _buildImage() {
    if (path.isEmpty) {
      return SvgPicture.asset('assets/svg/logo.svg', height: size ?? height, width: size ?? width, colorFilter: _colorFilter);
    }
    switch (imageType) {
      case ImageType.file:
        return Image.file(File(path), height: size ?? height, width: size ?? width, fit: fit, color: color);
      case ImageType.png:
        return Image.asset(path, height: size ?? height, width: size ?? width, fit: fit, color: color);
      case ImageType.svg:
        return SvgPicture.asset(path, colorFilter: _colorFilter, height: size ?? height, width: size ?? width, fit: fit ?? BoxFit.contain, allowDrawingOutsideViewBox: true);
      case ImageType.network:
        return CachedNetworkImage(
          imageUrl: path,
          width: size ?? width,
          height: size ?? height,
          fit: fit,
          errorWidget: (_, _, _) => SvgPicture.asset('assets/svg/logo.svg', height: size ?? height, width: size ?? width, colorFilter: _colorFilter),
          placeholder: (_, _) => SizedBox(height: loadingHeight, width: loadingWidth, child: const Loading()),
        );
    }
  }
}
