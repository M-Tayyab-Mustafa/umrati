import '../../../export.dart';

final askMuftiProvider = ChangeNotifierProvider.autoDispose<AskMuftiNotifier>((ref) => AskMuftiNotifier());

class AskMuftiNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  final queryController = TextEditingController();
  List<MessageModel> messages = [];
  UserModel? user;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  Future<void> initialization() async {
    isLoading = true;
    if (context.mounted) notifyListeners();
    user = await LocalStorageManager.getUser(fromFirebase: true);
    var doc = await messagesCollection.doc(user!.uid).get();
    if (doc.exists) messages = List.from(doc.get('messages')).map((message) => MessageModel.fromMap(message)).toList();
    isLoading = false;
    if (context.mounted) notifyListeners();
    if (scrollController.hasClients) scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future<void> send() async {
    if (queryController.text.isEmpty) {
      errorToast(LocaleKeys.field_cant_be_empty.tr());
      return;
    }
    final newMessage = MessageModel(id: Uuid().v4(), question: queryController.text, answer: LocaleKeys.bot_is_typing.tr(), isLiked: false, isGeneratingAnswer: true);
    messages.add(newMessage);
    queryController.clear();
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    await _createBotApiCall(newMessage);
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future<void> onCopyTap({required MessageModel message}) async {
    await Clipboard.setData(ClipboardData(text: message.answer));
    infoToast(LocaleKeys.copied_to_clipboard.tr());
  }

  Future<void> onLikeTap({required MessageModel message, required int index}) async {
    messages[index] = message.copyWith(isLiked: !message.isLiked);
    notifyListeners();
  }

  Future<void> onSpeakTap({required MessageModel message}) async {}

  //Bot Api
  _createBotApiCall(MessageModel message) async {
    try {
      Uri uri = Uri.parse('https://automate.robustcraft.io/webhook/pdf-rag');
      final body = {'gender': user!.gender, 'question': message.question};
      final response = await post(uri, body: jsonEncode(body), headers: {'content-type': 'application/json'});
      if (response.statusCode == 200) {
        log(response.body);
      } else {
        messages.last = message.copyWith(answer: response.body, isGeneratingAnswer: false);
        notifyListeners();
      }
    } catch (e) {
      messages.last = message.copyWith(answer: e.toString(), isGeneratingAnswer: false);
      notifyListeners();
      log(e.toString());
    }
  }
}
