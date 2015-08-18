.PHONY: all clean $(DEV_DEPS) $(PROD_DEPS) test

# CONFIG
SHELL := /bin/bash

ifeq ($(firstword $(MAKECMDGOALS)),dev)
MAKEFLAGS = -j $(words $(DEV_DEPS))
endif

# Updating `JQUERY.VERSION` or `JQUERY_UI.VERSION` after running `$ make dev` requires exiting and re-running `$ make dev`. This makes sure all files that reference `JQUERY.VERSION` and/or `JQUERY_UI.VERSION` are using the correct versions of jquery and jquery ui
# example:
# `$ make dev` (running make dev)
# `JQUERY.VERSION := <newValue>` (changing JQUERY.VERSION)
# `JQUERY_UI.VERSION := <newValue>` (changing JQUERY_UI.VERSION)
# `$ Ctrl+C` (exiting make dev)
# `$ make dev` (running make dev again)
JQUERY.VERSION    := 1.11.1
JQUERY_UI.VERSION := 1.11.0

# PATHS
SRC.DIR            := src
BUILD.DIR          := build
SUPPORT.DIR        := support
TEST.DIR           := test
TMP.DIR            := .maketmp

SRC.COFFEE_DIR      = $(SRC.DIR)/coffee
SRC.COFFEE_TEST_DIR = $(SRC.COFFEE_DIR)/test
SRC.IMG_DIR         = $(SRC.DIR)/img
SRC.JADE_DIR        = $(SRC.DIR)/jade
SRC.JADE_INC_DIR    = $(SRC.JADE_DIR)/inc
SRC.JADE_TEST_DIR   = $(SRC.JADE_DIR)/test
SRC.JINJA_DIR       = $(SRC.DIR)/jinja
SRC.STYLUS_DIR      = $(SRC.DIR)/styl
SRC.STYLUS_INC_DIR  = $(SRC.STYLUS_DIR)/inc
SRC.STYLUS_TEST_DIR = $(SRC.STYLUS_DIR)/test
SRC.VENDOR_DIR      = $(SRC.DIR)/vendor
JQUERY.PROD_FILES   = $(SRC.VENDOR_DIR)/jquery/jquery-$(JQUERY.VERSION).min.js
JQUERY.PROD_FILES  += $(SRC.VENDOR_DIR)/jquery/jquery-ui-$(JQUERY_UI.VERSION).min.js

BUILD.CSS_NAME     := css
BUILD.IMG_NAME     := img
BUILD.JS_NAME      := js
BUILD.CSS_DIR       = $(BUILD.DIR)/$(BUILD.CSS_NAME)
BUILD.IMG_DIR       = $(BUILD.DIR)/$(BUILD.IMG_NAME)
BUILD.JS_DIR        = $(BUILD.DIR)/$(BUILD.JS_NAME)
BUILD.DIRS         := $(BUILD.DIR)/$(BUILD.CSS_NAME)
BUILD.DIRS         += $(BUILD.DIR)/$(BUILD.IMG_NAME)
BUILD.DIRS         += $(BUILD.DIR)/$(BUILD.JS_NAME)

SUPPORT.SCRIPT_DIR  = $(SUPPORT.DIR)/scripts

# DEPENDENCIES
DEV_DEPS := dev.dirs dev.coffee dev.js dev.glue dev.img dev.jade dev.styl
PROD_DEPS = $(DEV_DEPS:dev.%=prod.%)

# COMMANDS
CLEAN.CMD        = rm $(CLEAN.FLAGS)
CLEAN.FLAGS     := -rf

COFFEE.CMD       = coffee $(COFFEE.FLAGS)
COFFEE.FLAGS    := --compile
COFFEE.FLAGS    += --no-header

GLUE.CMD         = glue $(GLUE.FLAGS)
GLUE.FLAGS      := --algorithm vertical
GLUE.FLAGS      += --cachebuster
GLUE.FLAGS      += --crop
GLUE.FLAGS      += --css $(SRC.STYLUS_DIR)/inc/sprites
GLUE.FLAGS      += --css-template $(SRC.JINJA_DIR)/css.jinja
GLUE.FLAGS      += --follow-links
GLUE.FLAGS      += --img $(BUILD.IMG_DIR)
GLUE.FLAGS      += --margin '0 0 10 0'
GLUE.FLAGS      += --namespace=
GLUE.FLAGS      += --ordering maxside
GLUE.FLAGS      += --padding 4
GLUE.FLAGS      += --project
GLUE.FLAGS      += --pseudo-class-separator __
GLUE.FLAGS      += --separator camelcase
GLUE.FLAGS      += --source $(SRC.IMG_DIR)/sprites
GLUE.FLAGS      += --sprite-namespace=
GLUE.FLAGS      += --url=../img/

