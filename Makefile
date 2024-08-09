REGION ?= us-east-1
PROFILE ?= ryan
NAME ?= bootstrap-web-server
BUILD_ID ?= latest
REGISTRY_ID ?= q6m5k1h0

ACCOUNT_ID := $(shell aws sts get-caller-identity --profile $(PROFILE) --query 'Account' --output text)

.PHONY: build-image
build-image:
	@aws ecr-public get-login-password --region $(REGION) --profile $(PROFILE) | docker login --username AWS --password-stdin public.ecr.aws
	@aws ecr get-login-password --region $(REGION) --profile $(PROFILE)  | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com
	@docker build --tag $(NAME):$(BUILD_ID) .
	@docker tag $(NAME):$(BUILD_ID) public.ecr.aws/$(REGISTRY_ID)/$(NAME):$(BUILD_ID)
	@docker push public.ecr.aws/$(REGISTRY_ID)/$(NAME):$(BUILD_ID)
