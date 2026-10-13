#!/bin/bash
# Rebuilds the 23 cropped website photos (products, sanitary real-*/fittings-*, showroom, promo) from the owner's
# original files, with the exact crops used on the site. Not rebuilt here: the ai-* illustrations (Canva), the video
# poster, og-image and icons (see docs/HANDOFF.md, "Where every photo came from").
# Usage:  tools/crop-images.sh [output-folder]      (default: site/assets/img)
# Needs only macOS `sips` (no Python libraries, no ffmpeg).
#
# Crop arguments are: height width offsetY offsetX (sips --cropOffset takes Y first).
# Images are never upscaled: the longest side is capped at the given size or the crop size, whichever is smaller.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/site/assets/img}"
SRC="$HOME/Downloads/mtz product picture"                    # catalogue screenshots + showroom photos
ST="$HOME/mtz assets/04 PHOTOS/_stills-from-footage"         # stills cut from the showroom video
BOND="$HOME/Downloads/bond moke up"                          # tile bond / grout studio mockups
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

mkdir -p "$OUT/products" "$OUT/sanitary" "$OUT/showroom" "$OUT/promo"

# crop <source> <output> <height> <width> <offsetY> <offsetX> [maxSize=1000] [quality=72]
crop() {
  local max=${7:-1000} q=${8:-72} long=$4
  [ "$3" -gt "$4" ] && long=$3
  [ "$long" -lt "$max" ] && max=$long
  sips -s format jpeg -c "$3" "$4" --cropOffset "$5" "$6" "$1" --out "$TMP/c.jpg" >/dev/null
  sips -s format jpeg -s formatOptions "$q" --resampleHeightWidthMax "$max" "$TMP/c.jpg" --out "$2" >/dev/null
  echo "  $(basename "$2")"
}

echo "Tile styles -> $OUT/products"
P="$OUT/products"
crop "$SRC/IMG_3327.PNG"                      "$P/tile-white-marble.jpg"      600  847 1800 214   # Time Ceramics L12003, 600x1200
crop "$SRC/IMG_3330.PNG"                      "$P/tile-grey-marble.jpg"       600  847 1667 214   # Time Ceramics L12031, 600x1200
crop "$SRC/IMG_3329.PNG"                      "$P/tile-black-gold-marble.jpg" 600  847 1873 214   # Time Ceramics L12021H, 600x1200
crop "$SRC/PHOTO-2026-07-13-11-23-41 7.jpg"   "$P/tile-blue-marble-slab.jpg"  675  900  111 240   # real showroom photo (label 24x24)
crop "$SRC/IMG_3338.jpg"                      "$P/tile-wood-plank.jpg"        712  955   28 300   # Time Ceramics L21208, 200x1200
crop "$SRC/PHOTO-2026-07-09-16-40-08.jpg"     "$P/tile-matt-living.jpg"       362  483  110  20   # Oreal Matt ORM66002, 600x600
crop "$SRC/PHOTO-2026-07-09-16-41-44 2.jpg"   "$P/tile-outdoor.jpg"           362  487  128  28   # Oreal Matt ORM66011, 600x600
crop "$SRC/PHOTO-2026-07-09-16-41-44 3.jpg"   "$P/tile-office.jpg"            358  477  120  25   # Oreal Matt ORM66006, 600x600
crop "$SRC/IMG_3334.PNG"                      "$P/tile-kitchen-wall.jpg"      770 1012  748 138   # Gaoge TC48GG002P, 400x800
crop "$SRC/PHOTO-2026-07-28-12-06-49 28.jpg"  "$P/tile-bathroom-marble.jpg"   575  755  162  13   # Gaoge TC48GG025BP, 400x800
crop "$SRC/IMG_3344.PNG"                      "$P/tile-elevation.jpg"         944 1258 1440  14   # Time Ceramics TM36010, 300x600
crop "$ST/still-patterned-floor-tile.jpg"     "$P/tile-patterned.jpg"         810 1080  400   0   # real showroom footage

echo "Sanitary & fittings -> $OUT/sanitary"
S="$OUT/sanitary"
crop "$ST/still-gold-basin-gold-tap.jpg"      "$S/real-gold-basin.jpg"       1079 1080  269   0 1080 74
crop "$ST/still-chrome-tap-black-marble.jpg"  "$S/real-chrome-tap.jpg"       1080 1080  135   0 1080 74
crop "$SRC/PHOTO-2026-03-05-10-54-58.jpg"     "$S/fittings-black-gold.jpg"    296  885  667 377   # tap catalogue row "BS001 Black Gold"
crop "$SRC/PHOTO-2026-03-05-10-54-58.jpg"     "$S/fittings-grey.jpg"          298  885  357 378   # tap catalogue row "423 Grey"
echo "  (ai-*.jpg are Canva AI illustrations: not rebuilt here, see docs/HANDOFF.md)"

echo "Outlet gallery -> $OUT/showroom"
# Crops start at y=125 to cut off the caption text burned into the video frames.
for n in storefront-sign-clean showroom-aisle-depth showroom-seating-taps-wall showroom-decor-wall-upper; do
  crop "$ST/still-$n.jpg" "$OUT/showroom/$n.jpg" 481 855 125 112 1000 74
done

echo "Tile bond & grout -> $OUT/promo"
for n in glory-tile-bond-20kg oriel-tile-bond-20kg ornate-tile-grout-1kg; do   # Ornate Tile Bond is deliberately not used
  sips -s format jpeg -s formatOptions 76 --resampleHeight 1000 "$BOND/$n.jpg" --out "$OUT/promo/$n.jpg" >/dev/null
  echo "  $n.jpg"
done

echo "Done."
