PACKAGE_NAME := $(shell cat 'src/info.json' | jq -r .name)
VERSION_STRING := $(shell cat 'src/info.json' | jq -r .version)
DIST_NAME := $(PACKAGE_NAME)_$(VERSION_STRING)
SOURCES = $(wildcard src/*) $(wildcard src/**/*)
DIST_DIR = dist
BUILD_PATH = ${DIST_DIR}/${DIST_NAME}
ZIP_PATH = ${BUILD_PATH}.zip
FACTORIO_BIN = factorio/bin/x64/factorio

.PHONY: clean default run

default: zip

zip: ${ZIP_PATH}

run: zip ${FACTORIO_BIN}
	${FACTORIO_BIN} --mod-directory ${DIST_DIR}

${FACTORIO_BIN}:
	@echo "Please place a factorio game installation at ./factorio/"
	exit 1

clean:
	rm -rf ${DIST_DIR}

${BUILD_PATH}: ${SOURCES}
	mkdir -p ${BUILD_PATH}
	touch ${BUILD_PATH}
	cp -r src/* ${BUILD_PATH}

${ZIP_PATH}: ${BUILD_PATH}
	rm -f ${DIST_DIR}/${DIST_NAME}.zip
	cd ${DIST_DIR} && zip -r ${DIST_NAME}.zip ${DIST_NAME}