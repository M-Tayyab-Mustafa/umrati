import '../../../export.dart';

class GiveFeedbackPage extends ConsumerStatefulWidget {
  const GiveFeedbackPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GiveFeedbackPageState();
}

class _GiveFeedbackPageState extends ConsumerState<GiveFeedbackPage> {
  @override
  void initState() {
    super.initState();
    ref.read(giveFeedbackProvider.notifier).context = context;
    ref.read(giveFeedbackProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(giveFeedbackProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(giveFeedbackProvider);
    return Background(
      resizeToAvoidBottomInset: true,
      margin: ScaledEdgeInsets.zero,
      showEmblem: false,
      backgroundType: BackgroundType.titleWithBackButton,
      title: LocaleKeys.give_feedback.tr(),
      logoAlign: Alignment.center,
      child:
          provider.isLoading
              ? Loading()
              : SingleChildScrollView(
                child: Padding(
                  padding: ScaledEdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CTextField(
                        margin: ScaledEdgeInsets.symmetric(horizontal: 16),
                        controller: provider.emailController,
                        labelText: LocaleKeys.email.tr(),
                        textDirection: TextDirection.ltr,

                        keyboardType: TextInputType.emailAddress,
                        hintText: LocaleKeys.your_email_here.tr(),
                      ),
                      PhoneNumberTextField(
                        margin: ScaledEdgeInsets.symmetric(horizontal: 16, vertical: 25),
                        withCountryCodePicker: true,
                        initialCountryCode: provider.selectedCountry,
                        onChanged: (value) => Helper.fixPhoneFormate(value, provider.numberController),
                        updateSelectedCountry: provider.updateSelectedCountry,
                        controller: provider.numberController,
                      ),
                      CTextField(margin: ScaledEdgeInsets.symmetric(horizontal: 16), controller: provider.nameController, labelText: LocaleKeys.name.tr(), hintText: LocaleKeys.your_name_here.tr()),
                      CTextField(margin: ScaledEdgeInsets.symmetric(horizontal: 16, vertical: 25), controller: provider.subjectController, labelText: LocaleKeys.subject.tr(), hintText: LocaleKeys.what_your_feedback_is_about.tr()),
                      CTextField(margin: ScaledEdgeInsets.symmetric(horizontal: 16), controller: provider.feedbackController, maxLines: 10, hintText: LocaleKeys.type_your_feedback_here.tr()),
                      CButton(isLoading: provider.isLoading, margin: ScaledEdgeInsets.symmetric(vertical: 40), onTap: provider.submit, title: LocaleKeys.submit.tr(), titleWithIcon: true),
                    ],
                  ),
                ),
              ),
    );
  }
}
