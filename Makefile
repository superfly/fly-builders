PACK_FLAGS?=--no-pull
PACK_CMD?=pack

build-deploy: build-bionic deploy-bionic

build-bionic: build-stack-bionic build-buildpacks-bionic build-builder-bionic

build-stack-bionic:
	@echo "> Building 'bionic' stack..."
	bash stacks/build-stack.sh stacks/bionic

build-builder-bionic:
	@echo "> Building 'bionic' builder..."
	$(PACK_CMD) create-builder flyio/builder --builder-config builders/bionic/builder.toml $(PACK_FLAGS)

build-buildpacks-bionic:
	@echo "> Creating 'deno-cnb' buildpack package"
	$(PACK_CMD) package-buildpack flyio/deno-cnb --package-config packages/deno-cnb/package.toml $(PACK_FLAGS)

deploy-bionic: deploy-bionic-stacks deploy-packages deploy-builders

deploy-bionic-stacks:
	@echo "> Deploying 'bionic' stack..."
	docker push flyio/buildpack-stack-base:bionic
	docker push flyio/buildpack-stack-run:bionic
	docker push flyio/buildpack-stack-build:bionic

deploy-packages:
	@echo "> Deploying packages..."
	docker push flyio/deno-cnb

deploy-builders:
	@echo "> Deploying 'bionic' builder..."
	docker push flyio/builder

clean-bionic:
	@echo "> Removing 'bionic' stack..."
	docker rmi flyio/buildpack-stack-base:bionic || true
	docker rmi flyio/buildpack-stack-run:bionic || true
	docker rmi flyio/buildpack-stack-build:bionic || true

	@echo "> Removing builders..."
	docker rmi flyio/builder || true

	@echo "> Removing packages..."
	docker rmi flyio/deno-cnb || true
