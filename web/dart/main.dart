@JS()
library main;

import 'dart:html';

import 'package:js/js.dart';

import './cookie.dart';

void main() {
  reorganizeHtml();
  createThemeSwitcher();
  themeSwitch(isThemeDark());
  querySelector('.themeBtn').onClick.listen(themeSwitchMouse);
}

String cookieThemeName = 'theme';

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
  if (Cookies.get(cookieThemeName) == 'light') {
    return false;
  }
  Cookies.set(cookieThemeName, 'dark');
  return true;
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

bool setTheme(bool dark) {
  Cookies.set(cookieThemeName, (dark ? 'dark' : 'light'));
  return !dark;
}

void themeSwitch(bool isDark) {
  querySelector('.fas').className = 'fas fa-' + (isDark ? 'sun' : 'moon');
  querySelector('#theme').attributes['href'] =
  'https://langue.phundrak.com/css/' + (isDark ? 'dark' : 'light') + '.css';
}

void themeSwitchMouse(MouseEvent event) {
  bool isDark = setTheme(!isThemeDark());
  themeSwitch(isDark);
}
