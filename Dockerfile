FROM phusion/passenger-ruby23

# set some rails env vars
ENV RAILS_ENV production
ENV BUNDLE_PATH /bundle

# set the app directory var
ENV APP_HOME /home/app

WORKDIR $APP_HOME

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq

# Install apt dependencies
RUN apt-get install -y --no-install-recommends \
  build-essential \
  curl libssl-dev \
  git \
  unzip \
  zlib1g-dev \
  libxslt-dev \
  mysql-client \
  sqlite3 \
  tzdata \
  yarn

# install bundler

RUN gem install bundler

# Separate task from `add . .` as it will be
# Skipped if gemfile.lock hasn't changed *

COPY Gemfile* ./

# Install gems to /bundle
RUN bundle install

ADD . .

# compile assets!
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["/sbin/my_init"]
