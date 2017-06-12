#!/bin/sh -e

. /etc/os-release
case "$ID" in
	"amzn")
		echo "Packaging..."
	;;
	"*")
		echo "An AWS Lambda function should only be packaged from an Amazon Linux to prevent broken shared library dependencies"
		exit
	;;
esac

FILES="apigwdyndns.py"
TARGET="build"
DIST="dist"
DEST="$DIST/apigwdyndns.zip"

test -d .env || (echo "missing virtualenv environement."; exit 1)

test ! -d "$TARGET" || rm -rf $TARGET
test ! -d "$DIST" || rm -rf $DIST
mkdir $TARGET $DIST

cp -pdr \
	$(find .env/lib64/python2.7/site-packages/ -maxdepth 1 -not -path .env/lib64/python2.7/site-packages/) \
	$(find .env/lib/python2.7/site-packages/ -maxdepth 1 -not -path .env/lib/python2.7/site-packages/) \
	"$TARGET/"

for F in $FILES; do
	cp -pd $F "$TARGET/"
done

rm -f "$DEST"
cd "$TARGET" && zip --recurse-paths -9 "../$DEST" ./
