#!/bin/bash
# restore_buckets.sh - Restore demo buckets from backup

set -e

ALIAS="${1:-local}"
BACKUP_DIR="${2:-./bucket-backup}"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory not found: $BACKUP_DIR"
    echo ""
    echo "Usage: $0 [alias] [backup-dir]"
    echo "  alias:      MinIO alias (default: local)"
    echo "  backup-dir: Path to backup directory (default: ./bucket-backup)"
    echo ""
    echo "Example:"
    echo "  $0 local ./bucket-backup"
    exit 1
fi

echo "Restoring demo buckets to alias: $ALIAS"
echo "Backup directory: $BACKUP_DIR"
echo ""

# List of buckets to restore
BUCKETS=(
    "universal-products"
    "global-services"
    "premier-solutions"
    "quality-components"
    "reliable-materials"
    "strategic-alliance"
    "innovation-collaborative"
)

# Restore each bucket
for bucket in "${BUCKETS[@]}"; do
    if [ ! -d "$BACKUP_DIR/$bucket" ]; then
        echo "⚠ Skipping $bucket (not found in backup)"
        continue
    fi

    echo "Restoring bucket: $bucket"

    # Create bucket if it doesn't exist
    if ! mc ls "$ALIAS/$bucket" > /dev/null 2>&1; then
        echo "  Creating bucket: $bucket"
        mc mb "$ALIAS/$bucket"
    else
        echo "  Bucket already exists: $bucket"
    fi

    # Mirror files from backup to bucket
    echo "  Uploading files..."
    mc mirror "$BACKUP_DIR/$bucket" "$ALIAS/$bucket" --overwrite

    # Count files
    file_count=$(mc ls "$ALIAS/$bucket" --recursive | wc -l)
    echo "  ✓ Successfully restored $bucket ($file_count files)"
    echo ""
done

echo "=============================================="
echo "Restore complete!"
echo "=============================================="
echo ""
echo "Verify the buckets:"
echo "  mc ls $ALIAS"
echo ""
echo "Check a bucket's contents:"
echo "  mc ls $ALIAS/universal-products --recursive"
