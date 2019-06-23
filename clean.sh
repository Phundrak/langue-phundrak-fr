#!/usr/bin/env fish
set delfname "index.pdf" "*.tex" "*.aux" "*.log" "*.toc" "*.out" "header.pdf" \
             "header.html"
set deldname "auto" "_minted*"
for f in $delfname
    find -type f -name $f -delete
end
for d in $deldname
    find -type d -name $d -exec rm -r "{}" \;
end
