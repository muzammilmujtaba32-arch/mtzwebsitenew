#!/bin/bash
# Rebuilds the sanitary product photos (commodes, wash basins, vanity basins) shown in "Commodes, basins & vanities".
# Sources: the makers' own product pictures, downloaded on 16 Oct 2026 at the owner's request into
#   ~/Downloads/Sanitary sources/master/  (mastersanitaryware.com: commode, basin and vanity pages)
#   ~/Downloads/Sanitary sources/dell/    (dellsanitary.com: the two wall-hung commodes only)
# No Indian (squat) toilets, by the owner's instruction.
# Usage:  tools/sanitary-images.sh [output-folder]      (default: site/assets/img/sanitary)
# Needs macOS only (compiles tools/imagetool.swift with swiftc).
#
# Each crop keeps only the product (x y w h in the source's pixels, top-left origin); the printed model names,
# dimension drawings and spec tables are cut away. Two Master pictures have their model name painted out first,
# because it sits next to the product. Master's pictures are small (about 372 x 290), so they are never upscaled.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/site/assets/img/sanitary}"
SRC="$HOME/Downloads/Sanitary sources"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
swiftc -O "$ROOT/tools/imagetool.swift" -o "$TMP/imagetool"
IT="$TMP/imagetool"
mkdir -p "$OUT"

# Paint the printed model names out of OP-13 and V-13 (plain white background beside the product)
"$IT" rowfill "$SRC/master/commode--OP-13.jpg" "$TMP/op-13.jpg" 180,18,186,44:flat
"$IT" rowfill "$SRC/master/vanity--V-13-1.jpg" "$TMP/v-13.jpg" 186,18,180,56:flat

# product <output name> <source> <x> <y> <w> <h>   (JPEG + AVIF, longest side at most 600, never upscaled)
product() {
  "$IT" export "$2" "$3" "$4" "$5" "$6" 600 "$OUT/$1.jpg" "$OUT/$1.avif" 0.82 0.6 >/dev/null
  echo "  $1"
}
product commode-op-4        "$SRC/master/commode--OP-4-1.jpg"   15  20 175 242   # Master OP-4 one-piece commode
product commode-op-13       "$TMP/op-13.jpg"                     15  18 222 266   # Master OP-13 one-piece commode
product wall-hung-005       "$SRC/dell/wall-hang-23.jpg"        110 300 900 670   # Dell 005 wall-hung commode
product wall-hung-07        "$SRC/dell/wall-hang-25.jpg"        140 300 860 670   # Dell 07 wall-hung commode
product basin-bp-28         "$SRC/master/basin--BP-28.jpg"        8   4 196 284   # Master BP-28 pedestal basin
product basin-grace-bp-10   "$SRC/master/basin--bp-10.jpg"        4  35 168 241   # Master Grace BP-10 pedestal basin
product vanity-pearl-v-24   "$SRC/master/vanity--v-24.jpg"        2  50 230 165   # Master Pearl V-24 vanity basin
product vanity-delta-v-13   "$TMP/v-13.jpg"                       4  50 200 152   # Master Delta V-13 vanity basin
echo "Done."
