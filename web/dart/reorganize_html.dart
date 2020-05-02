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

Future<Element> makeLanguages() async {
  // Languages
  var languages = Element.ul()
    ..attributes['id'] = 'drop-lang'
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
          languages.insertAdjacentElement('beforeEnd', link);
        })
      });
  return Element.li()
    ..append(Element.a()
      ..attributes['href'] = 'javascript:void(0)'
      ..append(makeIcon(['fas', 'fa-language'])))
    ..classes.addAll(['nav-item', 'has-dropdown'])
    ..insertAdjacentElement('beforeEnd', languages);
}

Future<Element> makeTocDropDown() async {
  return Element.li()
    ..attributes['id'] = 'toc-drop'
    ..classes.addAll(['nav-item', 'has-dropdown'])
    ..append(Element.a()
      ..attributes['href'] = 'javascript:void(0)'
      ..append(makeIcon(['fas', 'fa-list-ol'], 'tocBtn')));
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
        ..append(makeIcon(['fas', 'fa-sun', 'fa-stack-1x'])..style.fontSize = '0.9em')
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

// Add a navbar atop of the HTML body, containing two buttons:
// - One back to home
// - A dropdown to each language detected in the sitemap
Future<Element> makeNavbar() async {
  var navbar_content = Element.ul()..classes.add('navbar-nav');

  // Home
  navbar_content.append(Element.li()
    ..classes.add('nav-item')
    ..insertAdjacentElement(
        'afterBegin',
        Element.a()
          ..attributes['href'] = '/'
          ..append(makeIcon(['fas', 'fa-home']))));

  // Add languages
  navbar_content.append(await makeLanguages());

  // TOC icon
  navbar_content.append(await makeTocDropDown());

  // Share icon
  navbar_content.append(await makeShare());

  // Theme changer
  navbar_content.append(await makeThemeChanger());

  // Navbar content added to navbar
  final navbar = Element.nav()
    ..classes.add('navbar')
    ..append(navbar_content);

  return navbar;
}

Element addIcon(Element navbar, List<String> classes, String id) {
  final icon = makeIcon(classes, id);
  navbar.append(Element.li()..append(icon));
  return navbar;
}

Element makeHeader() {
  var header = Element.tag('header');

  // querySelector('#container').append(Element.tag('header'));
  // var header = querySelector('header');
  header
    ..append(Element.img()
      ..attributes['src'] =
          'https://cdn.phundrak.com/img/mahakala-monochrome.png'
      ..attributes['alt'] = 'Logo de Phundrak'
      ..attributes['heigh'] = '150px'
      ..attributes['width'] = '150px')
    ..append(querySelector('h1'));
  var subt = querySelector('.subtitle');
  if (subt != null) {
    header.append(subt);
  }
  return header;
}

Future<void> wrapTables() async {
  for (var table in querySelectorAll('table')) {
    var largetable = DivElement()..className = 'largetable';
    table.before(largetable);
    largetable.children.add(table);
  }
}

Future<void> reorganizeHtml() async {
  // Create navbar and then header
  await makeNavbar().then((navbar) {
    querySelector('body').insertAdjacentElement('afterBegin', navbar);
    querySelector('nav').insertAdjacentElement('afterEnd', makeHeader());
    querySelector('#toc-drop')
        .append(querySelector('#table-of-contents')..classes.add('dropdown'));
  });

  // wrap tables in container for better SCSS display
  await wrapTables();
}
