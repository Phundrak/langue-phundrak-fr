import 'dart:html';

import './parse_sitemap.dart' show parseSitemap;

// Returns the title of the current webpage
String getPageTitle() {
  return querySelector('title').text;
}

Element makeIcon(List<String> classes, [String id]) {
  final icon = Element.tag('i')..classes.addAll(classes);
  if (id != null) {
    icon.attributes['id'] = id;
  }
  return icon;
}

Future<Element> makeToc() async {
  return Element.li()
    ..attributes['id'] = 'toc-drop'
    ..classes.addAll(['nav-item', 'has-dropdown'])
    ..append(Element.a()
      ..attributes['href'] = 'javascript:void(0)'
      ..append(makeIcon(['fas', 'fa-list-ol'], 'tocBtn')));
}

Future<Element> makePages() async {
  var pages = Element.ul()
    ..attributes['id'] = 'drop-page'
    ..classes.add('dropdown');
  await parseSitemap().then((final sitemap) => {
        sitemap.forEach((url, name) {
          final link = Element.li()
            ..classes.add('dropdown-item')
            ..insertAdjacentElement(
                'afterBegin',
                Element.a()
                  ..attributes['href'] = url
                  ..innerText = name);
          pages.insertAdjacentElement('beforeEnd', link);
        })
      });
  return Element.li()
    ..append(Element.a()
      ..attributes['href'] = 'javascript:void(0)'
      ..append(makeIcon(['fas', 'fa-flag'])))
    ..classes.addAll(['nav-item', 'has-dropdown'])
    ..insertAdjacentElement('beforeEnd', pages);
}

Element makeShareLink(Element icon, String url) {
  return Element.li()
    ..classes.add('dropdown-item')
    ..append(Element.a()
      ..attributes['href'] = url
      ..attributes['target'] = '_blank'
      ..append(icon));
}

Future<Element> makeShare() async {
  return Element.li()
    ..classes.addAll(['nav-item', 'has-dropdown'])
    ..append(Element.a()
      ..attributes['href'] = 'javascript:void(0)'
      ..append(makeIcon(['fas', 'fa-share-alt'])))
    ..append(Element.ul()
      ..classes.add('dropdown')
      ..attributes['id'] = 'drop-share'
      ..append(makeShareLink(
          makeIcon(['fab', 'fa-twitter-square']),
          'https://twitter.com/share?text=${getPageTitle()}'
          '&url=${window.location.href}'))
      ..append(makeShareLink(makeIcon(['fab', 'fa-reddit-square']),
          'https://www.reddit.com/submit?title=${getPageTitle()}s&url=${window.location.href}'))
      ..append(makeShareLink(makeIcon(['fas', 'fa-envelope-square']),
          'mailto:?subject=${getPageTitle}&body=${window.location.href}'))
      ..append(makeShareLink(
          makeIcon(['fab', 'fa-linkedin']),
          'https://www.linkedin.com/shareArticle?mini=true&url=${window.location.href}'
          '&title=${getPageTitle()}'))
      ..append(makeShareLink(makeIcon(['fab', 'fa-facebook-square']),
          'https://www.facebook.com/sharer/sharer.php?u=${window.location.href}')));
}

Future<Element> makeThemeChanger() async {
  Element makeThemeItem(String t_btnId, Element t_icon, String t_text) {
    return Element.li()
      ..classes.add('dropdown-item')
      ..append(Element.span()
        ..attributes['id'] = t_btnId
        ..append(t_icon)
        ..appendText(' $t_text'));
  }

  return Element.li()
    ..classes.addAll(['nav-item', 'has-dropdown'])
    ..append(Element.a()
      ..attributes['href'] = 'javascript:void(0)'
      ..append(Element.span()
        ..classes.add('fa-stack')
        ..style.verticalAlign = 'top'
        ..append(makeIcon(['fas', 'fa-sun', 'fa-stack-1x'])
          ..style.fontSize = '0.9em')
        ..append(makeIcon(['fas', 'fa-moon', 'fa-stack-1x']))))
    ..append(Element.ul()
      ..classes.add('dropdown')
      ..attributes['id'] = 'theme-dropdown'
      ..append(makeThemeItem('lightBtn', makeIcon(['fas', 'fa-sun']), 'Clair'))
      ..append(
          makeThemeItem('darkBtn', makeIcon(['fas', 'fa-lightbulb']), 'Sombre'))
      ..append(
          makeThemeItem('blackBtn', makeIcon(['fas', 'fa-moon']), 'Noir')));
}

Future<Element> makeHome() async {
  return Element.li()
    ..classes.add('nav-item')
    ..insertAdjacentElement(
        'afterBegin',
        Element.a()
          ..attributes['href'] = '/'
          ..append(makeIcon(['fas', 'fa-home'])));
}

// Add a navbar atop of the HTML body, containing two buttons:
// - One back to home
// - A dropdown to each page detected in the sitemap
Future<Element> makeNavbar() async {
  final navbar_content = Element.ul()..classes.add('navbar-nav');
  final home           = await makeHome();
  final pages          = await makePages();
  final toc            = await makeToc();
  final share          = await makeShare();
  final theme          = await makeThemeChanger();

  navbar_content
    ..append(home)
    ..append(pages)
    ..append(toc)
    ..append(share)
    ..append(theme);

  // Navbar content added to navbar
  final navbar = Element.nav()
    ..classes.add('navbar')
    ..append(navbar_content);

  return navbar;
}
