#!/bin/sh


mr_url="https://redis-discovery-qa.apple.com/api/v2/opsnyquistdev/opsnyquistdev_mr/redis-endpoints-list"
ms_url="https://redis-discovery-qa.apple.com/api/v2/opsnyquistdev/opsnyquistdev_ms/redis-endpoints-list"



function get_hosts_from_url() {
  json_data=$(curl -sS "$1")

  hosts=$(tr -d '"' <<< "$(jq '.[].host' <<< "$json_data")")
  port=$(jq '.[0].sslPort' <<< "$json_data")
  
  for host in $hosts; do
    echo "ssh -L $port:$host:$port chen_yang2@mr37p01ls-zteb04070801.ls.apple.com -N &"
  done
}


get_hosts_from_url $mr_url

get_hosts_from_url $ms_url
