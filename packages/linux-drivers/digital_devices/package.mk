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

PKG_NAME="digital_devices"
PKG_VERSION="37de742"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/DigitalDevices/dddvb/"
PKG_URL="https://github.com/DigitalDevices/dddvb/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="dddvb-${PKG_VERSION}*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="Linux Digital Devices manufacturer drivers"
PKG_LONGDESC="Linux Digital Devices manufacturer drivers"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  KDIR=$(kernel_path) make
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/modules/$(get_module_dir)/updates/$PKG_NAME
  find $ROOT/$PKG_BUILD/ -path $INSTALL -prune -o -name \*.ko -exec cp {} $INSTALL/usr/lib/modules/$(get_module_dir)/updates/$PKG_NAME \;
}
