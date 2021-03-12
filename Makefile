CODE_EXTENSIONS = ms-vscode-remote.remote-containers
DOCKER_DIR = docker/

ifeq ($(shell uname -s),Darwin)
IMAGE_CONFIGS_PATH = ~/Library/Application\ Support/Code/User/globalStorage/ms-vscode-remote.remote-containers/imageConfigs
endif

.PHONY: help pre-commit-install

check-code-extensions: CODE_INSTALLED_EXTENSIONS := $(shell code --list-extensions)
check-code-extensions: force
	$(foreach extension,$(CODE_EXTENSIONS), \
		$(if $(filter $(extension),$(CODE_INSTALLED_EXTENSIONS)),, \
			$(warning WARNING: Install code extension $(extension)) \
		) \
	)

check-code-path: force
ifeq ($(shell which code),)
	$(warning WARNING: Install 'code' command in path)
endif

check-image-configs-path: force
ifndef IMAGE_CONFIGS_PATH
	$(error ERROR: IMAGE_CONFIGS_PATH must be set)
endif

doctor: check-code-path check-code-extensions check-image-configs-path

force: ;@:

define IMAGE_CONFIG
{
    "settings": {
        "terminal.integrated.shell.linux": "/bin/ash"
    },
    "workspaceFolder": "/workspace"
}
endef

%-image-config: export IMAGE_CONFIG := $(IMAGE_CONFIG)
%-image-config: check-image-configs-path
	@echo "$$IMAGE_CONFIG" > $(IMAGE_CONFIGS_PATH)/$(REPOSITORY)%2f$(PROJECT)%3a$*.json

install-code-extensions: force
	@$(foreach extension,$(CODE_EXTENSIONS),code --install-extension $(extension) --force;)

%-run: %-image-config $(DOCKER_DIR)/%.Dockerfile
	@$(MAKE) DOCKER_DIR=docker/ -f docker/Makefile $@

kill-containers:
	@docker kill $$(docker ps | grep "$(REPOSITORY)/$(PROJECT)" | awk '{ print $$1 }')


define PRE_COMMIT_HOOK
{
    "settings": {
        "terminal.integrated.shell.linux": "/bin/ash"
    },
    "workspaceFolder": "/workspace"
}
endef

pre-commit-install:
	@echo foobar

help:
	@echo "make doctor                       : checks for project dependencies"
	@echo "make install-code-extensions      : install missing code extensions"
	@echo "make kill-containers              : kill running containers"
	@echo "make pre-commit-install           : installs pre-commit git hook"
	@echo "make [TAG]-image-config           : makes a devcontainer.json in the globalStorage to support attaching to containers"
	@echo "make [TAG]-run                    : run image with [TAG]"
	@echo "make clean                        : remove image configs"

clean: check-image-configs-path
	rm -rf $(IMAGE_CONFIGS_PATH)/$(REPOSITORY)%2f$(PROJECT)%3a*.json
