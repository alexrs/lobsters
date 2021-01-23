FROM ruby:2.7-alpine

# Use a directory called /app in which to store
# this application's files. (The directory name
# is arbitrary and could have been anything.)
WORKDIR /app

# Install needed runtime dependencies.
RUN set -xe; \
    apk add --no-cache --update --virtual .runtime-deps \
        mariadb-connector-c \
        bash \
        nodejs \
        npm \
        sqlite-libs \
        tzdata;

RUN set -xe; \
    apk add --no-cache --virtual .build-deps \
        build-base \
        curl \
        gcc \
        git \
        gnupg \
        linux-headers \
        mariadb-connector-c-dev \
        mariadb-dev \
        sqlite-dev;

# Copy all the application's files into the /app
# directory.
COPY . /app

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Run bundle install to install the Ruby dependencies.
RUN bundle install

# Expose HTTP port.
EXPOSE 3000

# Set "rails server -b 0.0.0.0" as the command to
# run when this container starts.
# ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]