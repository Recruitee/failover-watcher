## Keepalived cluster setup

STATE
PRIORITY
CLUSTER_ID
UNICAST_IPS
PASSWORD

## OVH API setup

OVH_APP_KEY
OVH_APP_SECRET
OVH_APP_CONSUMER

OVH_PROJECT
OVH_FAILOVER_IP
OVH_CURRENT_SERVER

# Commands

docker build -f Dockerfile -t failover-watcher .

docker run -it --rm \
       -e STATE=MASTER \
       -e PRIORITY=100 \
       -e CLUSTER_ID=50 \
       -e UNICAST_IPS="127.0.0.1 127.0.0.1" \
       -e PASSWORD=password \
       -e OVH_APP_KEY=key \
       -e OVH_APP_SECRET=secret \
       -e OVH_APP_CONSUMER=consumer \
       -e OVH_PROJECT=project \
       -e OVH_FAILOVER_IP=ip \
       -e OVH_CURRENT_SERVER=server \
       failover-watcher
