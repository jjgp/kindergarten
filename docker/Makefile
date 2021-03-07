REPOSITORY=jjgp/kindergarten

.PHONY: all clean

all: kube eksctl kind

% :: %.Dockerfile
	docker build -t $(REPOSITORY):$(basename $(notdir $@)) - < $<

clean:
	docker rmi $(shell docker images -q $(REPOSITORY))
