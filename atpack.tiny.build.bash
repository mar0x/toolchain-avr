#!/bin/bash -ex
# Copyright (c) 2017 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

source build.conf

if [[ ! -f ${ATMEL_ATTINY_PACK_FILENAME}.zip ]] ;
then
  wget ${ATMEL_ATTINY_PACK_URL} -O ${ATMEL_ATTINY_PACK_FILENAME}.zip
fi

mkdir -p atpack
cd atpack
rm -rf *

unzip -q ../${ATMEL_ATTINY_PACK_FILENAME}.zip

source ../atpack.merge.bash

cd ..

