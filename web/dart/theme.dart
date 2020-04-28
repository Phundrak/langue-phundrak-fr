import 'dart:html';

class Theme {
  String _name;
  String _icon;

  Theme(String t_name, String t_icon) {
    _name = t_name;
    _icon = t_icon;
  }

  String getIcon() => _icon;
  String getName() => _name;
}

final themes = {
  'light': Theme('light', 'fa-sun'),
  'dark': Theme('dark', 'fa-lightbulb'),
  'black': Theme('black', 'fa-moon')
};

final localStorage = window.localStorage;

var currentTheme = themes[localStorage['theme']];

void makeThemeChanger() {
  final darkBtn = querySelector('#darkBtn');
  final lightBtn = querySelector('#lightBtn');
  final blackBtn = querySelector('#blackBtn');

  lightBtn.onClick.listen((_) => switchTheme(themes['light']));
  darkBtn.onClick.listen((_) => switchTheme(themes['dark']));
  blackBtn.onClick.listen((_) => switchTheme(themes['black']));
}

Future<void> setTheme() async {
  if (currentTheme == null) {
    currentTheme = themes['light'];
    localStorage['theme'] = currentTheme.getName();
  }
  querySelector('body')
    ..classes.clear()
    ..classes.add(currentTheme.getName());
}

void switchTheme(Theme currentTheme) {
  // Set HTML theme
  querySelector('body')
    ..classes.clear()
    ..classes.add(currentTheme.getName());
  // Set storage theme
  localStorage['theme'] = currentTheme.getName();
}
