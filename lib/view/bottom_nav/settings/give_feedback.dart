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
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16, bottom: kToolbarHeight / 2),
      showEmblem: false,
      backgroundType: BackgroundType.titleWithBackButton,
      title: LocaleKeys.give_feedback.tr(),
      logoAlign: Alignment.center,
      child:
          provider.isLoading
              ? Loading()
              : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CTextField(
                      margin: EdgeInsets.only(top: 40),
                      controller: provider.emailController,
                      labelText: LocaleKeys.email.tr(),
                      keyboardType: TextInputType.emailAddress,
                      hintText: LocaleKeys.your_email_here.tr(),
                    ),
                    CTextField(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      controller: provider.numberController,
                      labelText: LocaleKeys.number.tr(),
                      maxLength: 13,
                      keyboardType: TextInputType.phone,
                      hintText: LocaleKeys.your_number_here.tr(),
                    ),
                    CTextField(controller: provider.nameController, labelText: LocaleKeys.name.tr(), hintText: LocaleKeys.your_name_here.tr()),
                    CTextField(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      controller: provider.subjectController,
                      labelText: LocaleKeys.subject.tr(),
                      hintText: LocaleKeys.what_your_feedback_is_about.tr(),
                    ),
                    CTextField(controller: provider.feedbackController, maxLines: 10, hintText: LocaleKeys.type_your_feedback_here.tr()),
                    CButton(isLoading: provider.isLoading, margin: EdgeInsets.symmetric(vertical: 40), onTap: provider.submit, title: LocaleKeys.submit.tr(), titleWithIcon: true),
                  ],
                ),
              ),
    );
  }
}
