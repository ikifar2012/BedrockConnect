#!/bin/bash
NAMED_ZONES="/etc/bind/named.conf.local"
function remove_domain() {
  local domain=$1

  # Remove zone file
  rm -f $NAMED_DBS/db.$domain

  # Remove zone config from named
  sed -i "/zone \"$domain\"/d" $NAMED_ZONES
}
remove_domain hivebedrock.network
remove_domain mineplex.com
remove_domain inpvp.net
remove_domain lbsg.net
remove_domain cubecraft.net
remove_domain galaxite.net
remove_domain pixelparadise.gg