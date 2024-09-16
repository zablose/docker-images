#!/usr/bin/env bash

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

user_name=${ZDI_USER_NAME}

home=/home/${user_name}
wrapper=${home}/wrapper
log=${home}/zdi-wrapper.log

wrapper_start()
{
    {
        show_info 'Starting wrapper!'

        show_info 'Running first run setup.'
        bash "${wrapper}/bash-prompt.sh"
        bash "${wrapper}/setup.sh"

        show_info 'Running start commands.'
        bash "${wrapper}/start.sh"

        show_success 'Wrapper started!'
    } >> "${log}" 2>&1
}

wrapper_stop()
{
    {
        show_info 'Stopping wrapper!'

        show_info "Running stop commands."
        bash "${wrapper}/stop.sh"

        show_success 'Wrapper stopped!'
    } >> "${log}" 2>&1
}

tail -f "${log}" &
echo "Tailing log from '${log}'." >> "${log}" 2>&1

wrapper_start

echo 'Waiting for termination signal to stop container gracefully.' >> "${log}" 2>&1

trap 'wrapper_stop; sleep 1; exit 0' SIGTERM SIGQUIT
while kill -0 "$$" > /dev/null 2>&1; do
    wait
done
