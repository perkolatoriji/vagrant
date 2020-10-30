#!/bin/bash
#
#set -x

#Main

DD=$(grep datadog_api_key /home/vagrant/secrets/datadog_api.sec | cut -f2 -d":")


DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=$DD  DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

#End
