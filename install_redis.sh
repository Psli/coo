#!/bin/sh
# Set up the environment. Respect $VERSION if it's set.
    set -e
    REDIS_ROOT="/opt/redis"
    REDIS_ROOT_BIN="/opt/redis/bin/redis-server"
    REDIS_BIN="/usr/bin/redis-server"
    REDIS_CONF_ROOT="/etc/redis"
    REDIS_DATA_ROOT="/data/redis/"
    [[ -z "$VERSION" ]] && VERSION=2.2.8

    echo "Setup Redis $VERSION"

# Create the Redis directory structure if it doesn't already exist.
    mkdir -p "$REDIS_ROOT/versions" "$REDIS_ROOT/bin" "$REDIS_CONF_ROOT" "$REDIS_DATA_ROOT"

# If the requested version of Redis is already installed, remove it first.

    cd "$REDIS_ROOT/versions"
    rm -rf "$REDIS_ROOT/versions/$VERSION"
# Download the requested version of Redis and unpack it.
    curl -s http://redis.googlecode.com/files/redis-$VERSION.tar.gz | tar xzf -
    mv "redis-$VERSION" "$VERSION"
    cd "$REDIS_ROOT/versions/$VERSION"
    make
    rm -f "$REDIS_ROOT_BIN"
    ln -s "$REDIS_ROOT/versions/$VERSION/src/redis-server" "$REDIS_ROOT_BIN"
    rm -f "$REDIS_BIN"
    ln -s "$REDIS_ROOT_BIN" "$REDIS_BIN"

    curl -L https://raw.github.com/Psli/coo/master/redis.conf > "$REDIS_CONF_ROOT/redis.conf"
    curl -L https://raw.github.com/Psli/coo/master/redis_server > /etc/init.d/redis_server
    chmod u+x /etc/init.d/redis_server

    sudo /sbin/chkconfig --add redis-server
    sudo /sbin/chkconfig --level 345 redis-server on
    sudo /sbin/service redis-server start

    echo "Redis $VERSION OK!!"

