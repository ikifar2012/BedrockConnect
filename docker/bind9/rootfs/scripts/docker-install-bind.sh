#!/usr/bin/env bash
#
# Bind install and cofiguration script for Bedrock Connect
# Usage: sudo scripts/install-bind.sh [BCIP] [NSIP]
#   BCIP    Optional IP of the bedrock connect server (Default: 104.238.130.180)
#   NSIP    Optional IP of the name server (Default: same as the bedrock connect server)
#
# Should support Ubuntu 18+, Cent OS 7+, Arch, and Debian
# Tested on: Ubuntu 18.04 LTS, Ubuntu 20.04 LTS, Cent OS 7 and Cent OS 8
#

#
# Configuration
#

BCIP=${1:-104.238.130.180}
NSIP=${2:-$BCIP}
echo "Using Bedrock Connect IP: $BCIP"
echo "Using Name Server IP: $NSIP"
#
# Functions
#

function add_domain() {
  local domain=$1
  shift

  # Warn if exists
  if [[ -n "$(cat $NAMED_ZONES | grep $domain)" ]]; then
    echo "Warning: Domain $domain already exists, skipping..."
    return
  fi
  echo "Adding domain $domain..."

  # Create zone file
  echo "@	IN	SOA	$domain.	admin.$domain. (
				2014030801	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
@	300	NS	ns.$domain.
ns	300	IN	A	$NSIP" > $NAMED_DBS/db.$domain
  while [[ -n "$1" ]]; do
    echo "$1	300	IN	A	$BCIP" >> $NAMED_DBS/db.$domain
    shift
  done

  # Add zone config to named
  echo "zone \"$domain\" IN {
	type master;
	file \"db.$domain\";
	allow-query { any; };
};
" >> $NAMED_ZONES
}

#
# Main

    NAMED_OPTIONS="/etc/bind/named.conf.options"
    NAMED_ZONES="/etc/bind/named.conf.local"
    NAMED_DBS="/var/cache/bind"

# Install
# Configure
# ensure that listen on all interfaces and add the option if not present or commented out
if ! grep -q "listen-on-v6" $NAMED_OPTIONS; then
  echo "listen-on-v6 { any; };" >> $NAMED_OPTIONS
fi
if ! grep -q "listen-on" $NAMED_OPTIONS; then
  echo "listen-on { any; };" >> $NAMED_OPTIONS
fi
# add forwarders if not present or commented out
if ! grep -q "forwarders" $NAMED_OPTIONS; then
  echo "forwarders {
    1.1.1.1;
    1.0.0.1;
};" >> $NAMED_OPTIONS
fi



add_domain hivebedrock.network @ geo
add_domain mineplex.com mco
add_domain inpvp.net play
add_domain lbsg.net mco
add_domain cubecraft.net mco
add_domain galaxite.net play
add_domain pixelparadise.gg play

# Reload config
/usr/sbin/named -g -c ${NAMED_OPTIONS} -u bind