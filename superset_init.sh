#!/usr/bin/env bash
set -ex

SUPERSET_CONFIG_PATH=${SUPERSET_CONFIG_PATH:-/etc/superset/superset_config.py}

# Make sure we have a config - if not copy the default
if [ ! -f ${SUPERSET_CONFIG_PATH} ]; then
	cp -v default_superset_config.py ${SUPERSET_CONFIG_PATH}
fi

# Create an admin user (you will be prompted to set username, first and last name before setting a password)
fabmanager create-admin --app superset --username ${SUPERSET_ADM_USR:-admin} --firstname ${SUPERSET_ADM_FIRSTNAME:-admin} --lastname ${SUPERSET_ADM_LASTNAME:-user} --email ${SUPERSET_ADM_EMAIL:-admin@localhost} --password ${SUPERSET_ADM_PWD:-admin}

# Initialize the database
superset db upgrade

# Load some data to play with
superset load_examples

# Create default roles and permissions
superset init

sleep 10

