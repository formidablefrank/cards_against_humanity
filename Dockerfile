FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RUBY_VERSION=3.3.2
ENV BUNDLE_PATH=/usr/local/bundle \
    NODE_ENV=development \
    RAILS_ENV=development

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libgmp-dev \
    libdb-dev \
    libpq-dev \
    pkg-config \
    tzdata

RUN git clone https://github.com/rbenv/ruby-build.git /tmp/ruby-build \
    && /tmp/ruby-build/bin/ruby-build ${RUBY_VERSION} /usr/local \
    && rm -rf /tmp/ruby-build

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .
RUN gem install bundler && bundle install && yarn install

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]