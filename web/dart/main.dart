import './reorganize_html.dart' show reorganizeHtml;
import './theme.dart' show makeThemeChanger;

Future<void> main() async {
  await reorganizeHtml().then((_) {
    makeThemeChanger();
  });
}
