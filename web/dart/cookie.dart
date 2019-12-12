@JS()
library cookie;

import 'package:js/js.dart';

@JS()
class Cookies {
  // external factory Cookie();
  external static String get(String name);
  external static void set(String name, String value);
}
