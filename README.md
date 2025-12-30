# Sample AIStor cluster for training and demo purposes

This directory contains pre-created demo data for the AIStor demonstrations and training labs.

## Use case

This cluster setup represents a company called Nexus Industries that has several customers, partners, and suppliers.
Each of those companies has a bucket with documents: meeting notes, contracts, reports.

Nexus Industries has three sales teams, a partner team, and a procurement department.
Each of the teams has an associated group in AIStor with attached policies.

Access policies give access:

- for the partner team: read-write access to the partners' buckets and read-only access to the bucket `general`
- for the procurement department: read-write access to the suppliers' buckets and read-only access to the bucket `general`
- for the sales teams: read-write access to their customer's bucket, read-only access to other customers' buckets, and read-only access to the bucket `general`
- for the c-level team that includes the CEO and CFO: full access to all buckets

## Contents

- `bucket-backup/` - buckets' sample content
- `sample-iam-info.zip` - exported IAM (Identity and Access Management) information including users, groups, and policies
- `sample-bucket-metadata.zip` - exported bucket metadata that includes versioning, replication, retentions, and other bucket settings
- `scripts` - backup and restore scripts
- `docker-compose.yml` - Docker/Podman Compose file to start the AIStor cluster

## What's included

The backup contains **28 documents** organized across **7 buckets**:

| Bucket                   | Company                           | Type     | Documents |
| ------------------------ | --------------------------------- | -------- | --------- |
| universal-products       | Universal Products Inc.           | Customer | 4         |
| global-services          | Global Services Corporation       | Customer | 4         |
| premier-solutions        | Premier Solutions Ltd.            | Customer | 4         |
| quality-components       | Quality Components Inc.           | Supplier | 4         |
| reliable-materials       | Reliable Materials Supply         | Supplier | 4         |
| strategic-alliance       | Strategic Alliance Group          | Partner  | 4         |
| innovation-collaborative | Innovation Collaborative Partners | Partner  | 4         |

Each bucket contains:

- 1 contract document (`.md`)
- 1 meeting notes document (`.md`)
- 1 quarterly report (`.csv`)
- 1 analytics document (`.md`)

## How to restore the demo data

### Prerequisites

1. You have an AIStor cluster running
   1. The easiest way to start it: run `docker compose up -d` from the project root
1. You have the MinIO Client (`mc`) installed
1. You have configured an alias pointing to your MinIO instance. In the following examples we use the alias `sample`. Replace it with your actual alias.
   1. For example: `mc alias set sample http://localhost:9000 minioadmin minioadmin`

### Restore users, groups, policies

1. Run this command:

   ```bash
   mc admin cluster iam import sample sample-iam-info.zip
   ```

1. Check the results:

   ```bash
   mc admin user list sample
   mc admin group list sample
   mc admin policy list sample
   ```

   You should see the lists of users, groups, policies

### Restore the buckets

1. Run this command:

   ```bash
   mc admin cluster bucket import sample sample-bucket-metadata.zip
   ```

1. Check the results:

   ```bash
   mc ls sample
   ```

   You should see a list of eight buckets (if your cluster was empty in the beginning).

### Restore the buckets' content

1. Run the restore script.

   ```bash
   ./scripts/restore_buckets.sh sample ./bucket-backup
   ```

1. Verify the buckets were created and filled with content.

   ```bash
   mc ls -r sample
   ```

   Expected output:

   ```none
   [2025-12-29 20:50:16 EST] 1.6KiB STANDARD global-services/analytics/roi-analysis-2024.md
   [2025-12-29 20:50:16 EST]   907B STANDARD global-services/contracts/enterprise-license-2024.md
   [2025-12-29 20:50:16 EST] 1.3KiB STANDARD global-services/meetings/strategic-planning-oct-2024.md
   [2025-12-29 20:50:16 EST]   180B STANDARD global-services/reports/performance-metrics-q3-2024.csv
   [2025-12-29 20:50:16 EST] 2.5KiB STANDARD innovation-collaborative/analytics/innovation-roi-forecast-2024.md
   [2025-12-29 20:50:16 EST] 1.8KiB STANDARD innovation-collaborative/contracts/innovation-partnership-2024.md
   [2025-12-29 20:50:16 EST] 2.9KiB STANDARD innovation-collaborative/meetings/technical-review-aug-2024.md
   [2025-12-29 20:50:16 EST]   333B STANDARD innovation-collaborative/reports/project-status-q3-2024.csv
   . . . .
   ```

### Restore the buckets' content manually (alternative)

If you prefer to restore manually:

1. Enter the `bucket-backup` directory:

   ```bash
   cd bucket-backup
   ```

1. Upload files.

   For each directory run this command

   ```bash
   mc mirror universal-products/ sample/universal-products/

   # ... repeat for all 7 directories
   ```

## Creating your own backup

If you've made changes to the demo environment and want to create a new backup:

1. Run the backup script to save buckets' content:

   ```bash
   ./scripts/backup_buckets.sh sample ./bucket-backup
   ```

1. Save the buckets' metadata:

   ```bash
   mc admin cluster bucket export sample
   ```

1. Save the IAM information:

   ```bash
   mc admin cluster iam export sample
   ```

## Directory structure

The backup maintains the following structure:

```none
bucket-backup/
├── universal-products/
│   ├── contracts/
│   │   └── master-service-agreement-2024.md
│   ├── meetings/
│   │   └── quarterly-review-q3-2024.md
│   ├── reports/
│   │   └── quarterly-report-q3-2024.csv
│   └── analytics/
│       └── usage-analysis-2024.md
├── global-services/
│   ├── contracts/
│   ├── meetings/
│   ├── reports/
│   └── analytics/
... (5 more buckets with same structure)
```

Each document type is in its own subdirectory within each bucket.
