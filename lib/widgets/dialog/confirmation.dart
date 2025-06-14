import '../../export.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key});

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: screenSize.width * 0.67,
              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.0),
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                          child: Text(LocaleKeys.confirmation_dialog.tr(), style: CTextStyle.w900(fontSize: 20, color: CColors.deepTeal), textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: CButton(title: LocaleKeys.cancel.tr(), onTap: () => Navigator.pop(dialogContext, false), margin: EdgeInsets.only(bottom: 30)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 16),
                          child: CButton(title: LocaleKeys.continued.tr(), onTap: () => Navigator.pop(dialogContext, true), margin: EdgeInsets.only(bottom: 30)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
