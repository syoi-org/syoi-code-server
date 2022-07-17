# SYOI Code Server Docker Image

This repository stores the Dockerfile and configs that required to build a
[code-server](https://github.com/coder/code-server) image to be used on
[code.syoi.org](https://code.syoi.org). Development tools such as g++ compiler
and git are bundled in the image. An SSH server is also bundled for remote
server access.

## Getting Started

### Running The Image

The container exposes port 8080 for code-server and port 22 for SSH access. The
following will run the server and expose the server at port 8080 and 8022.

```bash
docker run --restart=always -p 8080:8080 -p 8022:22 ghcr.io/syoi-org/syoi-code-server:4.4.0-1
```

### Supported Tags

The tags are in the format of `<code server version>-<build version>`. This is
similar to format of DEB package versioning convention. Build version wiil be
bumped when there are package updates (dev tools/ other dependencies). You may
also omit the build version for latest build.

Currently supported tags:

- `4.4.0-1`, `4.4.0`, `4.4`, `4`, `latest`

## Customizing The Image

### Building The Image

The Dockerfile consists of the following build arguments:

- `code_server_version`(required): The code-server version to be used

You may build the image with the following command for example:

```bash
docker build -t syoi-code-server:4.4.0-1 --build-arg code_server_version=4.4.0 .
```

### Additional Services

The service lifecycles are managed by `supervisord`. You may edit
`supervisord.conf` to add additional services as you need. However, you are
advised to run them as separated containers if possible.