IMG.CMD          = $(SUPPORT.SCRIPT_DIR)/copy_images $(IMG.FLAGS)
IMG.FLAGS       :=

JADE.CMD         = jade $(JADE.FLAGS)
JADE.FLAGS      := --pretty
JADE.DEV_OBJ    := '{jqueryVersion:"$(JQUERY.VERSION)",jqueryUIVersion:"$(JQUERY_UI.VERSION)",devMode:true}'

JQUERY.CMD       = $(SUPPORT.SCRIPT_DIR)/copy_jquery $(JQUERY.FLAGS)
JQUERY.FLAGS    := $(JQUERY.VERSION) $(JQUERY_UI.VERSION)

MKDIRS.CMD       = mkdir $(MKDIRS.FLAGS)
MKDIRS.FLAGS    := -p

MOCHA.CMD        = mocha $(MOCHA.FLAGS)
MOCHA.FLAGS     := --compilers coffee:coffee-script/register
MOCHA.FLAGS     += --require chai
MOCHA.FLAGS     += --ui $(MOCHA.INTERFACE)
MOCHA.FLAGS     += --reporter $(MOCHA.REPORTER)
MOCHA.INTERFACE := bdd
MOCHA.REPORTER  := min

OPEN_PAGE.CMD    = __openPath="$(shell which open)"; if [[ -f $$__openPath && -x $$__openPath && -f $(BUILD.DIR)/$(1) ]]; then open $(BUILD.DIR)/$(1); fi

STYLUS.CMD       = stylus $(STYLUS.FLAGS)
STYLUS.FLAGS    := --use 'nib'
STYLUS.FLAGS    += --include-css

UGLIFY.CMD       = uglifyjs
UGLIFY.FLAGS    := --mangle
UGLIFY.FLAGS    += --compress

all: prod

dev: | $(DEV_DEPS) open_page_dev

dev.dirs:
	$(MKDIRS.CMD) $(BUILD.DIRS) $(TMP.DIR)

dev.coffee:
	$(COFFEE.CMD) --watch --output $(BUILD.JS_DIR) $(SRC.COFFEE_DIR)

dev.js:
	$(JQUERY.CMD)

dev.glue:
	$(GLUE.CMD) --watch

dev.img:
	$(IMG.CMD)

dev.jade:
	$(JADE.CMD) --watch $(SRC.JADE_DIR)/*.jade -O $(JADE.DEV_OBJ) --out $(BUILD.DIR)

dev.styl:
	$(STYLUS.CMD) --watch $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR)

open_page_dev:
	sleep 3; open $(BUILD.DIR)/50k.html $(BUILD.DIR)/75k.html

prod: | $(PROD_DEPS) open_page_prod
	@$(CLEAN.CMD) $(TMP.DIR)
	@echo -e '\033[32mBuild Complete!\033[0m'

prod.dirs:
	@$(MKDIRS.CMD) $(BUILD.DIRS) $(TMP.DIR)

prod.coffee:
	@echo -e '\033[33mCompiling CoffeeScript...\033[0m'
	@$(COFFEE.CMD) --output $(TMP.DIR) $(SRC.COFFEE_DIR)/main.coffee > /dev/null

prod.js:
	@echo -e '\033[33mCompressing JavaScript...\033[0m'
	@$(UGLIFY.CMD) $(TMP.DIR)/main.js $(UGLIFY.FLAGS) --output $(TMP.DIR)/main.min.js.tmp > /dev/null
	@cat $(JQUERY.PROD_FILES) > $(TMP.DIR)/main.min.js
	@echo >> $(TMP.DIR)/main.min.js
	@cat $(TMP.DIR)/main.min.js $(TMP.DIR)/main.min.js.tmp > $(BUILD.JS_DIR)/main.min.js

prod.glue:
	@echo -e '\033[33mCreating Sprites...\033[0m'
	@$(GLUE.CMD) > /dev/null

prod.img:
	@echo -e '\033[33mCollecting Images...\033[0m'
	@$(IMG.CMD)

prod.jade:
	@echo -e '\033[33mCompiling Jade...\033[0m'
	@$(JADE.CMD) $(SRC.JADE_DIR)/*.jade --out $(BUILD.DIR) > /dev/null

prod.styl:
	@echo -e '\033[33mCompiling Stylus...\033[0m'
	@$(STYLUS.CMD) --compress $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR) > /dev/null

open_page_prod:
	@open $(BUILD.DIR)/50k.html $(BUILD.DIR)/75k.html

#test:
#	$(MOCHA.CMD) -w $(TEST.DIR)

clean:
	@echo -e '\033[33mCleaning Project...\033[0m'
	@$(CLEAN.CMD)\
		$(BUILD.DIR)\
		$(TMP.DIR)\
		$(SRC.STYLUS_DIR)/inc/sprites/*.css
	@echo -e '\033[32mProject Clean!\033[0m'
