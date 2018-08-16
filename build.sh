#!/usr/bin/env bash
cd "$(dirname "$0")/"

INSTALLDIR="${DEVKITPRO}/ppc-portlibs"

ENTITYX=entityx
ENTITYX_HASH=6389b1f91598c99d85e56356fb57d9f4683071d8
ENTITYX_DIR="${ENTITYX}-${ENTITYX_HASH}"
ENTITYX_URL="https://github.com/alecthomas/entityx/archive/${ENTITYX_HASH}.zip"

ROOT=$(pwd)
PATCHES="${ROOT}/patches"
SOURCES="${ROOT}/sources"

mkdir -p $SOURCES

function log {
	echo -e "\e[33m$1\e[39m $2"
}

function fail {
	echo -e "\e[1m\e[31mFATAL ERROR\e[0m ${@}\e[39m"
	exit 1
}
function check {
	if [[ $? -ne 0 ]]; then
		fail $@
	fi
}

function get_src {
	local NAME=${1}; NAME=${!NAME}
	local DIR=${1}_DIR; DIR=${!DIR}
	local URL=${1}_URL; URL=${!URL}
	local FILE="${NAME}-src.zip"

	cd $SOURCES
	if [ -d $DIR ]; then
		log $1 "${DIR} found"
	else
		log $1 "${DIR} not found, searching for archive"
		if [ -f $FILE ]; then
			log $1 "${FILE} found, extracting archive"
		else
			log $1 "${FILE} not found, fetching from network and extracting"
			wget -O $FILE --no-check-certificate $URL
			check "Could not download ${FILE} from ${URL}"
		fi
		unzip $FILE
		check "Could not extract ${FILE}"
	fi
}

while (( "$#" )); do
	case "$1" in
		#
		# EntityX
		#
		entityx)
			get_src ENTITYX

			# Copy patches
			log ENTITYX "Copying and applying patches"
			cp -v "${PATCHES}/devkitPPC.cmake" "${SOURCES}/${ENTITYX_DIR}/"

			if grep --quiet entityx_wii "${SOURCES}/${ENTITYX_DIR}/CMakeLists.txt"; then
				log ENTITYX "CMakeLists patch already applied, skipping..."
			else
				patch "${SOURCES}/${ENTITYX_DIR}/CMakeLists.txt" "${PATCHES}/entityx-CMakeLists.txt.patch"
				check "Failed to patch required files for building entityx"
			fi

			# Delete build folder if already exists
			if [[ -d "${SOURCES}/entityx-build" ]]; then
				log ENTITYX "Build folder found, deleting it..."
				rm -r "${SOURCES}/entityx-build"
			fi

			# Generate project and build it
			mkdir -p "${SOURCES}/entityx-build"
			cd "${SOURCES}/entityx-build"

			cmake "${SOURCES}/${ENTITYX_DIR}" -DENTITYX_DT_TYPE="float" -DENTITYX_MAX_COMPONENTS="32" -DCMAKE_INSTALL_PREFIX:PATH="${INSTALLDIR}" -G "Unix Makefiles"
			check "Could not generate project for entityx"

			make clean all
			check "Got error while building entityx"

			make install
			check "Got error while installing entityx"
			;;
	esac
	shift
done