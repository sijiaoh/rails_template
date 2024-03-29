ARG NODE_VERSION
ARG RUBY_VERSION

FROM node:${NODE_VERSION} as node

FROM ruby:${RUBY_VERSION}

COPY --from=node /opt/yarn-v* /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -fs /opt/yarn/bin/yarn /usr/local/bin/yarn

RUN apt update -qq

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
  && apt update -qq \
  && apt install -y -qq google-chrome-stable

RUN apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app/

COPY package.json yarn.lock /app/
RUN yarn install --frozen-lockfile

COPY Gemfile* /app/
RUN bundle config set --local without development \
  && bundle install --jobs=4 \
  && bundle clean --force

COPY . /app/
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["./bin/test"]
