# This file serves for extending the container image, typically by changing
# the configuration, loading some data etc.

# Feel free to add content to this file or rewrite it at all.
# You may also start redis server locally to load some data for example,
# but do not forget to stop it after it, so it can be restarted after it.

if [[ -v REDIS_PASSWORD ]]; then
  echo masterauth $REDIS_PASSWORD >> /etc/redis.conf
fi

cat << EOF >> /etc/redis.conf
cluster-enabled yes
cluster-require-full-coverage no
cluster-node-timeout 15000
cluster-config-file /var/lib/redis/data/nodes.conf
cluster-migration-barrier 1
EOF

if [ -f /var/lib/redis/data/nodes.conf ]; then
  sed -i -e "/myself/ s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${POD_IP}/" /var/lib/redis/data/nodes.conf
fi
