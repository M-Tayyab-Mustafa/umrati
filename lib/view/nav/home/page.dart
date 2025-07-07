import '../../../controller/nav/home/provider.dart';
import '../../../export.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            card(
              constraints: constraints,
              onTap: () => ref.read(homeProvider).onumraTap(context: context, ref: ref),
              title: LocaleKeys.umra.tr(),
              description: LocaleKeys.start_your_umra_from_here.tr(),
              image: '',
            ),
            card(
              constraints: constraints,
              onTap: () => ref.read(homeProvider).onTawafTap(context: context, ref: ref),
              title: LocaleKeys.tawaf.tr(),
              description: LocaleKeys.start_your_tawaf_from_here.tr(),
              image: '',
            ),
            card(
              constraints: constraints,
              onTap: () => ref.read(homeProvider).onZiaratTap(context: context, ref: ref),
              title: LocaleKeys.ziarat.tr(),
              description: LocaleKeys.start_your_ziarat_from_here.tr(),
              image: '',
            ),
          ],
        );
      },
    );
  }

  Widget card({required BoxConstraints constraints, required VoidCallback onTap, required String title, required String description, required String image}) {
    return BasicCard(
      onTap: onTap,
      height: constraints.maxHeight * 0.25,
      borderColor: CColors.grey,
      boxShadow: greyShadows,
      child: Row(
        children: [
          Expanded(flex: 3, child: CustomImage(path: image, fit: BoxFit.fill)),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: CTextStyle.w600(fontSize: 26, color: CColors.deepTeal), maxLines: 1),
                      Padding(padding: EdgeInsets.only(left: isLTR(context) ? 16 : 0, right: isLTR(context) ? 0 : 16), child: Icon(Icons.arrow_forward_rounded, size: 26, color: CColors.deepTeal)),
                    ],
                  ),
                  Text(description, style: CTextStyle.w600(color: CColors.deepTeal), maxLines: 2, textScaler: TextScaler.linear(0.85)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
