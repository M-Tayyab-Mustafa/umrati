import '../../export.dart';

class PlanKeyDialog extends StatelessWidget {
  const PlanKeyDialog({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: GestureDetector(
        onTap: () => Navigator.pop(dialogContext),
        child: Stack(
          children: [
            Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
                decoration: BoxDecoration(
                  color: CColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CColors.primary, width: 2),
                  boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CTextField(
                      margin: EdgeInsets.only(top: screenSize.height * 0.04, bottom: screenSize.height * 0.03),
                      controller: controller,
                      keyboardType: TextInputType.text,
                      labelText: LocaleKeys.key.tr(),
                    ),
                    CButton(
                      margin: EdgeInsets.only(bottom: screenSize.height * 0.04),
                      height: 45,

                      fontSize: 14,
                      title: LocaleKeys.continued.tr(),
                      onTap: () {
                        if (controller.text.isEmpty) {
                          errorToast(LocaleKeys.please_enter_valid_key.tr());
                          return;
                        }
                        Navigator.pop(dialogContext, true);
                      },
                      style: CTextStyle.w400(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
