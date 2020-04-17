#!/usr/bin/env bash

cmd="$1"
input="$(</dev/stdin)"

[ -z "$cmd" ] && exit 1
[ -z "$input" ] && exit 1

parse_urls() {
  echo "$1" | grep -Paio 'https?://[^ "\(\)\[\]]*'
}

case "$cmd" in
  copy)
    parse_urls "$input" | awk '!a[$0]++' | dmenu -i -l 16 -p 'Copy URL' -l 10 | xclip -selection clipboard
    ;;
  open)
    parse_urls "$input" | awk '!a[$0]++' | dmenu -i -l 16 -p 'Open URL' -l 10 | xargs xdg-open
    ;;
esac

