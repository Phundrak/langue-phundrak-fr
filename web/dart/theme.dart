import 'dart:html';

void switchTheme(final Element body, String theme) {
  body.classes.clear();
  body.classes.add(theme);
}

void makeThemeChanger() {
  final darkBtn = querySelector('#darkBtn');
  final lightBtn = querySelector('#lightBtn');
  final body = querySelector('body');

  darkBtn.onClick.listen((_) {
    switchTheme(body, 'dark');
  });

  lightBtn.onClick.listen((_) {
    switchTheme(body, 'light');
  });
}
