#!/bin/sh

if [ $# -eq 0 ]; then
    project_root=`pwd`
else
    project_root=$1
fi

rm -rf *~
rm -rf auto
rm -rf _minted*
rm -rf *.tex
rm -rf index.pdf
for filename in *; do
    if [[ -d $filename ]]; then
        cd $filename
        sh $project_root/clean.sh $project_root
        cd ..
    fi
done
