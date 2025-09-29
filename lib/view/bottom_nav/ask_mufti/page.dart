import '../../../export.dart';

class AskMuftiPage extends ConsumerStatefulWidget {
  const AskMuftiPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AskMuftiPageState();
}

class _AskMuftiPageState extends ConsumerState<AskMuftiPage> {
  @override
  void initState() {
    super.initState();
    ref.read(askMuftiProvider.notifier).context = context;
    ref.read(askMuftiProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(askMuftiProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(askMuftiProvider);
    return Background(
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16, bottom: kToolbarHeight / 2),
      resizeToAvoidBottomInset: true,
      showEmblem: false,
      backgroundType: BackgroundType.titleWithBackButton,
      title: LocaleKeys.ask_mufti.tr(),
      logoAlign: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                controller: provider.scrollController,
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  var message = provider.messages[index];
                  return MessageCard(
                    message: message,
                    onCopyTap: () => provider.onCopyTap(message: message),
                    onLikeTap: () => provider.onLikeTap(message: message, index: index),
                    onSpeakTap: () => provider.onSpeakTap(message: message),
                  );
                },
              ),
            ),
          ),
          CTextField(
            controller: provider.queryController,
            boxShadow: [],
            borderColor: CColors.charcoalBlack,
            borderRadius: 20,
            hintText: LocaleKeys.type_your_problem_here.tr(),
            onSuffixTap: provider.send,
            suffixIcon: Transform.rotate(
              angle: isLTR(context) ? 0 : pi / 180 * 180,
              child: CustomImage(path: 'assets/svg/send.svg', imageType: ImageType.svg, size: MediaQuery.textScalerOf(context).scale(25), color: CColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
