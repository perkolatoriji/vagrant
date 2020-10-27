#!/bin/bash
#
set -x

PSCRIPTS="~/scripts"

#Main

DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=$(cat $PSCRIPTS/datadog_config.sec)  DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

#End
