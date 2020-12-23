#!/bin/bash

set -e
set -x

ROOT_DIR="$PWD"

# Update package manager
yum update -y

# Install Boost
BOOST_VERSION=1.75.0
BOOST_DIR=/tmp/boost

BOOST_VERSION_="$(echo "$BOOST_VERSION" | tr . _)"
BOOST_ARCHIVE="boost_$BOOST_VERSION_.tar.gz"

BOOST_VARIANT="variant=release"
BOOST_CXXFLAGS="-O2"
BOOST_LINK="link=static"

yum groupinstall -y "Development Tools"

mkdir -p "$BOOST_DIR"
(
  cd "$BOOST_DIR"
  curl -L "https://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION/$BOOST_ARCHIVE" -o "$BOOST_ARCHIVE"
  tar zxf "$BOOST_ARCHIVE"

  cd "boost_$BOOST_VERSION_"
  ./bootstrap.sh --with-libraries=graph --preifx
  ./b2 "$BOOST_VARIANT" "$BOOST_LINK" cxxflags="$BOOST_CXXFLAGS"
)

# Install Lua
LUA_VERSION=5.3.0
LUA_DIR=/tmp/_lua
LUA_INSTALL_DIR=/tmp/lua

LUA_ARCHIVE="lua-$LUA_VERSION.tar.gz"
LUA_MYCFLAGS="-fPIC -O2"
LUA_MYLIBS="-ltermcap"

yum install -y readline-devel

mkdir -p "$LUA_DIR"
(
  cd "$LUA_DIR"
  curl -L "https://www.lua.org/ftp/$LUA_ARCHIVE" -o "$LUA_ARCHIVE"
  tar zxf "$LUA_ARCHIVE"

  cd "lua-$LUA_VERSION"
  make linux MYCFLAGS="$LUA_MYCFLAGS" MYLIBS="$LUA_MYLIBS"
  make install INSTALL_TOP=$LUA_INSTALL_DIR
)

cd "$ROOT_DIR"
