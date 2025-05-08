import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/nav/ziarat/provider.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/translations/locale_keys.g.dart';
import '../../../utils/theme/text_style.dart';
import '../../../widgets/ziarat/city_card.dart';
import 'destinations.dart';

class ZiaratPage extends ConsumerStatefulWidget {
  const ZiaratPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CitiesPageState();
}

class _CitiesPageState extends ConsumerState<ZiaratPage> {
  late ZiaratNotifier notifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notifier = ref.watch(ziaratProvider.notifier);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.reset();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(ziaratProvider);
    return provider.selectedCity != null
        ? ZiaratDestinations()
        : Column(
          children: [
            Padding(padding: const EdgeInsets.only(top: 30), child: Text(LocaleKeys.select_ziarat_cities.tr(), textAlign: TextAlign.center, style: CTextStyle.w500(fontSize: 24))),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              children: [
                ZiaratCityCard(
                  icon: 'assets/svg/ziarat/macca.svg',
                  title: LocaleKeys.macca.tr(),
                  isSelected: provider.selectedCity == ZiaratCities.macca,
                  onTap: () => provider.updateSelectedCity(ZiaratCities.macca),
                ),
                ZiaratCityCard(
                  icon: 'assets/svg/ziarat/medina.svg',
                  title: LocaleKeys.medina.tr(),
                  isSelected: provider.selectedCity == ZiaratCities.medina,
                  onTap: () => provider.updateSelectedCity(ZiaratCities.medina),
                ),
                ZiaratCityCard(
                  icon: 'assets/svg/ziarat/taif.svg',
                  title: LocaleKeys.taif.tr(),
                  isSelected: provider.selectedCity == ZiaratCities.taif,
                  onTap: () => provider.updateSelectedCity(ZiaratCities.taif),
                ),
                ZiaratCityCard(
                  icon: 'assets/svg/ziarat/other.svg',
                  title: LocaleKeys.others.tr(),
                  isSelected: provider.selectedCity == ZiaratCities.other,
                  onTap: () => provider.updateSelectedCity(ZiaratCities.other),
                ),
              ],
            ),
          ],
        );
  }
}
