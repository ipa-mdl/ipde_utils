#!/bin/bash -e
ipde_utils_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=helper.sh
source "$ipde_utils_path/helper.bash"

help="usage: $0 label package launch_file [extra_paths *]"

label=$1
shift  || error "no label given, $help"

pkg=$1
shift || error "no package given, $help"

launch=$1
shift || error "no launch file given, $help"

session=$(create_session "$label")

if [ -z "$session" ]
then
  error "could not obtain session URI"
fi

pkg_dir=$(get_pkg_dir $pkg)

configure_pkg_launch "$session" "$pkg_dir" "$launch"

send_src_unique "$pkg_dir" "$session" "$@"

for p in "$@"
do
    send_src "$p" "$session"
done
