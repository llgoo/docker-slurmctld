#!/bin/bash

if [ -z ${SLURM_CLUSTER_NAME+x} ]; then echo "SLURM_CLUSTER_NAME not set" && exit 1; fi
if [ -z ${SLURM_CONTROL_MACHINE+x} ]; then echo "SLURM_CONTROL_MACHINE not set" && exit 1; fi
if [ -z ${SLURM_CONTROL_ADDR+x} ]; then echo "SLURM_CONTROL_ADDR not set" && exit 1; fi
if [ -z ${SLURM_NODE_NAME+x} ]; then echo "SLURM_NODE_NAME not set" && exit 1; fi
if [ -z ${SLURM_NODE_ADDR+x} ]; then echo "SLURM_NODE_ADDR not set" && exit 1; fi
#if [ -z ${INFLUXDB_HOST+x} ]; then echo "INFLUXDB_HOST not set" && exit 1; fi
#if [ -z ${INFLUXDB_DATABASE_NAME+x} ]; then echo "INFLUXDB_DATABASE_NAME not set" && exit 1; fi

SLURM_CONF_LOCATION=/etc/slurm/slurm.conf
sed -i -e "s/###SLURM_CLUSTER_NAME###/${SLURM_CLUSTER_NAME}/g" $SLURM_CONF_LOCATION
sed -i -e "s/###SLURM_CONTROL_MACHINE###/${SLURM_CONTROL_MACHINE}/g" $SLURM_CONF_LOCATION
sed -i -e "s/###SLURM_CONTROL_ADDR###/${SLURM_CONTROL_ADDR}/g" $SLURM_CONF_LOCATION
sed -i -e "s/###SLURM_NODE_NAME###/${SLURM_NODE_NAME}/g" $SLURM_CONF_LOCATION
sed -i -e "s/###SLURM_NODE_ADDR###/${SLURM_NODE_ADDR}/g" $SLURM_CONF_LOCATION
#sed -i -e "s/###INFLUXDB_HOST###/${INFLUXDB_HOST}/g" /usr/local/etc/acct_gather.conf
#sed -i -e "s/###INFLUXDB_DATABASE_NAME###/${INFLUXDB_DATABASE_NAME}/g" /usr/local/etc/acct_gather.conf

/usr/bin/supervisord --nodaemon
