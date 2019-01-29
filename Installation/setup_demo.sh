#!/usr/bin/env bash
dcos package install --yes dcos-enterprise-cli


dcos security org service-accounts keypair private-key.pem public-key.pem
sh ./create_default_svc_accnt.sh cassandra
sh ./create_default_svc_accnt.sh kubernetes-cluster1
sh ./create_default_svc_accnt.sh kubernetes-cluster2


sleep 10
dcos package repo add --index=0 edgelb-pool https://downloads.mesosphere.com/edgelb-pool/v1.2.1/assets/stub-universe-edgelb-pool.json
dcos package repo add --index=0 edgelb https://downloads.mesosphere.com/edgelb/v1.2.1/assets/stub-universe-edgelb.json

dcos security org service-accounts keypair edge-lb-private-key.pem edge-lb-public-key.pem
dcos security org service-accounts create -p edge-lb-public-key.pem -d "Edge-LB service account" edge-lb-principal
dcos security org service-accounts show edge-lb-principal
dcos security secrets create-sa-secret --strict edge-lb-private-key.pem edge-lb-principal dcos-edgelb/edge-lb-secret
dcos security org groups add_user superusers edge-lb-principal
sleep 60
dcos package install --options=edge-lb-options.json edgelb --yes
j="ABC"
while [ "$j" != "pong" ]
do
    sleep 10
    j=$(dcos edgelb ping)
done
sleep 10
dcos edgelb create edgelb.json
sleep 10

cho "==================================="
echo " Edge Installation Complete"
echo "==================================="
dcos edgelb list
dcos edgelb status edgelb-kubernetes-cluster-proxy-basic
dcos edgelb endpoints edgelb-kubernetes-cluster-proxy-basic
dcos task exec -it edgelb-pool-0-server curl ifconfig.co


dcos security org service-accounts keypair private-key.pem public-key.pem

dcos package install --yes cassandra --option=cassandra-options.json

dcos kubernetes cluster create --yes --options=k8s_options1.json
dcos kubernetes cluster create --yes --options=k8s_options2.json

