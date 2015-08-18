.PHONY: all clean $(DEV_DEPS) $(PROD_DEPS) test

# CONFIG
SHELL    := /bin/bash
MAKEFLAGS = -j $(words $(DEV_DEPS)) # limit parallel recipe execution

# COLORS
COLORS.RED     := \033[31m
COLORS.GREEN   := \033[32m
COLORS.YELLOW  := \033[33m
COLORS.BLUE    := \033[34m
COLORS.MAGENTA := \033[35m
COLORS.CYAN    := \033[36m
COLORS.NORMAL  := \033[0m

# PATHS
SRC.DIR         := src
BUILD.DIR       := build
SUPPORT.DIR     := support
SCRIPT.DIR      := $(SUPPORT.DIR)/scripts

SRC.IMG_DIR     := $(SRC.DIR)/img
SRC.JADE_DIR    := $(SRC.DIR)/jade
SRC.JADE_INC_DIR = $(SRC.JADE_DIR)/inc
SRC.JSON_DIR    := $(SRC.DIR)/json

BUILD.IMG_NAME  := images
BUILD.DIRS      += $(BUILD.DIR)

JSON_FILES      := $(shell $(SCRIPT.DIR)/get_files $(SRC.JSON_DIR) "json")

# DEPENDENCIES
DEV_DEPS := dev.dirs dev.imgs dev.jade
PROD_DEPS = $(DEV_DEPS:dev.%=prod.%)

# COMMANDS
CLEAN.CMD       = rm $(CLEAN.FLAGS)
CLEAN.FLAGS    := -rf

IMG_ENGINE.CMD  = for i in $(JSON_FILES);do _targetName="$${i\#\#*/}";_targetName="$${_targetName%.json}";$(SCRIPT.DIR)/img_engine "$$_targetName" "$(BUILD.IMG_NAME)" "$(SRC.IMG_DIR)" "$(BUILD.DIR)";done

JADE.FLAGS     := --pretty
JADE.FLAGS     += --path src/jade/inc
JADE.TEMPLATE  := $(SRC.JADE_DIR)/index.jade

JADE_ENGINE.CMD = for j in $(JSON_FILES);do $(SCRIPT.DIR)/jade_engine "$(1)" "$$j" "$(BUILD.DIR)" "$(JADE.FLAGS)";done

MKDIRS.CMD      = mkdir $(MKDIRS.FLAGS)
MKDIRS.FLAGS   := -p

# TARGETS
all: prod

dev: | $(DEV_DEPS)

dev.dirs:
	$(MKDIRS.CMD) $(BUILD.DIRS)

dev.imgs: dev.dirs
	watch -n 3 '$(IMG_ENGINE.CMD)'

dev.jade: $(JADE.TEMPLATE) dev.dirs
	watch -n 3 '$(call JADE_ENGINE.CMD,$<)'

prod: | $(PROD_DEPS)
	@echo -e '$(COLORS.GREEN)Build Complete!$(COLORS.NORMAL)'

prod.dirs:
	@$(MKDIRS.CMD) $(BUILD.DIRS)

prod.imgs: prod.dirs
	@echo -e '$(COLORS.YELLOW)Copying images...$(COLORS.NORMAL)'
	@$(IMG_ENGINE.CMD)

prod.jade: $(JADE.TEMPLATE) prod.dirs
	@echo -e '$(COLORS.YELLOW)Compiling Jade...$(COLORS.NORMAL)'
	@$(call JADE_ENGINE.CMD,$<)

clean:
	@echo -e '$(COLORS.YELLOW)Cleaning Project...$(COLORS.NORMAL)'
	@$(CLEAN.CMD) $(BUILD.DIR)
	@echo -e '$(COLORS.GREEN)Project Clean!$(COLORS.NORMAL)'
