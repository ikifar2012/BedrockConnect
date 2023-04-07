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
function generate_serial() {
  date +%Y%m%d%H
}

function add_domain() {
  local domain=$1
  shift

  # Warn if exists
  if [[ -n "$(cat $NAMED_ZONES | grep "$domain")" ]]; then
    echo "Warning: Domain $domain already exists, skipping..."
    return
  fi
  echo "Adding domain $domain..."
  serial=$(generate_serial)
  # Create zone file
  echo "
  @	IN	SOA	$domain.	admin.$domain. (
        $serial ; serial
          1D  ; refresh
          1H  ; retry
          1W  ; expire
          3H )  ; minimum
@	300	NS	ns.$domain.
ns	300	IN	A	$NSIP" > $NAMED_DBS/db."$domain"
  while [[ -n "$1" ]]; do
    echo "$1	300	IN	A	$BCIP" >> $NAMED_DBS/db."$domain"
    shift
  done

  # Add zone config to named
  echo "
  zone \"$domain\" IN {
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
# Check if listen-on option exists in named.conf file
if grep -q "^listen-on" $NAMED_OPTIONS; then
    # Check if listen-on option is commented out
    if grep -q "^#listen-on" $NAMED_OPTIONS; then
        # Uncomment listen-on option
        sed -i 's/^#listen-on/listen-on/' $NAMED_OPTIONS
    fi
else
    # Add listen-on option to named.conf file
    echo "listen-on { any; };" >> $NAMED_OPTIONS
fi

# Remove listen-on-v6 option from named.conf file if it exists
sed -i '/^listen-on-v6/d' $NAMED_OPTIONS

# Add listen-on option to named.conf file if it doesn't exist
if ! grep -q "^listen-on" $NAMED_OPTIONS; then
    echo "listen-on { any; };" >> $NAMED_OPTIONS
fi
# add forwarders if not present or commented out
if ! grep -q "^forwarders" $NAMED_OPTIONS; then
  echo "forwarders {
    1.1.1.1;
    1.0.0.1;
};" >> $NAMED_OPTIONS
else
  if grep -q "^#forwarders" $NAMED_OPTIONS; then
    sed -i 's/^#forwarders/forwarders/' $NAMED_OPTIONS
  fi
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
hivebedrock.network 
geo.hivebedrock.network
mco.mineplex.com
play.inpvp.net
mco.lbsg.net
mco.cubecraft.net
play.galaxite.net
play.pixelparadise.gg