import 'package:get/get.dart';

import 'language_util/ar.dart';
import 'language_util/en.dart';

class Translat extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en':en,
    'ar':ar,
  };


}