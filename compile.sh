#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o noclobber

export PATH=$PATH:/usr/lib/libreoffice/sdk/bin
export PATH=$PATH:/usr/lib/libreoffice/program

# Setup build directories

rm -rf "${PWD}"/build

mkdir "${PWD}"/build
mkdir "${PWD}"/build/META-INF/

# Compile the binaries

echo "Calling idlc..."
idlc -w -verbose "${PWD}"/idl/XFinancials.idl

echo "Calling regmerge..."
regmerge -v "${PWD}"/build/XFinancials.rdb UCR "${PWD}"/idl/XFinancials.urd

rm "${PWD}"/idl/XFinancials.urd

echo "Generating meta files..."
python3 "${PWD}"/src/generate_metainfo.py

cp -f "${PWD}"/src/financials.py "${PWD}"/build/
cp -f "${PWD}"/src/datacode.py "${PWD}"/build/
cp -f "${PWD}"/src/baseclient.py "${PWD}"/build/
cp -f "${PWD}"/src/jsonParser.py "${PWD}"/build/
cp -f "${PWD}"/src/naivehtmlparser.py "${PWD}"/build/
cp -f "${PWD}"/src/tz.py "${PWD}"/build/
cp -f "${PWD}"/src/financials_ft.py "${PWD}"/build/
cp -f "${PWD}"/src/financials_google.py "${PWD}"/build/
cp -f "${PWD}"/src/financials_yahoo.py "${PWD}"/build/

echo "Package into oxt file..."
pushd "${PWD}"/build/
zip -r "${PWD}"/Financials-Extension.zip ./*
popd

mv "${PWD}"/build/Financials-Extension.zip "${PWD}"/Financials-Extension.oxt
