#!/bin/bash
# backup_buckets.sh - Create a backup of all demo buckets

set -e

ALIAS="${1:-sample}"
BACKUP_DIR="${2:-./bucket-backup}"

echo "Creating backup of demo buckets from alias: $ALIAS"
echo "Backup directory: $BACKUP_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# List of buckets to backup
BUCKETS=(
    "universal-products"
    "global-services"
    "premier-solutions"
    "quality-components"
    "reliable-materials"
    "strategic-alliance"
    "innovation-collaborative"
)

# Backup each bucket
for bucket in "${BUCKETS[@]}"; do
    echo ""
    echo "Backing up bucket: $bucket"
    mc mirror "$ALIAS/$bucket" "$BACKUP_DIR/$bucket" --overwrite
    echo "✓ Successfully backed up $bucket"
done

echo ""
echo "Backup complete! All buckets saved to: $BACKUP_DIR"
echo ""
echo "To create a tar archive, run:"
echo "  cd $BACKUP_DIR/.."
echo "  tar czf bucket-backup.tar.gz bucket-backup/"
