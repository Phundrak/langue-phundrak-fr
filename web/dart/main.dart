import './reorganize_html.dart' show reorganizeHtml;
import './theme.dart' show enableThemeChanger, setTheme;

Future<void> main() async {
  await setTheme();
  await reorganizeHtml().then((_) {
    enableThemeChanger();
  });
}
