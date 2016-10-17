#!/bin/bash

# Prepare files
/bin/sed -i "s/{{STATE}}/${STATE:-BACKUP}/g" /etc/keepalived/keepalived.conf
/bin/sed -i "s/{{PRIORITY}}/${PRIORITY:-100}/g" /etc/keepalived/keepalived.conf
/bin/sed -i "s/{{CLUSTER_ID}}/${CLUSTER_ID:-50}/g" /etc/keepalived/keepalived.conf
/bin/sed -i "s/{{UNICAST_IPS}}/${UNICAST_IPS}/g" /etc/keepalived/keepalived.conf
/bin/sed -i "s/{{PASSWORD}}/${PASSWORD}/g" /etc/keepalived/keepalived.conf

/bin/sed -i "s/{{OVH_APP_KEY}}/${OVH_APP_KEY}/g" /etc/keepalived/assign_ip.rb
/bin/sed -i "s/{{OVH_APP_SECRET}}/${OVH_APP_SECRET}/g" /etc/keepalived/assign_ip.rb
/bin/sed -i "s/{{OVH_APP_CONSUMER}}/${OVH_APP_CONSUMER}/g" /etc/keepalived/assign_ip.rb
/bin/sed -i "s/{{OVH_PROJECT}}/${OVH_PROJECT}/g" /etc/keepalived/assign_ip.rb
/bin/sed -i "s/{{OVH_FAILOVER_IP}}/${OVH_FAILOVER_IP}/g" /etc/keepalived/assign_ip.rb
/bin/sed -i "s/{{OVH_CURRENT_SERVER}}/${OVH_CURRENT_SERVER}/g" /etc/keepalived/assign_ip.rb


# On SIGTERM kill process
trap "stop; exit 0;" SIGTERM SIGINT
stop()
{
  echo "SIGTERM caught, terminating process..."

  pid=$(pidof keepalived)
  kill -TERM $pid > /dev/null 2>&1

  wait $pid
  exit 0
}

# Start keepalived
while true; do
  pid=$(pidof keepalived)

  while [ -z "$pid" ]; do
    echo "Current config /etc/keepalived/keepalived.conf contents..."
    cat /etc/keepalived/keepalived.conf

    echo "Starting Keepalived..."
    /usr/sbin/keepalived --dont-fork --log-console --log-detail --vrrp

    pid=$(pidof keepalived)

    # Check if startup is successfull
    if [ -z "$pid" ]; then
      echo "Startup failed, retrying..."
      sleep 4
    fi
  done

  # Break while loop when started
  break
done

# Wait until process is stopped and exit
wait $pid
echo "Exiting..."
exit 1
