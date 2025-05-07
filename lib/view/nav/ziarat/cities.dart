import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/helper/constants.dart';
import '../../../widgets/background.dart';

class CitiesPage extends ConsumerStatefulWidget {
  const CitiesPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CitiesPageState();
}

class _CitiesPageState extends ConsumerState<CitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Background(backgroundType: BackgroundType.logo, child: Container());
  }
}
