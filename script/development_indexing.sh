#!/bin/bash
#Script reindexes database each minute

TIMEOUT=60
RAKE='bundle exec rake'

function reindex () {
  $RAKE thinking_sphinx:reindex
}

function start_sphinx () {
  $RAKE thinking_sphinx:start
}

function stop_sphinx () {
  $RAKE thinking_sphinx:stop
}

stop_sphinx
start_sphinx
while [ 0 ] ; do
  echo "indexing data"
  reindex > /dev/null
  sleep $TIMEOUT
done

