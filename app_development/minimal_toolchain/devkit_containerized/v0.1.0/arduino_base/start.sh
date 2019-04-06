#!/bin/bash
# set -x
AZ3166_version=1.6.2

# Install AZ3166 package
arduino-cli core list | grep -q AZ3166
az3166_installed=$?
if [ $az3166_installed != 0 ]; then
    echo "## AZ3166 has not been installed. Installing AZ3166..."
    
    echo "## Update core index..."
    arduino-cli core update-index

    echo "## Install AZ3166 package"
    arduino-cli core install AZ3166:stm32f4@${AZ3166_version}
fi

# update lib index
if [[ ! $(arduino-cli lib list) ]]; then 
    echo "## Lib index has not been updated. Update lib index..."
    arduino-cli lib update-index
fi

arduino-cli $@