FROM nimlang/nim:1.6.12-ubuntu

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y \
  bash \
  ca-certificates \
  dnsutils \
  git \
  libpq-dev \
  libssl-dev \
  locales \
  make \
  vim \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Tool to propagate singals from the container to the app
RUN wget https://github.com/krallin/tini/releases/download/v0.19.0/tini
RUN chmod +x /tini

COPY . .

RUN make deps
RUN make build

EXPOSE 50123

ENTRYPOINT ["/tini", "--"]

CMD ["./torrentinim"]