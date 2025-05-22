part of 'page.dart';

class AutoSelection extends ConsumerWidget {
  const AutoSelection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaratProvider);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 48), child: Text('${LocaleKeys.your_current_location.tr()}:', style: CTextStyle.w500(fontSize: 22))),
          FutureBuilder(
            future: provider.getLocation(),
            builder: (context, snapshot) {
              return Text('${snapshot.hasData ? snapshot.data : ''}');
            },
          ),
        ],
      ),
    );
  }
}
