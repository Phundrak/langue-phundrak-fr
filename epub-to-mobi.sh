#!/usr/bin/env fish

for file in (find -type f | grep epub | grep -v "epub-to-mobi" | sed 's/\.[^.]*$//')
  ebook-convert $file.epub $file.mobi
end
