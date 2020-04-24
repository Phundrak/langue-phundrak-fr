import 'dart:html' show HttpRequest;

import 'package:html/parser.dart' show parse;

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

// This function returns a Map which contains all links to languages detected
// from the sitemap.
Future<Map<String, String>> parseSitemap() async {
  var links = <String, String>{};
  await getSitemap().then((String content) {
    final sitemap = parse(content).getElementsByClassName('org-ul')[0].children;
    for (var elem in sitemap) {
      // TODO: make this recursive so prefixes in nested folders can be added to
      // each other
      if (elem.innerHtml.startsWith('<a')) {
        elem = elem.firstChild;
        final text = elem.firstChild.text;
        final url = elem.attributes['href'];
        if (!url.contains('index')) {
          links[url] = text;
        }
      } else {
        print('Sitemap folder:\n${elem.innerHtml}');
      }
    }
  });
  return links;
}
