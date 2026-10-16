#!/bin/bash
# Rebuilds the website's catalogue images (hero, tile-style cards, tile-face swatches, the Tiles lead photo and the
# CTA texture) from the owner's supplier catalogues, with the exact crops used on the site.
# Usage:  tools/catalogue-images.sh [output-folder]      (default: site/assets/img)
# Needs macOS only: it compiles tools/imagetool.swift with swiftc (Xcode Command Line Tools).
#
# How it works: every catalogue page is one embedded photo. `imagetool images` saves that photo as it is stored in
# the PDF (JPEG streams are copied byte for byte; other formats are rendered at the photo's own size), and
# `imagetool export` crops it (x y w h in that photo's pixels, top-left origin), resizes without ever upscaling,
# and writes AVIF plus a JPEG fallback in sRGB. A width ending in "j" is the JPEG fallback; the others are AVIF.
# Crops cut out supplier logos, article codes, label bars and page frames. Each line notes the printed article.
# The tile cards show designs the shop has in stock (the owner's stock photos are in ~/Downloads/Pics/). Where the
# same page is in a catalogue PDF, the crop comes from the PDF (sharper); three come from the stock photos themselves.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/site/assets/img}"
DL="$HOME/Downloads"
PICS="$DL/Pics "        # the owner's stock photos (the folder name ends in a space)
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
swiftc -O "$ROOT/tools/imagetool.swift" -o "$TMP/imagetool"
IT="$TMP/imagetool"

# source id -> catalogue PDF (relative to ~/Downloads)
pdf_for() {
  case "$1" in
    kj-gold)       echo "Time ceramics /TIME KJ-GOLD 120X600 30-11-24.pdf" ;;
    glossy-400)    echo "Time ceramics /GLOSSY 400X400 26-05-09.pdf" ;;
    k-gold-66)     echo "Time ceramics /bf844c1d0ff51f79df43e08a04d063b4.pdf" ;;
    time-600)      echo "Time ceramics /TIME-600600MM-FLOORTILES2026.1.10.pdf" ;;
    time-612)      echo "Time ceramics /TIME600x1200mm-FloorTiles2025.10.3.pdf" ;;
    time-8x48)     echo "Time ceramics /TIME-200X1200mm (8X48）-2025.9.23.pdf" ;;
    candy)         echo "Time ceramics /Time Ceramic Candy Glazed 300600(26.03.01).pdf" ;;
    oreal-24-matt) echo "Oriel/24x24 matt.pdf" ;;
    qs-velvet)     echo "Qiang sheng /2x4 matt/2x4 goage velvet matt.pdf" ;;
    gaoge-16x32)   echo "Qiang sheng /16x32/Tc 16x32 full display .pdf" ;;
    *) echo "unknown source $1" >&2; exit 1 ;;
  esac
}

