#!/bin/bash

set -e
set -x

if [ $# -ne 2 ]; then
  echo >&2 "Usage: $0 BOOST_VERSION LUA_VERSION"
  exit 1
fi;

BOOST_VERSION="${1%.*}"
LUA_VERSION=$2

# Update package manager
brew update
brew cleanup

# Install Boost
brew install boost@$BOOST_VERSION && brew link --force boost@$BOOST_VERSION

# Install Lua
LUA_DIR=/tmp/_lua
LUA_INSTALL_DIR=/tmp/lua

LUA_ARCHIVE="lua-$LUA_VERSION.tar.gz"

LUA_MYCFLAGS="-fPIC -O2"
LUA_MYLIBS="-ltermcap"

mkdir -p "$LUA_DIR"
(
  cd "$LUA_DIR"
  curl -L "https://www.lua.org/ftp/$LUA_ARCHIVE" -o "$LUA_ARCHIVE"
  tar zxf "$LUA_ARCHIVE"

  cd "lua-$LUA_VERSION"
  make macosx MYCFLAGS="$LUA_MYCFLAGS" MYLIBS="$LUA_MYLIBS"
  make install INSTALL_TOP=$LUA_INSTALL_DIR
)
