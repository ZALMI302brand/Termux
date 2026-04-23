#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: bash sign.sh filename.pdf"
  exit 1
fi

FILE=$1

if [ ! -f "$FILE" ]; then
  echo "File not found!"
  exit 1
fi

if [ ! -f "private.key" ]; then
  openssl genrsa -out private.key 2048
fi

if [ ! -f "certificate.crt" ]; then
  openssl req -new -key private.key -out request.csr \
  -subj "/C=IN/ST=Bihar/L=Patna/O=MyOrg/CN=Shivam Kumar"

  openssl x509 -req -days 365 -in request.csr -signkey private.key -out certificate.crt
fi

openssl dgst -sha256 -sign private.key -out "$FILE.sign" "$FILE"

echo "Done: $FILE.sign created"
