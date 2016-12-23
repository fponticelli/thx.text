#!/bin/sh
set -e
cd doc
haxe build_doc.hxml || { cd ..; echo "build_doc failed"; exit 1; }
cd ..
rm -f thx.text.zip
zip -r thx.text.zip src doc/ImportText.hx test extraParams.hxml haxelib.json LICENSE README.md -x "*/\.*"
haxelib submit thx.text.zip
