import '../../export.dart';

class Helper {
  static double degreesToRadians(double degrees) => degrees * pi / 180;
  static const double earthRadiusInMeters = 6371000;
  static String formatePhoneNumber(String phoneNumber, String dialCode) {
    return '$dialCode${phoneNumber.replaceAll(' ', '')}';
  }

  static Future<void> getCurrencySymbol() async {
    try {
      currencySymbol = (await FirebaseFirestore.instance.collection(CollectionNames.settings.name).doc(CommonDoc.currency.name).get()).get(CommonField.symbol.name);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  static String timeoutError = LocaleKeys.timeout_error.tr();
  static const int timeOutTime = 30; // in seconds

  static SubscriptionModel? userSubscription;

  static Future<bool> isHighTierRegion() async {
    try {
      var user = (await LocalStorageManager.getUser(fromFirebase: false))!;
      String countryCode = countryDialCodes.containsKey(user.country_code) ? countryDialCodes[user.country_code]! : "OTHER";
      var highTierRegionCodes = (await FirebaseFirestore.instance.collection(CollectionNames.settings.name).doc(CommonDoc.highTierRegionCodes.name).get()).get(CommonField.regions.name);
      return highTierRegionCodes.contains(countryCode);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
    return true;
  }

  static Future<Map<String, dynamic>?> getRouteLeg({required LatLng startPoint, required LatLng endPoint}) async {
    try {
      final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
        'origin': '${startPoint.latitude},${startPoint.longitude}',
        'destination': '${endPoint.latitude},${endPoint.longitude}',
        'mode': 'driving',
        'key': await mapsApiKey,
      });
      final response = await get(uri);
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (body['routes'].isNotEmpty) {
          final route = body['routes'].first as Map<String, dynamic>;
          final leg = route['legs'].first;
          return leg;
        } else {
          log('Routes not found.');
        }
      } else {
        log(body.toString());
      }
    } on ClientException catch (e) {
      if (kDebugMode) log(e.toString());
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
    return null;
  }

  static bool isUserInBetweenAlHajarAndMataf(double x1, double y1, double x2, double y2, double px, double py, double minimumDistance) {
    final distance = distanceFromPointToLine(startLat: x1, startLng: y1, endLat: x2, endLng: y2, pointLat: px, pointLng: py);
    return distance <= minimumDistance;
  }

  static double distanceFromPointToLine({required double startLat, required double startLng, required double endLat, required double endLng, required double pointLat, required double pointLng}) {
    double lat1 = degreesToRadians(startLat);
    double lon1 = degreesToRadians(startLng);
    double lat2 = degreesToRadians(endLat);
    double lon2 = degreesToRadians(endLng);
    double lat0 = degreesToRadians(pointLat);
    double lon0 = degreesToRadians(pointLng);
    double x1 = earthRadiusInMeters * lon1 * cos((lat1 + lat2) / 2);
    double y1 = earthRadiusInMeters * lat1;

    double x2 = earthRadiusInMeters * lon2 * cos((lat1 + lat2) / 2);
    double y2 = earthRadiusInMeters * lat2;

    double x0 = earthRadiusInMeters * lon0 * cos((lat1 + lat2) / 2);
    double y0 = earthRadiusInMeters * lat0;

    double A = y2 - y1;
    double B = x1 - x2;
    double C = x2 * y1 - x1 * y2;

    return (A * x0 + B * y0 + C).abs() / sqrt(A * A + B * B);
  }
}

class UsPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length && i < 10; i++) {
      if (i == 3) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }

    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}

class FormattedText extends StatelessWidget {
  final String rawText;
  const FormattedText({super.key, required this.rawText});

  @override
  Widget build(BuildContext context) {
    return Text.rich(parseFormattedText(rawText, context));
  }

