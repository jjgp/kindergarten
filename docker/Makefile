DOCKER_DIR? =
PROJECT = kindergarten
REPOSITORY = jjgp
VARIANTS = $(patsubst %.Dockerfile,%,$(notdir $(shell find . -type f -name *.Dockerfile)))
IMAGE_TARGETS = $(addsuffix -image,$(VARIANTS))
PUSH_TARGETS = $(addsuffix -push,$(VARIANTS))
RUN_TARGETS = $(addsuffix -run,$(VARIANTS))

.PHONY: all $(IMAGE_TARGETS) clean help $(PUSH_TARGETS) $(RUN_TARGETS)

all: $(PUSH_TARGETS)

all-images: $(IMAGE_TARGETS)

eksctl-image: | kfctl-image

kind-image: | kfctl-image

$(IMAGE_TARGETS): %-image:
	@docker build -t $(REPOSITORY)/$(PROJECT):$* - < $(DOCKER_DIR)/$*.Dockerfile

$(PUSH_TARGETS): %-push: | %-image
	@docker push $(REPOSITORY)/$(PROJECT):$*

kind-run: DOCKER_RUN_OPTIONS := --network=host \
	-v /var/run/docker.sock:/var/run/docker.sock

$(RUN_TARGETS): %-run | %-image:
	@docker run -d \
		-v "$(CURDIR)":/workspace:cached \
		$(DOCKER_RUN_OPTIONS) \
		$(REPOSITORY)/$(PROJECT):$* \
		/bin/sh -c "while sleep 1000; do :; done"

help:
	@echo "make all              : build and push all images"
	@echo "make all-images       : build all images"
	@echo "make [TAG]-image      : build image with [TAG]"
	@echo "make [TAG]-push       : push image with [TAG]"
	@echo "make [TAG]-run        : run image with [TAG]"
	@echo "make clean            : clean all images"

clean:
	docker rmi $(shell docker images -q $(REPOSITORY)/$(PROJECT))
