PROJECT=kindergarten
REPOSITORY=jjgp
VARIANTS=$(patsubst %.Dockerfile,%,$(shell ls | grep ".*.Dockerfile"))
IMAGE_TARGETS=$(addsuffix -image,$(VARIANTS))
PUSH_TARGETS=$(addsuffix -push,$(VARIANTS))

.PHONY: all $(IMAGE_TARGETS) clean help $(PUSH_TARGETS)

all: $(PUSH_TARGETS)

all-images: $(IMAGE_TARGETS)

eksctl-image: | kfctl-image
kind-image: | kfctl-image
$(IMAGE_TARGETS): %-image: %.Dockerfile
	@docker build -t $(REPOSITORY)/$(PROJECT):$* - < $*.Dockerfile

$(PUSH_TARGETS): %-push: %.Dockerfile | %-image
	@docker push $(REPOSITORY)/$(PROJECT):$*

help:
	@echo "make all              : build and push all images"
	@echo "make all-images       : build all images"
	@echo "make [TAG]-image      : build image with [TAG]"
	@echo "make [TAG]-push       : push image with [TAG]"
	@echo "make clean            : clean all images"

clean:
	docker rmi $(shell docker images -q $(REPOSITORY)/$(PROJECT))
