
APP=Orrery
#
APP_TARGET=Orrery
#
TESTS_TARGET=OrreryTests
#
PRODUCT=Orrery
#
TAGLINE="A simple solar system simulation for macOS"
#
###############################################################################

TOP := $(dir $(lastword $(MAKEFILE_LIST)))
CLEAR=\x1b[0m
GREEN=\x1b[32;01m
RED=\x1b[31;01m
YELLOW=\x1b[33;01m
BLUE=\x1b[34;01m
CYAN=\x1b[36;01m
BOLD=\033[1m
NORMAL=\033[0m

###############################################################################

all:
	@echo
	@echo "  $(BOLD)$(PRODUCT)$(NORMAL) - build tool"
	@echo
	@echo "       $(CYAN)$(TAGLINE)$(CLEAR)"
	@echo
	@echo "    $(BOLD)make$(NORMAL) - show this help message"
	@echo "       aliases: make help"
	@echo "    $(BOLD)make run$(NORMAL) - build and run a debug build of $(APP)"
	@echo "    $(BOLD)make build$(NORMAL) - build a debug build of $(APP)"
	@echo "       aliases: make debug"
	@echo "    $(BOLD)make release$(NORMAL) - build a release build of $(APP)"
	@echo "    $(BOLD)make test$(NORMAL) - run $(APP) unit tests"
	@echo "       aliases: make tests, make t"
	@echo "    $(BOLD)make install$(NORMAL) - install a release build of the $(APP) binary to $(TOP)bin/$(APP)"
	@echo "    $(BOLD)make clean$(NORMAL) - remove all build artifacts and executables"
	@echo

help: all

install: release
	mkdir -p $(TOP)bin
	cp $(TOP)build/Release/$(APP) $(TOP)bin/$(APP) ||:

release:
	xcodebuild -target $(APP_TARGET) -configuration Release

debug:
	xcodebuild -target $(APP_TARGET) -configuration Debug

build: debug

run: debug
	open $(TOP)build/Debug/$(APP).app

test:
	xcodebuild -target $(TESTS_TARGET) -configuration Debug
	$(TOP)build/Debug/$(TESTS_TARGET)

.PHONY: tests
tests: test
t: test

clean:
	rm -rf $(TOP)build/Release
	rm -rf $(TOP)build/Debug
	rm -rf $(TOP)build/$(APP).build
	rm -f $(TOP)bin/$(APP)
