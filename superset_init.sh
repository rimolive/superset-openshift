#!/usr/bin/env bash
set -ex

echo SUPERSET_CONFIG_PATH from Env: $SUPERSET_CONFIG_PATH

export SUPERSET_CONFIG_PATH=${SUPERSET_CONFIG_PATH:-/etc/superset/superset_config.py}

# Make sure we have a config - fail if not
if [ ! -f ${SUPERSET_CONFIG_PATH} ]; then
	# NOW USING CONFIG MAP
	# cp -v default_superset_config.py ${SUPERSET_CONFIG_PATH}
	echo $SUPERSET_CONFIG_PATH not found!
	exit -1
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

