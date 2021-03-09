DOCKER_DIR?=docker

%-run: force
	@$(MAKE) -f docker/Makefile $@

force: ;

help:
	@echo "make [TAG]-run        : run image with [TAG]"