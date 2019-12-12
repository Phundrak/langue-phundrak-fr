@JS()
library main;

import 'dart:html';

import 'package:js/js.dart';
import './cookie.dart';

void main() {
  reorganizeHtml();
  createThemeSwitcher();
  querySelector('.themeBtn').onClick.listen(themeSwitch);
}

void createThemeSwitcher() {
  // set the correct CSS depending on the cookie, dark is enabled by default
  var isDark = isThemeDark();
  // Set the correct symbol in the theme switcher button
  querySelector('body').append(DivElement()..className = 'themeBtn');
  querySelector('.themeBtn')
      .children
      .add(Element.tag('i')..className = 'fas fa-' + (isDark ? 'sun' : 'moon'));
}

bool isThemeDark() {
  if (Cookies.get('theme') == 'light') {
    return false;
  }
  Cookies.set('theme', 'dark');
  return true;
}

bool setTheme(bool dark) {
  Cookies.set('theme', (dark ? 'dark' : 'light'));
  return !dark;
}

void themeSwitch(MouseEvent event) {
  print('Switch theme');
  bool isDark = setTheme(isThemeDark());
  querySelector('.fas').className = 'fas fa-' + (isDark ? 'sun' : 'moon');
  querySelector('#theme').attributes['href'] =
      '/css/' + (isDark ? 'dark' : 'light') + '.css';
}

void reorganizeHtml() {
  // Add a <hr> element after the content div
  querySelector('#content').appendHtml('<hr>');

  // Move the postamble in the content div
  querySelector('#content').append(querySelector('#postamble'));

  for (var table in querySelectorAll('table')) {
    var largetable = DivElement();
    largetable.className = 'largetable';
    table.before(largetable);
    largetable.children.add(table);
  }
}
