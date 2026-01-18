# Archive list uploads (rclone)

## Overview
When the rclone archive backend runs, it uploads the current TeslaCam archive list
file to the same remote used for clip storage, before moving any clips. This
produces a timestamped snapshot of the list for later auditing.

## Location in the bucket
Each upload is placed under the archive path, in a dedicated folder:

- Remote path: `${RCLONE_DRIVE}:${RCLONE_PATH}/archive-lists/<timestamp>/<list-file-name>`
- `<timestamp>` is generated in UTC when the archive script starts.
- `<list-file-name>` is the basename of the list file passed by `archiveloop`
  (currently `/tmp/sentry_files`).

The rclone archive script uses this location to store the list file before
invoking `rclone move` for the clips.

## Timestamp format
The timestamp uses UTC in the form `YYYYMMDDTHHMMSSZ` (for example,
`20260118T174501Z`).

## File content format
The list file contains one path per line, with paths relative to the TeslaCam
root. The list is built from symlinked clip entries and can include:

- `SavedClips/<event>/...`
- `SentryClips/<event>/...`
- `TeslaTrackMode/...`
- `RecentClips/...` (only when enabled)

Example lines:
SavedClips/2026-01-18_10-05-00/videos.mp4
SavedClips/2026-01-18_10-05-00/event.json
SentryClips/2026-01-18_11-15-30/videos.mp4
TeslaTrackMode/lapvideo.mp4
