# Fly Buildpacks

## How to build flyio/builder

### Start here:

To get up and running, [install `pack`](https://buildpacks.io/docs/install-pack/) and run `make build-linux` or `make build-windows`, depending on your choice of target OS.
Follow the `README.md` docs at the root directory of each component to choose your next step. We recommend starting to play with building [apps](./apps).

We'll need that later

### The Stack

We need a base stack with curl and unzip.

cd stacks
./build-stack.sh bionic

(prefixes are already hard coded in)
(If there's an error regarding a lack of realpath, brew install coreutils)

STACK BUILT!

```
Stack ID: io.fly.stacks.bionic
Images:
    flyio/buildpack-stack-base:bionic
    flyio/buildpack-stack-build:bionic
    flyio/buildpack-stack-run:bionic
```

### Push the images to public

```
docker push flyio/buildpack-stack-base:bionic
docker push flyio/buildpack-stack-run:bionic
docker push flyio/buildpack-stack-base:bionic
```

### Package the buildpacks

At the repo root, run

```
pack package-buildpack flyio/deno-cnb --package-config packages/deno-cnb/package.toml --publish
```

This is now ready to be merged with the stack to make a builder

### Creating the Builder

```
cd builders/bionic
pack create-builder flyio/builder --builder-config builders/bionic/builder.toml --publish
```

--publish is used to make the image public

### Test Builder

cd apps/deno
pack build test-deno-app --builder flyio/builder
docker run -it -p 8080:8080 test-deno-app

### Run with fly

flyctl apps create --builder flyio/builder

# Quick Reference
- [Create a Buildpack Tutorial](https://buildpacks.io/docs/buildpack-author-guide/create-buildpack/) &rarr; Tutorial to get you started on your first Cloud Native Buildpack
- [Buildpacks.io](https://buildpacks.io/) &rarr; Cloud Native Buildpack website
- [Pack – Buildpack CLI](https://github.com/buildpacks/pack) &rarr; CLI used to consume the builder, along with source code, and construct an OCI image
- [CNB Tutorial](https://buildpacks.io/docs/app-journey/) &rarr; Tutorial to get you started using `pack`, a `builder`, and your application to create a working OCI image
- [Buildpack & Platform Specification](https://github.com/buildpacks/spec) &rarr; Detailed definition of the interaction between a platform, a lifecycle, Cloud Native Buildpacks, and an application

# Development

### Prerequisites

- [Docker](https://hub.docker.com/search/?type=edition&offering=community)
- [Pack](https://buildpacks.io/docs/install-pack/)
- [Make](https://www.gnu.org/software/make/)

This repo was based on the buildpacks.io samples repo.



