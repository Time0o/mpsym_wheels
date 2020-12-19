#!/bin/bash

set -e
set -x

BOOST_VERSION=1.75.0
LUA_VERSION=5.3.0

BOOST_DIR=/tmp/boost
LUA_DIR=/tmp/lua

# Update package manager
yum update -y

# Install dependencies

ROOT_DIR="$PWD"

# Install Boost
yum groupinstall -y "Development Tools"

BOOST_VERSION_="$(echo "$BOOST_VERSION" | tr . _)"
BOOST_ARCHIVE="boost_$BOOST_VERSION_.tar.gz"

BOOST_VARIANT="variant=release"
BOOST_CXXFLAGS="-O2"
BOOST_LINK="link=static"

mkdir -p "$BOOST_DIR" && cd "$BOOST_DIR"

curl -L "https://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION/$BOOST_ARCHIVE" -o "$BOOST_ARCHIVE"
tar zxf "$BOOST_ARCHIVE"
cd "boost_$BOOST_VERSION_"
./bootstrap.sh --with-libraries=graph
./b2 "$BOOST_VARIANT" "$BOOST_LINK" cxxflags="$BOOST_CXXFLAGS"

cd "$ROOT_DIR"

# Install Lua
yum install -y readline-devel

LUA_ARCHIVE="lua-$LUA_VERSION.tar.gz"

LUA_MYCFLAGS="-fPIC -O2"
LUA_MYLIBS="-ltermcap"

mkdir -p "$LUA_DIR" && cd "$LUA_DIR"

curl "https://www.lua.org/ftp/$LUA_ARCHIVE" -o "$LUA_ARCHIVE"
tar zxf "$LUA_ARCHIVE"
cd "lua-$LUA_VERSION"
make linux MYCFLAGS="$LUA_MYCFLAGS" MYLIBS="$LUA_MYLIBS"
make install

cd "$ROOT_DIR"
