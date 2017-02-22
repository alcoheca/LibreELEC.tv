################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
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

PKG_NAME="media_build"
PKG_VERSION="785cdf7"

# choose "LATEST" or a date like "2014-12-01-e8bd888" for the driver package
# chose from here http://linuxtv.org/downloads/drivers/
#
# the media_build and the actually used package have to fit together because
# master of media_build follows master of media_tree

MEDIA_BUILD_VERSION="2017-02-08-9eeb0ed0f309"

PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://git.linuxtv.org/media_build.git"
PKG_URL="http://mycvh.de/libreelec/$PKG_NAME/$PKG_NAME-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="DVB drivers that replace the version shipped with the kernel"
PKG_LONGDESC="DVB drivers that replace the version shipped with the kernel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export KERNEL_VER=$(get_module_dir)
  export LDFLAGS=""
}

make_target() {
  $SED -i  -e "/^LATEST_TAR/s/-LATEST/-$MEDIA_BUILD_VERSION/g" linux/Makefile
  make VER=$KERNEL_VER SRCDIR=$(kernel_path) -C linux/ download
  make VER=$KERNEL_VER SRCDIR=$(kernel_path) -C linux/ untar
  make VER=$KERNEL_VER SRCDIR=$(kernel_path) stagingconfig
  make VER=$KERNEL_VER SRCDIR=$(kernel_path)
}

makeinstall_target() {
  : # nothing
}

post_install() {
  MOD_VER=$(get_module_dir)

  # install media_build drivers
  cp -Pa $INSTALL/usr/lib/modules/$MOD_VER $INSTALL/usr/lib/modules/$MOD_VER-mb
  mkdir -p $INSTALL/usr/lib/modules/$MOD_VER-mb/updates/mb
  find $ROOT/$PKG_BUILD/v4l/ -name \*.ko -exec cp {} $INSTALL/usr/lib/modules/$MOD_VER-mb/updates/mb \;
  echo "Media_Build drivers version: $PKG_VERSION" > $INSTALL/lib/usr/modules/$MOD_VER-mb/updates/mb-drivers.txt
}
