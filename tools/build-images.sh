#!/bin/bash
# Builds the AVIF versions (and the new 640 px JPEG fallbacks) of the photos that keep their existing JPEGs:
# sanitary real-* photos, ai-* illustrations (no longer on the page), fittings-* rows, the 3 bond/grout packs, the 3 outlet gallery photos
# and the video poster. The source is always the JPEG already in site/assets, so run tools/crop-images.sh first
# if you rebuild those. The new tile-style, hero, products and CTA images come from tools/catalogue-images.sh.
# Usage:  tools/build-images.sh [output-folder]      (default: site/assets, i.e. next to the JPEGs)
#         The output folder gets the same layout: img/sanitary, img/promo, img/showroom, video.
# Needs macOS with the Xcode command line tools (swiftc). No Python, no ffmpeg.
#
# imagetool export <in> <x> <y> <w> <h> <maxpx> <out.jpg> <out.avif> <jpgQ> <avifQ> crops (pixels, top-left origin),
# shrinks so the longest side is at most maxpx (never upscales) and writes a JPEG and an AVIF, both sRGB.
# Quality is 0-1 (AVIF 0.5 = "q50"). Existing JPEGs are never overwritten: unwanted outputs go to a temp folder.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/site/assets"
OUT="${1:-$SRC}"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

mkdir -p "$OUT/img/sanitary" "$OUT/img/promo" "$OUT/img/showroom" "$OUT/video"
swiftc -O "$ROOT/tools/imagetool.swift" -o "$TMP/imagetool"

px() { sips -g "pixel$2" "$1" | awk -v k="pixel$2:" '$1 == k { print $2 }'; }   # px <file> Width|Height

# avif <source.jpg> <out.avif> <maxpx> <quality>   whole frame, AVIF only
avif() {
  local s=$1 w h
  w=$(px "$s" Width); h=$(px "$s" Height)
  echo "  $(basename "$2")  $("$TMP/imagetool" export "$s" 0 0 "$w" "$h" "$3" "$TMP/x.jpg" "$2" 0.72 "$4")"
}

echo "Sanitary -> $OUT/img/sanitary"
S="$SRC/img/sanitary"; O="$OUT/img/sanitary"
# Real photos: 4:5 re-crop of the 1080 squares keeping the top (x=108 y=0 w=864 h=1080).
# real-gold-basin.jpg is 1080x1079, so its last row is stretched by 1 px to keep exact 4:5 sizes.
for n in real-gold-basin real-chrome-tap; do
  echo "  $n-480.avif  $("$TMP/imagetool" export "$S/$n.jpg" 108 0 864 1080  600 "$TMP/x.jpg" "$O/$n-480.avif" 0.72 0.5)"
  echo "  $n-864.avif  $("$TMP/imagetool" export "$S/$n.jpg" 108 0 864 1080 1080 "$TMP/x.jpg" "$O/$n-864.avif" 0.72 0.5)"
  echo "  $n-640.jpg  $("$TMP/imagetool" export "$S/$n.jpg" 108 0 864 1080  800 "$O/$n-640.jpg" "$TMP/x.avif" 0.72 0.5)"
done
for n in ai-commode-onepiece ai-commode-wallhung ai-basin-vessel ai-vanity-set; do   # Canva AI illustrations, 600x600
  avif "$S/$n.jpg" "$O/$n-600.avif" 600 0.5
done
for n in fittings-black-gold fittings-grey; do                                       # tap catalogue rows, 885 wide
  avif "$S/$n.jpg" "$O/$n-885.avif" 885 0.55
done

echo "Tile bond & grout -> $OUT/img/promo"
for n in glory-tile-bond-20kg oriel-tile-bond-20kg ornate-tile-grout-1kg; do   # Ornate Tile Bond is deliberately not used
  avif "$SRC/img/promo/$n.jpg" "$OUT/img/promo/$n-480.avif"  595 0.5            # 807x1000 -> 480x595
  avif "$SRC/img/promo/$n.jpg" "$OUT/img/promo/$n-807.avif" 1000 0.5
done

echo "Outlet gallery -> $OUT/img/showroom"
for n in showroom-aisle-depth showroom-seating-taps-wall showroom-decor-wall-upper; do   # not the storefront (off the page)
  avif "$SRC/img/showroom/$n.jpg" "$OUT/img/showroom/$n-480.avif" 480 0.5   # 855x481 -> 480x270
  avif "$SRC/img/showroom/$n.jpg" "$OUT/img/showroom/$n-855.avif" 855 0.5
done

echo "Video poster -> $OUT/video"
avif "$SRC/video/outlet-poster.jpg" "$OUT/video/outlet-poster-360.avif" 636 0.5   # 480x848 -> 360x636
avif "$SRC/video/outlet-poster.jpg" "$OUT/video/outlet-poster-480.avif" 848 0.5

echo "Done."
