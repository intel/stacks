#!/usr/bin/env bash

set -e

function log() {
  test ! -f "$LOGFILE" && touch "$LOGFILE"
  echo "Log message $1" >> "$LOGFILE"
}

# download from $1 to $2
function download() {
  mkdir -p "$2"
  #log "$1 to $2"
  wget -P "$2" "$1" || { echo "download failed"; exit 1; }
  #log "download complete"
}

# cleanup temp directories
function cleanup() {
  #log "removing $1"
  test ! -f "$1" && rm -rf "$1"
  #log "cleanup complete"
}

# extract from compressed tar to a directory
function extract() {
  mkdir -p "$2"
  #log "extract $1 to $2"
  tar -xvf "$1" -C "$2"
  #log "extract complete"
}
