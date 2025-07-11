#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

add_chromium=${ARG_ADD_CHROMIUM}
position=${ARG_VERSION_CHROMIUM}

url=https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/${position}
browser_zip=chrome-linux.zip
driver_zip=chromedriver_linux64.zip
chromium=/opt/google/chrome-linux/chrome
log=/var/log/zdi-chromium-install.log

{
    show_info 'Install Chromium.'

    if [[ "${add_chromium}" != "true" ]]
    then
        show_warning 'Skipping Chromium installation ...'
        exit 0
    fi

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        chromium
    apt-get remove -y chromium
    curl -s "${url}/${browser_zip}" -o ${browser_zip}
    unzip ${browser_zip} -d /opt/google/
    rm -f ${browser_zip}
    ln -sr ${chromium} /usr/bin/chromium

    show_info 'Install Chrome driver.'

    curl -s "${url}/${driver_zip}" -o ${driver_zip}
    unzip -j ${driver_zip} -d /usr/local/bin/
    rm -f ${driver_zip}

    show_success "Chromium and Chrome driver installation complete. Log file '${log}'."

} 2>&1 | tee ${log}
