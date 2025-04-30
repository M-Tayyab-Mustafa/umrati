import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.height, this.width, this.color});
  final double? height;
  final double? width;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(height: height ?? 15, width: width ?? 15, child: CircularProgressIndicator(color: color)));
  }
}
