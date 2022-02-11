#!/bin/bash

# Only allow script to run as
if [ "$(whoami)" != "root" ]; then
  echo "This script needs to be run as root. Try again with 'sudo $0'"
  exit 1
fi

if [ -z "$NETNS_NAME" ]; then
  echo Namespace name required, aborting.
  exit 1
fi

if [ -z "$NETNS_ADDR_NET" ]; then
  echo IP address of namespace required, aborting.
  exit 1
fi

# name of the default interface to connect to the Internet
iface_default=$(route | grep '^default' | grep -o '[^ ]*$')

# name of paired interfaces
iface_local="$NETNS_NAME-veth0"

# deletes namespace, virtual interfaces associated with it, and iptables rules
ip netns delete "$NETNS_NAME"
ip link delete "$iface_local"
iptables -F
iptables -F -t nat
iptables -X
iptables -X -t nat