  static TextSpan parseFormattedText(String text, BuildContext context) {
    final List<InlineSpan> spans = [];
    int currentPosition = 0;

    // Process the text until we've handled all of it
    while (currentPosition < text.length) {
      // Look for the next pattern match from current position
      final Match? nextMatch = _findNextPattern(text, currentPosition);

      if (nextMatch == null) {
        // No more patterns found, add remaining text
        spans.add(TextSpan(text: text.substring(currentPosition)));
        break;
      }

      // Add text before the match
      if (nextMatch.start > currentPosition) {
        spans.add(TextSpan(text: text.substring(currentPosition, nextMatch.start)));
      }

      // Handle the matched pattern
      spans.add(_handleMatch(nextMatch, text, context));

      // Move to the end of this match
      currentPosition = nextMatch.end;
    }

    return TextSpan(style: CTextStyle.w400(fontSize: 15), children: spans);
  }

  static Match? _findNextPattern(String text, int startPosition) {
    final List<RegExp> patterns = [
      RegExp(r"^#\s(.*?)(?=\n|$)", multiLine: true), // H1 Heading
      RegExp(r"^##\s(.*?)(?=\n|$)", multiLine: true), // H2 Heading
      RegExp(r"^###\s(.*?)(?=\n|$)", multiLine: true), // H3 Heading
      RegExp(r"\*\*(.*?)\*\*"), // Bold
      RegExp(r"[*\-]\s(.*?)(?=\n|$)", multiLine: true), // Bullet point
      RegExp(r"\d+\.\s(.*?)(?=\n|$)", multiLine: true), // Numbered list
    ];

    Match? earliestMatch;

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text.substring(startPosition));
      if (match != null) {
        final adjustedMatch = _adjustMatch(match, startPosition);
        if (earliestMatch == null || adjustedMatch.start < earliestMatch.start) {
          earliestMatch = adjustedMatch;
        }
      }
    }

    return earliestMatch;
  }

  static Match _adjustMatch(Match match, int offset) {
    return _OffsetMatch(match, offset);
  }

  static InlineSpan _handleMatch(Match match, String fullText, BuildContext context) {
    final String matchedText = match.group(0)!;

    // H1 Heading
    if (matchedText.startsWith('# ') && !matchedText.startsWith('##')) {
      final content = matchedText.substring(2);
      return TextSpan(children: parseFormattedText(content, context).children, style: CTextStyle.w800(fontSize: 20));
    }
    // H2 Heading
    else if (matchedText.startsWith('## ') && !matchedText.startsWith('###')) {
      final content = matchedText.substring(3);
      return TextSpan(children: parseFormattedText(content, context).children, style: CTextStyle.w800(fontSize: 18));
    }
    // H3 Heading
    else if (matchedText.startsWith('### ')) {
      final content = matchedText.substring(4);
      return TextSpan(children: parseFormattedText(content, context).children, style: CTextStyle.w800(fontSize: 14));
    }
    // Bold
    else if (matchedText.startsWith('**') && matchedText.endsWith('**')) {
      final content = matchedText.substring(2, matchedText.length - 2);
      return TextSpan(children: parseFormattedText(content, context).children, style: CTextStyle.w800(fontSize: 16));
    }
    // Bullet point
    else if (matchedText.startsWith('* ') || matchedText.startsWith('- ')) {
      final content = '\n•${matchedText.substring(1)}';
      return TextSpan(children: parseFormattedText(content, context).children, style: CTextStyle.w400(fontSize: 16));
    }
    // Numbered list
    else if (RegExp(r'^\d+\.').hasMatch(matchedText)) {
      final content = '${match.group(1)}\n';
      return TextSpan(children: parseFormattedText(content, context).children, style: CTextStyle.w600(fontSize: 16));
    }

    // Fallback: return as plain text
    return TextSpan(text: matchedText);
  }
}

class _OffsetMatch implements Match {
  final Match _match;
  final int _offset;

  _OffsetMatch(this._match, this._offset);

  @override
  String? group(int group) => _match.group(group);

  @override
  String? operator [](int group) => _match[group];

  @override
  int get groupCount => _match.groupCount;

  @override
  Pattern get pattern => _match.pattern;

  @override
  int get start => _match.start + _offset;

  @override
  int get end => _match.end + _offset;

  @override
  List<String?> groups(List<int> groupIndices) => _match.groups(groupIndices);

  @override
  String get input => _match.input;
}
