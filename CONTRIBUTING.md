# Contributing to sample-cluster

Thanks for your interest in contributing! This repository contains demo data and helper scripts for running a small AIStor/MinIO-style demo cluster.

What you can contribute

- Add or improve example buckets (content under `bucket-backup/`).
- Add IAM entities (users, groups, policies) used in demos.
- Add or improve scripts in `scripts/`, e.g. backup/restore helpers.
- Improve documentation and troubleshooting steps.

Producing the .zip artifacts used by this project
The two zip files at the repository root are produced by the MinIO Client (`mc`) admin commands and are compatible with `mc admin cluster ... import` operations.

- Export IAM (users/groups/policies):

```bash
mc admin cluster iam export ALIAS
# produces the iam export zip (e.g. sample-iam-info.zip)
```

- Export bucket metadata (settings like versioning, replication, retentions):

```bash
mc admin cluster bucket export ALIAS
# produces the bucket metadata zip (e.g. sample-bucket-metadata.zip)
```

- Export bucket content using the provided helper script:

```bash
./scripts/backup_buckets.sh ALIAS ./bucket-backup
```

When contributing zip artifacts, please ensure they are small and intended for demo use. If your change includes large or binary data not suitable for Git, consider adding it as a Release asset instead.

Bucket settings and metadata
This repository stores bucket metadata zip files that contain settings such as:

- Versioning
- Retention rules
- Replication rules

Ensure these settings are created in your test cluster before exporting, and verify they are compatible with `mc admin cluster bucket import`.

Code and script quality

- Shell scripts: please lint with `shellcheck` and keep code POSIX-/bash-friendly.
- Make small, focused PRs with a clear description of what you changed and why.
- If you change scripts, add or update instructions in README and/or examples demonstrating usage.

Thank you!
