################################################################################
#      This file is part of LibreELEC - https://LibreELEC.tv
#      Copyright (C) 2016-2017 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="tbs"
PKG_VERSION="170206"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tbsdtv.com/english/Download.html"
PKG_URL="http://www.tbsdtv.com/download/document/common/tbs-linux-drivers_v${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="Linux TBS tuner drivers"
PKG_LONGDESC="Linux TBS tuner drivers"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  unzip -q $ROOT/$SOURCES/$PKG_NAME/$PKG_SOURCE_NAME -d $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION
}

post_unpack() {
  tar xjf $ROOT/$PKG_BUILD/linux-tbs-drivers.tar.bz2 -C $ROOT/$PKG_BUILD
  chmod -R u+rwX $ROOT/$PKG_BUILD/linux-tbs-drivers/*
}

make_target() {
  cd $ROOT/$PKG_BUILD/linux-tbs-drivers
  ./v4l/tbs-x86_64.sh
  LDFLAGS="" make DIR=$(kernel_path) prepare
  LDFLAGS="" make DIR=$(kernel_path) -j4
}

makeinstall_target() {
  : # nothing
}

post_install() {
  MOD_VER=$(get_module_dir)

  # install media_build drivers
  cp -Pa $INSTALL/usr/lib/modules/$MOD_VER $INSTALL/usr/lib/modules/$MOD_VER-tbs
  mkdir -p $INSTALL/usr/lib/modules/$MOD_VER-tbs/updates/tbs
  find $ROOT/$PKG_BUILD/v4l/ -name \*.ko -exec cp {} $INSTALL/usr/lib/modules/$MOD_VER-tbs/updates/tbs \;
  echo "TBS drivers version: $PKG_VERSION" > $INSTALL/lib/usr/modules/$MOD_VER-tbs/updates/tbs-drivers.txt
}
