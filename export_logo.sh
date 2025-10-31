#!/usr/bin/env bash
# Converts one SVG into Android drawable PNGs for all DPI buckets.
# Requires: ImageMagick (convert command)

set -e

# === CONFIGURATION ===
SRC_SVG="images/icons/qfield_logo.svg"   # your source SVG file
BASE_SIZE=48             # mdpi size in px (change for logos)
OUT_DIR="platform/android/res"

# === Density multipliers ===
declare -A DENSITIES=(
  [ldpi]=0.75
  [mdpi]=1.0
  [hdpi]=1.5
  [xhdpi]=2.0
  [xxhdpi]=3.0
  [xxxhdpi]=4.0
)

# === MAIN ===
if [[ ! -f "$SRC_SVG" ]]; then
  echo "Error: SVG source '$SRC_SVG' not found!"
  exit 1
fi

for density in "${!DENSITIES[@]}"; do
  scale=${DENSITIES[$density]}
  size=$(awk -v base="$BASE_SIZE" -v s="$scale" 'BEGIN { printf "%d", base * s }')
  outdir="$OUT_DIR/drawable-$density"
  mkdir -p "$outdir"
  outfile="$outdir/qfield_logo.png"

  echo "🖼️  Generating $outfile (${size}x${size})"
  magick convert -background none -resize "${size}x${size}" "$SRC_SVG" "$outfile"
done

echo "✅ All drawable sizes generated under $OUT_DIR"
