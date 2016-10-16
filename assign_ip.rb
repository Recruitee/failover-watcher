require 'ovh/rest'

OVH_APP_KEY = "{{OVH_APP_KEY}}"
OVH_APP_SECRET = "{{OVH_APP_SECRET}}"
OVH_APP_CONSUMER = "{{OVH_APP_CONSUMER}}"

OVH_PROJECT = "{{OVH_PROJECT}}"
OVH_FAILOVER_IP = "{{OVH_FAILOVER_IP}}"
OVH_CURRENT_SERVER = "{{OVH_CURRENT_SERVER}}"

ovh = OVH::REST.new(OVH_APP_KEY, OVH_APP_SECRET, OVH_APP_CONSUMER)
5.times do
  result = ovh.get("/cloud/project/#{OVH_PROJECT}/ip/failover/#{OVH_FAILOVER_IP}") rescue {}
  if result["routedTo"] != OVH_CURRENT_SERVER
    ovh.post("/cloud/project/#{OVH_PROJECT}/ip/failover/#{OVH_FAILOVER_IP}/attach", {"instanceId" => OVH_CURRENT_SERVER}) rescue nil
    sleep 10
  else
    break
  end
end
