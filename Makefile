# iVoz — build & packaging
#
# Standard Xcode builds use the normal Swift toolchain. Set
# USE_TOOLCHAIN_FIX=1 only on the affected developer Command Line Tools setup.

TOOLCHAIN_FIX := $(HOME)/.hikari-swiftpm-libs
ifeq ($(USE_TOOLCHAIN_FIX),1)
export SWIFTPM_CUSTOM_LIBS_DIR := $(TOOLCHAIN_FIX)
export SWIFT_EXEC := $(TOOLCHAIN_FIX)/swiftc
BUILD_DEPS := toolchain-fix
ICON_SWIFT_FLAGS := -vfsoverlay $(TOOLCHAIN_FIX)/mask.yaml
endif

APP_NAME := HikariYaps
BUNDLE   := dist/iVoz.app
CONTENTS := $(BUNDLE)/Contents
BINARY   := .build/release/$(APP_NAME)

.PHONY: all build app run install icon clean toolchain-fix

all: app

toolchain-fix:
	@test -x $(TOOLCHAIN_FIX)/swiftc || ./Packaging/setup-toolchain-fix.sh

build: $(BUILD_DEPS)
	swift build -c release

app: build icon
	rm -rf $(BUNDLE)
	mkdir -p $(CONTENTS)/MacOS $(CONTENTS)/Resources $(CONTENTS)/Frameworks
	cp $(BINARY) $(CONTENTS)/MacOS/$(APP_NAME)
	cp Packaging/Info.plist $(CONTENTS)/Info.plist
	printf 'APPL????' > $(CONTENTS)/PkgInfo
	cp dist/AppIcon.icns $(CONTENTS)/Resources/AppIcon.icns
	@if [ -d .build/release/$(APP_NAME)_$(APP_NAME).bundle ]; then \
		cp -R .build/release/$(APP_NAME)_$(APP_NAME).bundle $(CONTENTS)/Resources/; \
	fi
	@# llama.framework backs local LLM (Smart Cleanup) inference — WhisperKit
	@# needs no such step since Core ML models are downloaded at runtime, not
	@# linked as a framework.
	ditto .build/release/llama.framework $(CONTENTS)/Frameworks/llama.framework
	install_name_tool -add_rpath @executable_path/../Frameworks $(CONTENTS)/MacOS/$(APP_NAME)
	codesign --force --deep --sign - $(BUNDLE)
	@echo "✓ Built $(BUNDLE)"

icon: dist/AppIcon.icns

dist/AppIcon.icns: Packaging/make-icon.swift $(BUILD_DEPS)
	mkdir -p dist
	rm -rf dist/AppIcon.iconset
	swift $(ICON_SWIFT_FLAGS) Packaging/make-icon.swift dist/AppIcon.iconset
	iconutil -c icns dist/AppIcon.iconset -o dist/AppIcon.icns

run: app
	open $(BUNDLE)

install: app
	mkdir -p /Applications/iSuite
	rm -rf "/Applications/iSuite/iVoz.app"
	ditto $(BUNDLE) "/Applications/iSuite/iVoz.app"
	@echo "✓ Installed to /Applications/iSuite/iVoz.app"

clean:
	rm -rf .build dist
