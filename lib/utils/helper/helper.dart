import '../../../export.dart';

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

  // Find the intersection point where a perpendicular line from point C meets the vector from A in direction of B
  static LatLng findIntersectionPoint(LatLng pointA, LatLng directionB, LatLng pointC) {
    // Convert points to Cartesian coordinates on unit sphere
    List<double> aCart = _latLngToCartesian(pointA);
    List<double> bCart = _latLngToCartesian(directionB);
    List<double> cCart = _latLngToCartesian(pointC);

    // Calculate the vector from A to B (direction vector)
    List<double> abVector = _subtractVectors(bCart, aCart);

    // Calculate the vector from A to C
    List<double> acVector = _subtractVectors(cCart, aCart);

    // Project AC onto AB to find the scalar projection
    double projectionScalar = _dotProduct(acVector, abVector) / _dotProduct(abVector, abVector);

    // Calculate the projection point on the vector
    List<double> projectionCart = [aCart[0] + projectionScalar * abVector[0], aCart[1] + projectionScalar * abVector[1], aCart[2] + projectionScalar * abVector[2]];

    // Normalize the projection point to lie on the unit sphere
    projectionCart = _normalizeVector(projectionCart);

    // Convert back to geographic coordinates
    return _cartesianToLatLng(projectionCart);
  }

  // Calculate distance between point C and its projection on the vector
  static double distanceToVector(LatLng pointA, LatLng directionB, LatLng pointC) {
    LatLng intersection = findIntersectionPoint(pointA, directionB, pointC);
    log('pointA: $pointA, directionB: $directionB, pointC: $pointC, intersection: $intersection');
    return distance(pointC, intersection);
  }

  // Convert LatLng to Cartesian coordinates on unit sphere
  static List<double> _latLngToCartesian(LatLng coord) {
    double lat = coord.latitude * pi / 180;
    double lon = coord.longitude * pi / 180;

    double x = cos(lat) * cos(lon);
    double y = cos(lat) * sin(lon);
    double z = sin(lat);

    return [x, y, z];
  }

  // Convert Cartesian coordinates to LatLng
  static LatLng _cartesianToLatLng(List<double> cartesian) {
    double x = cartesian[0];
    double y = cartesian[1];
    double z = cartesian[2];

    double lon = atan2(y, x);
    double hyp = sqrt(x * x + y * y);
    double lat = atan2(z, hyp);

    return LatLng(lat * 180 / pi, lon * 180 / pi);
  }

  // Subtract two vectors
  static List<double> _subtractVectors(List<double> a, List<double> b) {
    return [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
  }

  // Calculate dot product of two vectors
  static double _dotProduct(List<double> a, List<double> b) {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
  }

  // Normalize a vector
  static List<double> _normalizeVector(List<double> vector) {
    double length = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
    return [vector[0] / length, vector[1] / length, vector[2] / length];
  }

  // Calculate distance between two points using Haversine formula
  static double distance(LatLng p1, LatLng p2) {
    double lat1 = p1.latitude * pi / 180;
    double lon1 = p1.longitude * pi / 180;
    double lat2 = p2.latitude * pi / 180;
    double lon2 = p2.longitude * pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    log('${earthRadiusInMeters * c}');
    return earthRadiusInMeters * c;
  }

  static String generateRandomId([int length = 12]) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
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
