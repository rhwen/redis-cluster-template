# Redis Cluster Template

Deploy redis cluster on OpenShift, it developed based on redis-persistent-template which is a standalone redis server, and will use image registry.redhat.io/rhscl/redis-5-rhel7:5 directly instead of ImageStream in this template. It has been tested on OCP 4.4.3. 

For more information please refer to:
https://catalog.redhat.com/software/containers/rhscl/redis-5-rhel7/5c9922045a13464733ee0ecc
https://github.com/sclorg/redis-container/blob/master/examples/redis-persistent-template.json

Step 1: create a new project.
```
oc new-project redis-demo
```

Step 2: create the template within the project.
```
oc create -f redis-cluster-persistent-template.json
```

Step 3: create the redis cluster from template.
```
oc new-app redis-cluster-persistent
```

Step 4: wait for all of the 6 pods running.
```
oc get pod -w
```
Step 5: create Redis cluster and wait for nodes join.
```
oc exec -it redis-0 -- /opt/rh/rh-redis5/root/usr/bin/redis-cli -a $REDIS_PASSWORD --cluster create --cluster-replicas 1 $(oc get pods -l name=redis -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')
```

Step 6: Check the nodes of cluster
```
oc exec -it redis-0 -- cat /var/lib/redis/data/nodes.conf
```

Step 7: Check the cluster status
```
oc exec -it redis-0 -- /opt/rh/rh-redis5/root/usr/bin/redis-cli -a $REDIS_PASSWORD cluster info
```
The output would be like:
```
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:197
cluster_stats_messages_pong_sent:212
cluster_stats_messages_sent:409
cluster_stats_messages_ping_received:207
cluster_stats_messages_pong_received:197
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:409
```
