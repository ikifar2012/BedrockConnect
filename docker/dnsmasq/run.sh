#!/bin/sh
# add the domains to dnsmasq.conf using the environment variables
echo "
address=/hivebedrock.network/${BCIP}
address=/geo.hivebedrock.network/${BCIP}
address=/mco.mineplex.com/${BCIP}
address=/play.inpvp.net/${BCIP}
address=/mco.lbsg.net/${BCIP}
address=/mco.cubecraft.net/${BCIP}
address=/play.galaxite.net/${BCIP}
address=/play.pixelparadise.gg/${BCIP}
" > /etc/dnsmasq.conf

# start dnsmasq
dnsmasq -d