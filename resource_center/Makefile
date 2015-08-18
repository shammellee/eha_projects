.PHONY: all clean dev prod $(DEV.CONFIGS) $(PROD.CONFIGS) $(DEV_DEPS) $(PROD_DEPS)

# CONFIG
SHELL                   := /bin/bash

DEV_MODE := false
ifeq ($(firstword $(MAKECMDGOALS)),dev)
MAKEFLAGS = -j $(words $(DEV_DEPS))
DEV_MODE := true
endif

DEV.CONFIGS             := dev.config.jade
DEV.CONFIGS             += dev.config.glue
DEV.CONFIGS             += dev.config.styl
PROD.CONFIGS             = $(DEV.CONFIGS:dev.%=prod.%)

JQUERY                  := jquery-1.11.1.min.js
JQUERY_UI               := jquery-ui-1.11.0.min.js
VIDEO_PLAYER_HEIGHT     := 480
VIDEO_PLAYER_WIDTH      := 853
AGREEMENT_HEIGHT        := 389
AGREEMENT_WIDTH         := 588

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

# DEPENDENCIES
DEV_DEPS := dev.dirs
DEV_DEPS += dev.img
DEV_DEPS += dev.config
DEV_DEPS += dev.coffee
DEV_DEPS += dev.js
DEV_DEPS += dev.glue
DEV_DEPS += dev.jade
DEV_DEPS += dev.styl
PROD_DEPS = $(DEV_DEPS:dev.%=prod.%)

# COMMANDS
CLEAN.CMD            = rm $(CLEAN.FLAGS)
CLEAN.FLAGS         := -rf
                  
COFFEE.CMD           = coffee $(COFFEE.FLAGS)
COFFEE.FLAGS        := --compile
COFFEE.FLAGS        += --no-header
COFFEE.FLAGS        += --bare

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
	VIDEO_PLAYER_HEIGHT=$(VIDEO_PLAYER_HEIGHT);\
	VIDEO_PLAYER_WIDTH=$(VIDEO_PLAYER_WIDTH);\
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
	VIDEO_PLAYER_HEIGHT=$(VIDEO_PLAYER_HEIGHT);\
	VIDEO_PLAYER_WIDTH=$(VIDEO_PLAYER_WIDTH);\
	AGREEMENT_HEIGHT=$(AGREEMENT_HEIGHT);\
	AGREEMENT_WIDTH=$(AGREEMENT_WIDTH);\
	"\
	> $(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME:.styl=.sh)
	$(call TEMPLATE_ENGINE.CMD,$(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME),$(SRC.STYLUS_INC_DIR)/core/$(STYLUS.CONFIG_FILE_NAME))

dev.coffee:
	$(COFFEE.CMD) --watch --output $(BUILD.JS_DIR) $(SRC.COFFEE_DIR)

dev.js:
	$(COPY.CMD) $(SRC.VENDOR_DIR)/jquery/*.js $(BUILD.JS_DIR)

dev.glue:
	$(GLUE.CMD) --watch

dev.jade:
	$(JADE.CMD) --pretty --watch $(SRC.JADE_DIR)/*.jade --obj $(SRC.JSON_DIR)/data.json --out $(BUILD.DIR)

dev.styl:
	$(STYLUS.CMD) --watch $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR)

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
	VIDEO_PLAYER_HEIGHT=$(VIDEO_PLAYER_HEIGHT);\
	VIDEO_PLAYER_WIDTH=$(VIDEO_PLAYER_WIDTH);\
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
	VIDEO_PLAYER_HEIGHT=$(VIDEO_PLAYER_HEIGHT);\
	VIDEO_PLAYER_WIDTH=$(VIDEO_PLAYER_WIDTH);\
	AGREEMENT_HEIGHT=$(AGREEMENT_HEIGHT);\
	AGREEMENT_WIDTH=$(AGREEMENT_WIDTH);\
	"\
	> $(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME:.styl=.sh)
	@$(call TEMPLATE_ENGINE.CMD,$(SRC.STYLUS_TEMPLATE_DIR)/$(STYLUS.CONFIG_FILE_NAME),$(SRC.STYLUS_INC_DIR)/core/$(STYLUS.CONFIG_FILE_NAME))

prod.coffee:
	@echo -e '$(COLORS.YELLOW)Compiling CoffeeScript...$(COLORS.NORMAL)'
	@$(COFFEE.CMD) --output $(TMP.DIR) $(SRC.COFFEE_DIR) > /dev/null

prod.js:
	@echo -e '$(COLORS.YELLOW)Compressing JavaScript...$(COLORS.NORMAL)'
	@$(UGLIFY.CMD) $(TMP.DIR)/internal.js $(UGLIFY.FLAGS) --output $(TMP.DIR)/internal.min.js.tmp /dev/null
	@cat $(SRC.VENDOR_DIR)/jquery/$(JQUERY) $(SRC.VENDOR_DIR)/jquery/$(JQUERY_UI) > $(BUILD.JS_DIR)/internal.min.js
	@echo >> $(BUILD.JS_DIR)/internal.min.js
	@cat $(TMP.DIR)/internal.min.js.tmp >> $(BUILD.JS_DIR)/internal.min.js

prod.glue:
	@echo -e '$(COLORS.YELLOW)Generating Sprites...$(COLORS.NORMAL)'
	@$(GLUE.CMD) > /dev/null

prod.jade:
	@echo -e '$(COLORS.YELLOW)Compiling Jade...$(COLORS.NORMAL)'
	@$(JADE.CMD) --pretty $(SRC.JADE_DIR)/*.jade --out $(BUILD.DIR) --obj $(SRC.JSON_DIR)/data.json > /dev/null

prod.styl:
	@echo -e '$(COLORS.YELLOW)Compiling Stylus...$(COLORS.NORMAL)'
	@$(STYLUS.CMD) --compress $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR) > /dev/null

clean:
	@echo -e '$(COLORS.YELLOW)Cleaning Project...$(COLORS.YELLOW)'
	@$(CLEAN.CMD) $(GENERATED_FILES)
	@echo -e '$(COLORS.GREEN)Project Clean!$(COLORS.NORMAL)'
