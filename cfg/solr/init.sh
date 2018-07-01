#!/usr/bin/env bash

curl --retry 100 --max-time 15 --fail --silent 'http://127.0.0.1:8983/solr/admin/cores?indexInfo=false&wt=json'
if [ "$?" != "0" ]; then
  echo "CRITICAL: solr server is not responding or returned incorrect data." >&2
  exit 2
else
  cd /opt/solr
  if [ ! -d /mnt/data/solr/data/moodle ]; then
    bin/solr create_core -c moodle
  fi
  exit 0
fi