# photo <source> <page>: path of the page's embedded photo (cached in $TMP)
photo() {
  local pdf="$DL/$(pdf_for "$1")" pre="$TMP/$1-p$2" info fmt wh w h
  if ! ls "$pre"-*.jpg >/dev/null 2>&1; then
    info=$("$IT" images "$pdf" "$2" "$pre" | awk -F'\t' '$2=="Image"' | sort -t$'\t' -k5 -nr | head -1)
    fmt=$(cut -f4 <<<"$info"); wh=$(cut -f3 <<<"$info")
    if [ "$fmt" != "jpeg" ]; then
      w=${wh%x*}; h=${wh#*x}
      "$IT" page "$pdf" "$2" $(( w > h ? w : h )) "$pre-render-$wh.jpg" >/dev/null
    fi
  fi
  ls "$pre"-*.jpg | head -1
}

# crop_file <folder> <name> <image file> <x> <y> <w> <h> <avifQ> <jpegQ> <width>...
crop_file() {
  local dir=$1 name=$2 src=$3 x=$4 y=$5 w=$6 h=$7 aq=$8 jq=$9; shift 9
  mkdir -p "$OUT/$dir"
  for spec in "$@"; do
    local W=${spec%j} H max
    if (( W > w )); then echo "  skip $name-$W (crop is $w wide)"; continue; fi
    H=$(( (W * h + w / 2) / w )); max=$(( W > H ? W : H ))
    "$IT" export "$src" "$x" "$y" "$w" "$h" "$max" "$TMP/o.jpg" "$TMP/o.avif" "$jq" "$aq" >/dev/null
    if [ "$spec" != "$W" ]; then mv "$TMP/o.jpg" "$OUT/$dir/$name-$W.jpg"; echo "  $dir/$name-$W.jpg"
    else mv "$TMP/o.avif" "$OUT/$dir/$name-$W.avif"; echo "  $dir/$name-$W.avif"; fi
  done
}

# crop <folder> <name> <source> <page> <x> <y> <w> <h> <avifQ> <jpegQ> <width>...   (a catalogue PDF page)
crop() {
  local dir=$1 name=$2 src; src=$(photo "$3" "$4"); shift 4
  crop_file "$dir" "$name" "$src" "$@"
}

echo "Hero"
# KJ006B, K-Gold series border tiles 120 x 600 mm, polish/PGVT (kitchen-dining with a black-and-gold floor inset)
crop hero hero-wide  kj-gold 18  656  825 2208 1242 0.40 0.6  1280 1600 1920 1280j   # 16:9, desktop
crop hero hero-tall  kj-gold 18 1610  900  945 1260 0.42 0.6  600 750 750j           # 3:4, phones

echo "Products: Tiles lead"
crop products tiles-lead time-600 57    0   60 2362 1771 0.38 0.62 640 1000 800j    # L62112, 600 x 600 (book-matched -1/-2)

echo "CTA band texture"
crop band cta time-600 58            1250 2700  900  600 0.4 0.6  640 640j           # L62113 face, 600 x 600

echo "Tile-style cards (4:5; wide cards also 5:3 desktop + -m 4:5 phone), in page order"
crop looks living-blue-gold     gaoge-16x32 28    0  340 1368  821 0.5 0.72  640 1000 1000j  # TC48GG029P, 400 x 800
crop looks living-blue-gold-m   gaoge-16x32 28  430  266  832 1040 0.5 0.72  360 540 720 540j
crop looks white-marble         time-600 23     384    0 1520 1900 0.5 0.72  360 540 720 540j  # L62043, 600 x 600
crop looks plain-beige          time-600 15     842    0 1520 1900 0.5 0.72  360 540 720 540j  # L62031, 600 x 600
crop looks white-gold           k-gold-66 5      80    0 1540 1925 0.47 0.72 360 540 720 540j  # KJ66006, 600 x 600
crop looks calacatta            time-612 37     295 2655  710  888 0.5 0.72  360 540 540j      # L12065, 600 x 1200
crop looks light-grey-matt      oreal-24-matt 6  64  529  878 1098 0.5 0.72  360 540 720 540j  # ORM66002, 600 x 600 matt
crop looks kitchen-white-gold   gaoge-16x32 4     0  470 1368  821 0.5 0.72  640 1000 1000j  # TC48GG002P, 400 x 800
crop looks kitchen-white-gold-m gaoge-16x32 4   200  266  832 1040 0.5 0.72  360 540 720 540j
crop_file looks bath-white "$PICS/IMG_3650.PNG" 140 750 768 960 0.5 0.72 360 540 720 540j  # TC48GG032P, 400 x 800 (stock screenshot; not in our PDFs)
crop looks bath-black-gold      gaoge-16x32 17  330  266  811 1014 0.42 0.7  360 540 720 540j  # TC48GG017HP, 400 x 800
crop looks white-glossy         glossy-400 6    612   52  968 1210 0.5 0.72  360 540 720 540j  # L4201, 400 x 400 ceramic, glossy
crop looks split-brick          candy 12          0 1560 1289  773 0.42 0.7  640 1000 1000j    # TM36020, 300 x 600 punch candy glazed
crop looks split-brick-m        candy 12        200 1410  926 1157 0.42 0.7  360 540 720 540j
crop looks walnut-plank         time-8x48 14   1134  130 2315 2894 0.5 0.72  360 540 720 540j  # L21208, 200 x 1200 glossy
crop looks navy-gold            time-600 58     842    0 1520 1900 0.4 0.66  360 540 720 540j  # L62113, 600 x 600
crop_file looks kitchen-gold-crackle "$PICS/PHOTO-2026-09-15-11-30-25.jpg" 160 166 430 538 0.5 0.72 360 430 430j  # 612GY046, 600 x 1200 (stock photo)
crop looks matt-concrete        qs-velvet 8     137  300  784  980 0.5 0.72  360 540 720 540j  # 612GG510M, 600 x 1200 velvet matt
crop_file looks black-crackle "$PICS/PHOTO-2026-10-12-16-18-16 2.jpg" 120 86 432 540 0.5 0.72 360 432 432j  # 612QS041H, 600 x 1200 (stock photo)
crop looks ledge-stone          candy 15          0 1440  745  931 0.5 0.72  360 540 720 540j  # TM36023, 300 x 600 punch candy glazed
crop looks gold-borders         kj-gold 22      700  290 1408 1760 0.5 0.72  360 540 720 540j  # KJ008B, K-Gold border 120 x 600, polish/PGVT

echo "Tile-face swatches (shown at 64 px; the two stock-photo cards have faces too small for 128 px, so none)"
crop faces living-blue-gold     gaoge-16x32 28  160 1415  200  200 0.55 0.8 128 128j
crop faces white-marble         time-600 23    1560 2620  380  380 0.55 0.8 128 128j
crop faces plain-beige          time-600 15    1400 2720  600  600 0.55 0.8 128 128j
crop faces white-gold           k-gold-66 5     200 2200  820  820 0.55 0.8 128 128j
crop faces calacatta            time-612 37     100 1850  240  240 0.55 0.8 128 128j
crop faces light-grey-matt      oreal-24-matt 6 1880 880  500  500 0.55 0.8 128 128j
crop faces kitchen-white-gold   gaoge-16x32 4   640 1405  220  220 0.55 0.8 128 128j
crop_file faces bath-white "$PICS/IMG_3650.PNG" 200 1810 200 200 0.55 0.8 128 128j
crop faces bath-black-gold      gaoge-16x32 17  150 1415  200  200 0.55 0.8 128 128j
crop faces split-brick          candy 12        700  390  270  270 0.55 0.8 128 128j
crop faces walnut-plank         time-8x48 15   2706  600  280  280 0.55 0.8 128 128j     # face is on page 15
crop faces navy-gold            time-600 58    1300 2600  400  400 0.55 0.8 128 128j
crop faces matt-concrete        qs-velvet 8     200 1414  200  200 0.55 0.8 128 128j
crop faces ledge-stone          candy 15        700  390  270  270 0.55 0.8 128 128j

echo "Done."
