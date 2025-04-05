#!/usr/bin/env bash

wait_for_db() {
    local db_host=${ZDI_DB_HOSTNAME}
    local db_name=${ZDI_DB_NAME}
    local db_pass=${ZDI_DB_PASSWORD}
    local db_user=${ZDI_DB_USERNAME}

    local retry_count=12
    local wait_time=5

    for ((i = 1; i <= retry_count; i++)); do
    show_info "Attempt $i to check the database..."

    if mysql -h "$db_host" -u "$db_user" -p"$db_pass" -e "USE $db_name;" 2>/dev/null; then
        show_success "Database '$db_name' exists."
        return 0
    else
        show_warning "Database '$db_name' does not exist. Retrying in $wait_time seconds..."
        sleep "$wait_time"
    fi
    done

    show_error "Database '$db_name' does not exist after $retry_count attempts."
    return 1
}
