#!/usr/bin/env bash

export TERM=xterm-256color

Normal=$(tput sgr0)
Bold=$(tput bold)

Cyan=$(tput setaf 6)
Green=$(tput setaf 2)
Red=$(tput setaf 160)
Yellow=$(tput setaf 220)

dCyan=$(tput dim setaf 6)
dGray=$(tput dim setaf 8)
dGreen=$(tput dim setaf 2)
dRed=$(tput dim setaf 160)
dYellow=$(tput dim setaf 220)

list_colors() {
    for (( i = 0; i < 255; i++ )); do
        printf "%s#Normal# %s#Bold# %s#Dim# %s#DimBold#%s %s\n" \
            "$(tput setaf $i)" "$(tput bold setaf $i)" "$(tput sgr0 dim setaf $i)" "$(tput bold setaf $i)" \
            "$(tput sgr0)" "$i";
    done
}

print_line() {
    size="$1"
    for (( i = 0; i < size; i++ )); do
        printf '%s' '#'
    done
}

print_lines() {
    clr_border="$1"
    clr_text="$2"
    while IFS='' read -r text; do
      printf "# %s------> %s%-69s%s#\n" "${dGray}" "${Normal}${clr_text}" "${text}" "${clr_border}"
    done
}

show_message() {
    clr_border="$1"
    clr_text="$2"
    title="$3"
    size=$((80-${#title}-4))
    text="$4"

    top=$(printf '# %s%s:%s ' "${Bold}${clr_text}" "${title}" "${Normal}${clr_border}"; print_line "${size}")
    bottom=$(printf '#%.0s' {1..80});

    printf '\n%s%s\n' "${clr_border}" "${top}"
    echo "${text}" | fmt -w 69 | print_lines "${clr_border}" "${clr_text}"
    printf "%s%s\n\n" "${bottom}" "${Normal}"
}

show_info() {
    show_message "${dCyan}" "${Cyan}" 'Info' "$1"
}

show_warning() {
    show_message "${dYellow}" "${Yellow}" 'Warning' "$1"
}

show_error() {
    show_message "${dRed}" "${Red}" 'Error' "$1"
}

show_success() {
    show_message "${dGreen}" "${Green}" 'Success' "$1"
}
