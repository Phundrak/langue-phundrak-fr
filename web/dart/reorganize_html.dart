import 'dart:html';

import './parse_sitemap.dart' show parseSitemap;

// Returns the title of the current webpage
String getPageTitle() {
  return querySelector('title').text;
}

Future<Element> addLanguages(Element navbar) async {
  // Languages
  var languages = Element.ul()..classes.add('dropdown');
  await parseSitemap().then((final sitemap) => {
        sitemap.forEach((url, name) {
          final link = Element.a()
            ..attributes['href'] = url
            ..innerText = name;

          final linkLi = Element.li()
            ..classes.add('dropdown-item')
            ..insertAdjacentElement('afterBegin', link);

          languages.insertAdjacentElement('beforeEnd', linkLi);
        })
      });
  navbar.append(Element.li()
    ..append(Element.a()
      ..attributes['href'] = '#'
      ..innerText = 'Langues')
    ..classes.add('nav-item')
    ..classes.add('has-dropdown')
    ..insertAdjacentElement('beforeEnd', languages));
  return navbar;
}

// Add a navbar atop of the HTML body, containing two buttons:
// - One back to home
// - A dropdown to each language detected in the sitemap
Future<Element> makeNavbar() async {
  // var _navbar = Navbar();

  // Home
  var navbar_content = Element.ul()..classes.add('navbar-nav');
  navbar_content.append(Element.li()
    ..classes.add('nav-item')
    ..insertAdjacentElement(
        'afterBegin',
        Element.a()
          ..attributes['href'] = '/'
          ..innerText = 'Accueil'));

  // Add languages
  // navbar_content.append(Element.html('''

  // '''));
  navbar_content = await addLanguages(navbar_content);

  // Page title
  navbar_content.append(Element.li()
    ..classes.add('nav-item')
    ..innerText = getPageTitle());

  // Share icon
  // Add dropdown for sharing on multiple platforms
  navbar_content = addIcon(navbar_content, ['fas', 'fa-share-alt'], 'shareBtn');

  // Theme changer
  // Add dropdown for theming
  // navbar_content = addIcon(navbar_content, ['fas', 'fa-sun'], 'themeBtn');
  navbar_content.append(Element.html('''
<li class="nav-item has-dropdown">
  <a href="#"><i class="fas fa-sun" id="themeBtn"></i></a>
  <ul class="dropdown" id="theme-dropdown">
    <li class="dropdown-item"><span id="lightBtn"><i class="fas fa-sun"></i> Clair</span></li>
    <li class="dropdown-item"><span id="darkBtn"> <i class="fas fa-moon"></i> Sombre</span></li>
  </ul>
</li>'''));

  // Navbar content added to navbar
  final navbar = Element.nav()
    ..classes.add('navbar')
    ..append(navbar_content);

  return navbar;
}

Element addIcon(Element navbar, List<String> classes, String id) {
  var elem = Element.tag('i')..attributes['id'] = id;
  for (var c in classes) {
    elem.classes.add(c);
  }
  navbar.append(Element.li()..append(elem));
  return navbar;
}

Future<void> wrapTables() async {
  for (var table in querySelectorAll('table')) {
    var largetable = DivElement()..className = 'largetable';
    table.before(largetable);
    largetable.children.add(table);
  }
}

Future<void> makeHeader() async {
  querySelector('body')
      .insertAdjacentElement('afterBegin', Element.tag('header'));
  querySelector('header').append(querySelector('h1'));
  querySelector('header').append(querySelector('.subtitle'));
}

Future<void> reorganizeHtml() async {
  await makeHeader();
  await wrapTables();
  await makeNavbar().then((navbar) {
    querySelector('body').insertAdjacentElement('afterBegin', navbar);
  });

  querySelector('body')
    ..classes.add('light')
    // Add a <hr> element after the content div
    ..appendHtml('<hr>')
    // Move the postamble in the content div
    ..append(querySelector('#postamble'));
}
