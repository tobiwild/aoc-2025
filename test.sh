#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

dbg() {
    >&2 echo -e "\e[36m$*\e[0m"
}

dbg_stdin() {
    local prefix=$1
    shift
    while IFS= read -r line; do dbg "$prefix $line"; done
}

write=0
override=0

_process_input_file() {
    local dir
    local base
    local input_file=$1
    dir=$(dirname "$input_file")
    base=$(basename "$input_file")
    base="${base%%_*}"
    local script="$dir/$base.rb"
    local prefix="[$input_file]"
    if [ ! -f "$script" ]; then
        dbg "$prefix $script not found"
        exit 1
    fi
    local output
    set +e
    output=$(ruby "$script" "$input_file")
    local retval=$?
    set -e
    if [ $retval -ne 0 ]; then
        echo "$output"
        exit $retval
    fi
    if [ -z "$output" ]; then
        dbg "$prefix empty output"
        exit 1
    fi
    local output_file="${input_file%.*}.out"
    if [ $override -eq 0 ] && [ -f "$output_file" ]; then
        local expected
        expected=$(<"$output_file")
        if [[ "$output" == "$expected" ]]; then
            dbg "$prefix output matches $output_file"
            echo "$output"
        else
            dbg "$prefix output does not match $output_file"
            dbg "$prefix Expected:"
            dbg_stdin "$prefix" <<< "$expected"
            dbg "$prefix Actual:"
            echo "$output"
            exit 1
        fi
    elif [ $write -eq 1 ]; then
        dbg "$prefix create output file $output_file"
        echo "$output" | tee "$output_file"
    else
        echo "$output"
    fi
}

opts=()
while getopts "wo" opt ; do
    opts+=("-$opt")
    if [[ "$opt" == "w" ]]; then
        write=1
    elif [[ "$opt" == "o" ]]; then
        write=1
        override=1
    fi
done
shift $((OPTIND-1))

files=("$@")
if [ ${#files[@]} -eq 0 ]; then
    files=( *.in )
fi

for file in "${files[@]}"; do
    _process_input_file "$file"
done
