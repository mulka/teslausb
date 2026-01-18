#!/bin/bash -eu

# read the setup variables again because arrays, like RCLONE_FLAGS, don't export to subshells/child scripts
source /root/bin/envsetup.sh

flags=("-L" "--transfers=1")
if [[ -v RCLONE_FLAGS ]]
then
  flags+=("${RCLONE_FLAGS[@]}")
fi

archive_start_ts=$(date --utc +"%Y%m%dT%H%M%SZ")
sentrylist_file="${2:-}"
if [ -n "$sentrylist_file" ] && [ -f "$sentrylist_file" ]
then
  sentrylist_basename=$(basename "$sentrylist_file")
  sentrylist_dest="${RCLONE_DRIVE}:${RCLONE_PATH}/archive-lists/${archive_start_ts}/${sentrylist_basename}"
  if ! rclone --config /root/.config/rclone/rclone.conf copyto "$sentrylist_file" "$sentrylist_dest" >> "$LOG_FILE" 2>&1
  then
    echo "$(date): failed to upload sentry list to ${sentrylist_dest}" >> "$LOG_FILE"
  fi
fi

while [ -n "${1+x}" ]
do
  rclone --config /root/.config/rclone/rclone.conf move "${flags[@]}" --files-from "$2" "$1" "$RCLONE_DRIVE:$RCLONE_PATH" >> "$LOG_FILE" 2>&1
  shift 2
done
