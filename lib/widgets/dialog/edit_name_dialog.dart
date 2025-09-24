import '../../export.dart';

class EditNameDialog extends StatefulWidget {
  const EditNameDialog({super.key, required this.controller, required this.onUpdate});
  final TextEditingController controller;
  final Future<void> Function() onUpdate;

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  bool isLoading = false;
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
                      controller: widget.controller,
                      keyboardType: TextInputType.name,
                      labelText: LocaleKeys.name.tr(),
                    ),
                    CButton(
                      isLoading: isLoading,
                      margin: EdgeInsets.only(bottom: screenSize.height * 0.04),
                      height: 45,
                      shadows: [],
                      fontSize: 14,
                      title: LocaleKeys.update.tr(),
                      onTap: () async {
                        if (widget.controller.text.isEmpty) {
                          errorToast(LocaleKeys.field_cant_be_empty.tr());
                          return;
                        }
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          await widget.onUpdate();
                          Navigator.pop(dialogContext, true);
                        } catch (e) {
                          log(e.toString());
                          setState(() {
                            isLoading = false;
                          });
                        }
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
