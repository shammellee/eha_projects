.PHONY: all clean dev prod $(DEV.CONFIGS) $(PROD.CONFIGS) $(DEV_DEPS) $(PROD_DEPS)

# CONFIG
SHELL        := /bin/bash

DEV.CONFIGS  := dev.config.jade
DEV.CONFIGS  += dev.config.glue
DEV.CONFIGS  += dev.config.styl
PROD.CONFIGS  = $(DEV.CONFIGS:dev.%=prod.%)
PROJECT_NAME := Costco Calculator
JQUERY       := jquery-1.11.1.min.js
JQUERY_UI    := jquery-ui-1.11.1.min.js

DEV_MODE := false
ifeq ($(firstword $(MAKECMDGOALS)),dev)
# MAKEFLAGS = -j $(words $(DEV_DEPS))
DEV_MODE := true
endif

# TEMPLATES
JADE.CONFIG_FILE_NAME   := config.jade
SPRITE.CONFIG_FILE_NAME := sprite.conf
STYLUS.CONFIG_FILE_NAME := config.styl

# COLORS
COLORS.RED     := \033[31m
COLORS.GREEN   := \033[32m
COLORS.YELLOW  := \033[33m
COLORS.BLUE    := \033[34m
COLORS.MAGENTA := \033[35m
COLORS.CYAN    := \033[36m
COLORS.NORMAL  := \033[0m

# PATHS
SRC.DIR                := src
BUILD.DIR              := build
SUPPORT.DIR            := support
SCRIPT.DIR             := $(SUPPORT.DIR)/scripts
TMP.DIR                := tmp

SRC.COFFEE_DIR         := $(SRC.DIR)/coffee
SRC.COFFEE_TEST_DIR     = $(SRC.COFFEE_DIR)/test
SRC.IMG_DIR            := $(SRC.DIR)/img
SRC.JADE_DIR           := $(SRC.DIR)/jade
SRC.JADE_INC_DIR        = $(SRC.JADE_DIR)/inc
SRC.JADE_TEST_DIR       = $(SRC.JADE_DIR)/test
SRC.JINJA_DIR          := $(SRC.DIR)/jinja
SRC.JSON_DIR           := $(SRC.DIR)/json
SRC.SPRITE_DIR          = $(SRC.IMG_DIR)/sprites
SRC.STYLUS_DIR         := $(SRC.DIR)/styl
SRC.STYLUS_INC_DIR      = $(SRC.STYLUS_DIR)/inc
SRC.STYLUS_TEST_DIR     = $(SRC.STYLUS_DIR)/test
SRC.TEMPLATE_DIR       := $(SRC.DIR)/templates
SRC.JADE_TEMPLATE_DIR   = $(SRC.TEMPLATE_DIR)/jade
SRC.SPRITE_TEMPLATE_DIR = $(SRC.TEMPLATE_DIR)/sprites
SRC.STYLUS_TEMPLATE_DIR = $(SRC.TEMPLATE_DIR)/stylus
SRC.VENDOR_DIR         := $(SRC.DIR)/vendor

BUILD.CSS_NAME         := css
BUILD.IMG_NAME         := img
BUILD.JS_NAME          := js
BUILD.VENDOR_NAME      := vendor
BUILD.CSS_DIR          := $(BUILD.DIR)/$(BUILD.CSS_NAME)
BUILD.IMG_DIR          := $(BUILD.DIR)/$(BUILD.IMG_NAME)
BUILD.JS_DIR           := $(BUILD.DIR)/$(BUILD.JS_NAME)
BUILD.DIRS              = $(BUILD.CSS_DIR)
BUILD.DIRS             += $(BUILD.IMG_DIR)
BUILD.DIRS             += $(BUILD.JS_DIR)
BUILD.DIRS             += $(TMP.DIR)

GENERATED_FILES         = $(BUILD.DIR)
GENERATED_FILES        += $(SRC.STYLUS_INC_DIR)/sprites/*.css
GENERATED_FILES        += $(SRC.STYLUS_INC_DIR)/core/config.styl
GENERATED_FILES        += $(SRC.JADE_INC_DIR)/$(JADE.CONFIG_FILE_NAME)
GENERATED_FILES        += $(SRC.SPRITE_DIR)/$(SPRITE.CONFIG_FILE_NAME)
GENERATED_FILES        += $(SRC.TEMPLATE_DIR)/**/*.sh
GENERATED_FILES        += $(TMP.DIR)

PAGE_TO_OPEN           := $(BUILD.DIR)/personal.html

# DEPENDENCIES
DEV_DEPS := dev.dirs
DEV_DEPS += dev.img
DEV_DEPS += dev.config
DEV_DEPS += dev.coffee
DEV_DEPS += dev.js
DEV_DEPS += dev.glue
DEV_DEPS += dev.jade
DEV_DEPS += dev.styl
DEV_DEPS += dev.open
PROD_DEPS = $(DEV_DEPS:dev.%=prod.%)

# COMMANDS
CLEAN.CMD            = rm $(CLEAN.FLAGS)
CLEAN.FLAGS         := -rf
                  
COFFEE.CMD           = coffee $(COFFEE.FLAGS)
COFFEE.FLAGS        := --compile
COFFEE.FLAGS        += --no-header

COPY.CMD            := cp -R $(COPY.FLAGS)
COPY.FLAGS           = 

GLUE.CMD             = glue $(GLUE.FLAGS)
GLUE.FLAGS           = --source $(SRC.SPRITE_DIR)
GLUE.FLAGS          += --css $(BUILD.CSS_DIR)
GLUE.FLAGS          += --img $(BUILD.IMG_DIR)
GLUE.FLAGS          += --project

IMG.CMD              = $(SCRIPT.DIR)/copy_images

JADE.CMD             = jade $(JADE.FLAGS)
JADE.FLAGS          := 

MKDIRS.CMD           = mkdir $(MKDIRS.FLAGS)
MKDIRS.FLAGS        := -p

OPEN.CMD             = open $(OPEN.FLAGS)
OPEN.FLAGS           = -a /Applications/Google\ Chrome.App

STYLUS.CMD           = stylus $(STYLUS.FLAGS)
STYLUS.FLAGS        := --use 'nib'
STYLUS.FLAGS        += --include-css

TEMPLATE_ENGINE.CMD  = $(SCRIPT.DIR)/template_engine "$(1)" "$(2)"

UGLIFY.CMD           = uglifyjs
UGLIFY.FLAGS        := --mangle
UGLIFY.FLAGS        += --compress

# RULES
all: prod

dev: | $(DEV_DEPS)

dev.dirs:
	$(MKDIRS.CMD) $(BUILD.DIRS)

dev.img:
	$(IMG.CMD) $(SRC.IMG_DIR) $(BUILD.IMG_DIR)

dev.config: $(DEV.CONFIGS)

dev.config.jade:
	echo "\
	DEV_MODE='$(DEV_MODE)';\
	CSS_PATH='$(BUILD.CSS_NAME)';\
	JS_PATH='$(BUILD.JS_NAME)';\
	IMG_PATH='$(BUILD.IMG_NAME)';\
	JQUERY='$(JQUERY)';\
	JQUERY_UI='$(JQUERY_UI)';\
	PROJECT_NAME='$(PROJECT_NAME)';\
	"\
	> $(SRC.JADE_TEMPLATE_DIR)/$(JADE.CONFIG_FILE_NAME:.jade=.sh)
	$(call TEMPLATE_ENGINE.CMD,$(SRC.JADE_TEMPLATE_DIR)/$(JADE.CONFIG_FILE_NAME),$(SRC.JADE_INC_DIR)/$(JADE.CONFIG_FILE_NAME))

dev.config.glue:
	echo "\
	CSS_DIR='$(SRC.STYLUS_INC_DIR)/sprites';\
	CSS_TEMPLATE='$(SRC.JINJA_DIR)/css.jinja';\
	SRC_DIR='$(SRC.IMG_DIR)/sprites';\
	IMG_DIR_NAME='$(BUILD.IMG_NAME)';\
	"\
	> $(SRC.SPRITE_TEMPLATE_DIR)/global.sh
	$(call TEMPLATE_ENGINE.CMD,$(SRC.SPRITE_TEMPLATE_DIR)/global.conf,$(SRC.SPRITE_DIR)/$(SPRITE.CONFIG_FILE_NAME))

dev.config.styl:
	echo "\
	IMG_DIR='../$(BUILD.IMG_NAME)';\
	"\
	> $(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME:.styl=.sh)
	$(call TEMPLATE_ENGINE.CMD,$(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME),$(SRC.STYLUS_INC_DIR)/core/$(STYLUS.CONFIG_FILE_NAME))

dev.coffee:
	$(COFFEE.CMD) --output $(BUILD.JS_DIR) $(SRC.COFFEE_DIR)

dev.js:
	$(COPY.CMD) $(SRC.VENDOR_DIR)/jquery/*.js $(BUILD.JS_DIR)

dev.glue:
	$(GLUE.CMD)

dev.jade:
	$(JADE.CMD) --pretty $(SRC.JADE_DIR)/*.jade --obj $(SRC.JSON_DIR)/data.json --out $(BUILD.DIR)

dev.styl:
	$(STYLUS.CMD) $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR)

dev.open:
	$(OPEN.CMD) $(PAGE_TO_OPEN)

prod: | $(PROD_DEPS)
	@echo -e '$(COLORS.GREEN)Build Complete!$(COLORS.NORMAL)'

prod.dirs:
	@$(MKDIRS.CMD) $(BUILD.DIRS)

prod.img:
	@echo -e '$(COLORS.YELLOW)Copying Images...$(COLORS.NORMAL)'
	@$(IMG.CMD) $(SRC.IMG_DIR) $(BUILD.IMG_DIR)

prod.config: $(PROD.CONFIGS)

prod.config.jade:
	@echo "\
	DEV_MODE='$(DEV_MODE)';\
	CSS_PATH='$(BUILD.CSS_NAME)';\
	JS_PATH='$(BUILD.JS_NAME)';\
	IMG_PATH='$(BUILD.IMG_NAME)';\
	JQUERY='$(JQUERY)';\
	JQUERY_UI='$(JQUERY_UI)';\
	PROJECT_NAME='$(PROJECT_NAME)';\
	"\
	> $(SRC.JADE_TEMPLATE_DIR)/$(JADE.CONFIG_FILE_NAME:.jade=.sh)
	@$(call TEMPLATE_ENGINE.CMD,$(SRC.JADE_TEMPLATE_DIR)/$(JADE.CONFIG_FILE_NAME),$(SRC.JADE_INC_DIR)/$(JADE.CONFIG_FILE_NAME))

prod.config.glue:
	@echo "\
	CSS_DIR='$(SRC.STYLUS_INC_DIR)/sprites';\
	CSS_TEMPLATE='$(SRC.JINJA_DIR)/css.jinja';\
	SRC_DIR='$(SRC.IMG_DIR)/sprites';\
	IMG_DIR_NAME='$(BUILD.IMG_NAME)';\
	"\
	> $(SRC.SPRITE_TEMPLATE_DIR)/global.sh
	@$(call TEMPLATE_ENGINE.CMD,$(SRC.SPRITE_TEMPLATE_DIR)/global.conf,$(SRC.SPRITE_DIR)/$(SPRITE.CONFIG_FILE_NAME))

prod.config.styl:
	@echo "\
	IMG_DIR='../$(BUILD.IMG_NAME)';\
	"\
	> $(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME:.styl=.sh)
	@$(call TEMPLATE_ENGINE.CMD,$(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME),$(SRC.STYLUS_INC_DIR)/core/$(STYLUS.CONFIG_FILE_NAME))

prod.coffee:
	@echo -e '$(COLORS.YELLOW)Compiling CoffeeScript...$(COLORS.NORMAL)'
	@$(COFFEE.CMD) --output $(TMP.DIR) $(SRC.COFFEE_DIR) > /dev/null

prod.js:
	@echo -e '$(COLORS.YELLOW)Compressing JavaScript...$(COLORS.NORMAL)'
	@$(UGLIFY.CMD) $(TMP.DIR)/core.js $(UGLIFY.FLAGS) --output $(TMP.DIR)/core.min.js.tmp /dev/null
	@$(UGLIFY.CMD) $(TMP.DIR)/calculator.js $(UGLIFY.FLAGS) --output $(TMP.DIR)/calculator.min.js.tmp /dev/null
	@cat $(SRC.VENDOR_DIR)/jquery/$(JQUERY) $(SRC.VENDOR_DIR)/jquery/$(JQUERY_UI) > $(BUILD.JS_DIR)/main.min.js
	@echo >> $(BUILD.JS_DIR)/main.min.js
	@cat $(TMP.DIR)/core.min.js.tmp >> $(BUILD.JS_DIR)/main.min.js
	@echo >> $(BUILD.JS_DIR)/main.min.js
	@cat $(TMP.DIR)/calculator.min.js.tmp >> $(BUILD.JS_DIR)/main.min.js

prod.glue:
	@echo -e '$(COLORS.YELLOW)Generating Sprites...$(COLORS.NORMAL)'
	@$(GLUE.CMD) > /dev/null

prod.jade:
	@echo -e '$(COLORS.YELLOW)Compiling Jade...$(COLORS.NORMAL)'
	@$(JADE.CMD) $(SRC.JADE_DIR)/*.jade --obj $(SRC.JSON_DIR)/data.json --out $(BUILD.DIR) > /dev/null

prod.styl:
	@echo -e '$(COLORS.YELLOW)Compiling Stylus...$(COLORS.NORMAL)'
	@$(STYLUS.CMD) --compress $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR) > /dev/null

prod.open:
	@$(OPEN.CMD) $(PAGE_TO_OPEN)

clean:
	@echo -e '$(COLORS.YELLOW)Cleaning Project...$(COLORS.NORMAL)'
	@$(CLEAN.CMD) $(GENERATED_FILES)
	@echo -e '$(COLORS.GREEN)Project Clean!$(COLORS.NORMAL)'
