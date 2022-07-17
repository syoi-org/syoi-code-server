# based on Ubuntu 22.04 LTS
FROM ubuntu:jammy

# build arguments
ARG code_server_version

# install apt packages
RUN apt-get update && apt-get install -y \
  curl \
  git \
  g++ \
  cmake \
  openssh-server \
  supervisor \
  && rm -rf /var/lib/apt/lists/*

# install code-server
RUN curl -LOf https://github.com/coder/code-server/releases/download/v${code_server_version}/code-server_${code_server_version}_amd64.deb \
  && dpkg -i code-server_${code_server_version}_amd64.deb \
  && rm code-server_${code_server_version}_amd64.deb

# add default user
# uid=1000, gid=1000
ENV SERVER_USER=coder
RUN groupadd -g 1000 ${SERVER_USER} && useradd -u 1000 -g 1000 -m ${SERVER_USER} -s /usr/bin/bash

# configure supervisord
ADD supervisord.conf /etc/supervisor/supervisord.conf

# configure sshd
RUN mkdir -p /run/sshd

# add entrypoint script
ADD entrypoint.sh /
CMD [ "/entrypoint.sh" ]

EXPOSE 22 8080
