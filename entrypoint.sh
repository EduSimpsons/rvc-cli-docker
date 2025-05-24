#!/bin/bash
set -e

WORKDIR="/app"
INPUT_DIR="$WORKDIR/input"
OUTPUT_DIR="$WORKDIR/output"

MINIO_ENDPOINT="$1"
MINIO_USER="$2"
MINIO_PASSWORD="$3"
INPUT_FILE="$4"
OUTPUT_FILE="$5"
PTH_FILE="$6"
INDEX_FILE="$7"

mc alias set minio "$MINIO_ENDPOINT" "$MINIO_USER" "$MINIO_PASSWORD"

mkdir -p "$INPUT_DIR" "$OUTPUT_DIR"

# Downloads – immer nur bis ins Verzeichnis
mc cp "minio/$INPUT_FILE"  "$INPUT_DIR/"
ls /app/input/
mc cp "minio/$PTH_FILE"    "$INPUT_DIR/"
ls /app/input/
mc cp "minio/$INDEX_FILE"  "$INPUT_DIR/"

ls /app/input/

# Dateinamen ermitteln
INPUT_NAME=$(basename "$INPUT_FILE")
PTH_NAME=$(basename "$PTH_FILE")
IDX_NAME=$(basename "$INDEX_FILE")

# Inferenz
python3 rvc_cli.py infer \
        --input_path  "$INPUT_DIR/$INPUT_NAME" \
        --output_path "$OUTPUT_DIR/output.wav" \
        --pth_path    "$INPUT_DIR/$PTH_NAME" \
        --index_path  "$INPUT_DIR/$IDX_NAME"

ls /app/output/

# Upload
mc cp "$OUTPUT_DIR/output.wav" "minio/$OUTPUT_FILE"

echo "Voice conversion completed successfully."
