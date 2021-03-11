DOCKER_DIR = docker/
IMAGE_CONFIGS_PATH ?=
PROJECT ?= kindergarten
REMOTE_CONTAINERS_EXTENSION = ms-vscode-remote.remote-containers
REMOTE_CONTAINERS_STORAGE_PATH ?=
REPOSITORY ?= jjgp

ifeq ($(shell uname -s),Darwin)
REMOTE_CONTAINERS_STORAGE_PATH = ~/Library/Application\ Support/Code/User/globalStorage/ms-vscode-remote.remote-containers
IMAGE_CONFIGS_PATH := $(REMOTE_CONTAINERS_STORAGE_PATH)/imageConfigs
endif

define IMAGE_CONFIG
{
    "settings": {
        "terminal.integrated.shell.linux": "/bin/ash"
    },
    "workspaceFolder": "/workspace"
}
endef

%-image-config: export IMAGE_CONFIG := $(IMAGE_CONFIG)
%-image-config:
ifeq ($(filter $(REMOTE_CONTAINERS_EXTENSION), $(shell code --)),)
	@echo foobar
endif
ifneq ($(REMOTE_CONTAINERS_STORAGE_PATH),)
	@mkdir -p $(IMAGE_CONFIGS_PATH)
	@echo "$$IMAGE_CONFIG" > $(IMAGE_CONFIGS_PATH)/$(REPOSITORY)%2f$(PROJECT)%3a$*.json
else
	$(warning WARNING: failed to write image config. REMOTE_CONTAINERS_STORAGE_PATH not present.)
endif

%-run: force %-image-config $(DOCKER_DIR)/%.Dockerfile
	@$(MAKE) DOCKER_DIR=docker/ PROJECT=$(PROJECT) REPOSITORY=$(REPOSITORY) -f docker/Makefile $@

force: ;

kill-containers:
	docker kill $$(docker ps | grep "$(REPOSITORY)/$(PROJECT)" | awk '{ print $$1 }')

clean:
ifneq ($(IMAGE_CONFIGS_PATH),)
	@rm -rf $(IMAGE_CONFIGS_PATH)/$(REPOSITORY)%2f$(PROJECT)%3a*.json
endif

help:
	@echo "make [TAG]-image-config      : makes a devcontainer.json in the globalStorage to support attaching to containers"
	@echo "make [TAG]-run               : run image with [TAG]"
	@echo "make kill-containers         : kill running containers"
	@echo "make clean                   : remove image configs"
