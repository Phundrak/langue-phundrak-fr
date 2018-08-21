#!/bin/sh

if [ $# -eq 0 ]; then
    project_root=`pwd`
    rm -f index.pdf
else
    project_root=$1
fi

rm -rf *~ auto _minted* *.tex *.aux *.log *.toc *.out headers.pdf headers.html
for filename in *; do
    if [[ -d $filename ]]; then
        cd $filename
        sh $project_root/clean.sh $project_root
        cd ..
    fi
done
