PACKAGE_NAME := $(shell cat 'src/info.json' | jq -r .name)
VERSION_STRING := $(shell cat 'src/info.json' | jq -r .version)
DIST_NAME := $(PACKAGE_NAME)_$(VERSION_STRING)
SOURCES = $(wildcard src/**/*)
DIST_DIR = dist

.PHONY: clean default

default: ${DIST_DIR}/${DIST_NAME}.zip

${DIST_DIR}/${DIST_NAME}: ${SOURCES}
	mkdir -p ${DIST_DIR}/${DIST_NAME}
	touch ${DIST_DIR}/${DIST_NAME}
	cp -r src/* ${DIST_DIR}/${DIST_NAME}/

${DIST_DIR}/${DIST_NAME}.zip: ${DIST_DIR}/${DIST_NAME}
	rm -f ${DIST_DIR}/${DIST_NAME}.zip
	cd ${DIST_DIR} && zip -r ${DIST_NAME}.zip ${DIST_NAME}

clean:
	rm -rf ${DIST_DIR}
