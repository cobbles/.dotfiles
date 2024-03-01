FROM ubuntu:22.04 AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y software-properties-common && \
  apt-add-repository -y ppa:ansible/ansible && \
  apt-get update && \
  apt-get install -y sudo ansible && \
  apt-get clean autoclean && \
  apt-get autoremove --yes

FROM base AS tom
ARG TAGS
RUN addgroup --gid 1000 tom
RUN adduser --gecos tom --uid 1000 --gid 1000 --disabled-password tom
RUN echo 'tom ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER tom
ENV USER=tom

FROM tom
WORKDIR /home/tom/.dotfiles
COPY --chown=tom . .
CMD ["sh", "-c", "./ubuntu"]
