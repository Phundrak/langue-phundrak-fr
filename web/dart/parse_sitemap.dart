import 'dart:html' show HttpRequest;

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Element;

// Get the sitemap content
Future<String> getSitemap() async {
  const path = 'sitemap.html';
  try {
    return await HttpRequest.getString(path);
  } catch (e) {
    print('Couldn’t open $path');
  }
  return 'Error';
}

// Parse the list of elements and detect pages from this list
Map<String, String> detectPages(List<Element> sitemap, [String prefix]) {
  final links = <String, String>{};
  for (var elem in sitemap) {
    if (elem.outerHtml.contains('index')) {
      continue;
    } else if (elem.innerHtml.startsWith('<a')) {
      elem = elem.firstChild;
      final url = elem.attributes['href'];
      final text = elem.firstChild.text;
      links[url] = (prefix == null) ? text : '$text ($prefix)';
    } else {
      final prefix = elem.firstChild.text;
      final ul = elem.children[0].children;
      links.addAll(detectPages(ul, prefix));
    }
  }
  return links;
}

// This function returns a Map which contains all links to languages detected
// from the sitemap.
Future<Map<String, String>> parseSitemap() async {
  final content = await getSitemap();
  final sitemap = parse(content).getElementsByClassName('org-ul')[0].children;
  return detectPages(sitemap);
}
