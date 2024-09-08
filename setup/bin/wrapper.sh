#!/usr/bin/env bash

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

cmd=${ZDI_CMD_FULL_PATH}
log=/var/log/zdi-wrapper.log

wrapper_start()
{
    {
        show_info 'Starting wrapper!'

        show_info 'Running post setup.'
        bash "${bin}/post-setup-prompt.sh"
        bash "${bin}/post-setup.sh"

        show_info "Starting '${cmd}'."
        sudo "${cmd}" start

        show_success 'Wrapper started!'
    } >> "${log}" 2>&1
}

wrapper_stop()
{
    {
        show_info 'Stopping wrapper!'

        show_info "Stopping '${cmd}'."
        sudo "${cmd}" stop

        show_success 'Wrapper stopped!'
    } >> "${log}" 2>&1
}

tail -f "${log}" &
echo "Tailing log from '${log}'." >> "${log}" 2>&1

wrapper_start

echo 'Waiting for termination signal to stop container gracefully.' >> "${log}" 2>&1

trap 'wrapper_stop; sleep 1; exit 0' SIGTERM
while kill -0 "$$" > /dev/null 2>&1; do
    wait
done
