import 'dart:html';

import './navbar.dart' show makeNavbar;

Future<Element> makeHeader() async {
  var header = Element.tag('header');
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

// All images that are not nested inside a link will be linkified to themselves.
void linkifyImg() {
  querySelectorAll('img').forEach((img) {
    print(img.attributes['src']);
    print(img.parent.tagName);
    if (img.parent.tagName == 'P') {
      final link = Element.a()..attributes['href'] = img.attributes['src'];
      img.insertAdjacentElement('beforeBegin', link);
      link.append(img);
    }
  });
}

Future<void> reorganizeHtml() async {
  final content = querySelector('#content');

  // Make navbar
  await makeNavbar().then((navbar) {
    querySelector('body').insertAdjacentElement('afterBegin', navbar);
  });

  // Make header
  await makeHeader().then((header) {
    content.insertAdjacentElement('beforeBegin', header);
    final subtitle = querySelector('.subtitle');
    if (subtitle != null) {
      header.append(subtitle);
    }
  });

  // wrap tables in container for better SCSS display
  await wrapTables();

  linkifyImg();

  // Add correct class to TOC
  querySelector('#toc-drop')
      .append(querySelector('#table-of-contents')..classes.add('dropdown'));

  // Remove all <br> tags from HTML
  querySelectorAll('br').forEach((br) => br.remove());
}
