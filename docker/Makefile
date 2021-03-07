PROJECT=kindergarten
REPOSITORY=jjgp
VARIANTS=$(patsubst %.Dockerfile,%,$(shell ls | grep ".*.Dockerfile"))

.PHONY: all base clean help push $(VARIANTS)

ifeq ($(firstword $(MAKECMDGOALS)),push)
ifeq ($(filter-out push,$(MAKECMDGOALS)),)
push: ;
else
all:
	docker push $(REPOSITORY)/$(PROJECT) --all-tags

base:
	docker push $(REPOSITORY)/$(PROJECT)

push: ;@:

$(VARIANTS):
	docker push $(REPOSITORY)/$(PROJECT):$@
endif
else 
all: $(VARIANTS)

base: Dockerfile
	docker build -t $(REPOSITORY)/$(PROJECT) - < $<

$(VARIANTS): base
	docker build -t $(REPOSITORY)/$(PROJECT):$@ - < $@.Dockerfile
endif

help:
	@echo "make all              : build all images"
	@echo "make base             : build base image"
	@echo "make [TAG]            : build image with [TAG]"
	@echo "make push all         : push all images"
	@echo "make push base        : push base image"
	@echo "make push [TAG]       : push image with [TAG]"

clean:
	docker rmi $(shell docker images -q $(REPOSITORY)/$(PROJECT))
