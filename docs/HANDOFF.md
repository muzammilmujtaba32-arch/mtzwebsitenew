# Mumtaz Tile Zone website: where we left off (16 Oct 2026)

## Start here tomorrow

1. Preview the site. In Terminal, run:

   ```
   "$HOME/Downloads/mtz website/tools/serve.sh"
   ```

   (the quotes are needed because of the space in the folder name), then open http://127.0.0.1:8737.
   Or simply double-click `site/index.html`.
   In the Claude desktop app, `.claude/launch.json` only *attaches* to this running server. Its own preview server
   can't read `~/Downloads` (macOS privacy), so start `serve.sh` first.
2. The site is in git, but **the redesign of 15–16 Oct 2026 is not committed yet**: `git status` lists the changed and
   new files. Commit, push or deploy only with the owner's go-ahead (a push to `main` deploys the live site).
3. Read **Questions for the owner** and **Next steps** below. AI assistants should also read `AGENTS.md`.

## What's done

### The redesign (15 Oct 2026)

The page was redesigned so that the supplier catalogue photos carry the luxury, and everything around them stays
quiet, square-edged, navy and fast. Green appears only on WhatsApp buttons.

- **Hero:** a full-screen room scene from the Time Ceramics K-Gold catalogue (a kitchen-dining room with a
  black-and-gold marble floor inset framed by gold border tiles, and blue-and-gold marble columns). Phones get a tall
  crop, larger screens a wide one. The caption reads "Shown: K-Gold series border tiles, 120 × 600 mm · Catalogue image".
- **Tile styles now come first:** 18 cards, all designs the shop has in stock (16 Oct), in three looks:
  **Luxury** (7), **Classic** (5) and **Simple** (6). Look filters sit next to the room filters. Phones get a swipe
  rail; tablets and desktops get a 3-column grid with 3 wide room scenes. Each card shows the size, the rooms, a
  tile-face swatch (where the picture is sharp enough) and a WhatsApp link that names the design code.
- **Sanitary ware photos (16 Oct):** the 4 AI illustrations were replaced by 8 real product photos from the makers'
  websites, as the owner chose: one-piece commodes OP-4 and OP-13, pedestal basins BP-28 and Grace BP-10, vanity
  basins Pearl V-24 and Delta V-13 (all Master), and wall-hung commodes 005 and 07 (Dell). No Indian (squat) toilets.
  Each card names the brand and model and has an "Ask for price" WhatsApp link that names them too. The printed model names, drawings and spec tables
  are cut away; two names next to the product were painted out.
- **New:** a proof band under the hero (since 2000, address, directions, socials), replacing the info strip; a
  WhatsApp / Call / Directions bar at the bottom of phones and tablets, in place of the round button; "Plan your
  visit" in the outlet section; a note under the tile grid saying the room scenes are catalogue images.
- **Moved:** the outlet video and photos now come right after Sanitary ware, on a Midnight background.
- **Removed from the page** (the files are kept): the hero photo board, the info strip, the old 12 tile photos and the
  storefront photo.

### Faster page

- Only one image loads straight away: the hero. On a phone it is a 34–49 KB AVIF, where the old photo board was about
  844 KB.
- Every photo is AVIF with one JPEG fallback for older browsers, and every photo below the hero loads lazily.
- The 5.6 MB video loads only when "Play video" is tapped.
- Google Maps loads only when "Show map here" is tapped, so there is no Google request or cookie before that.
- Fonts: 3 Poppins weights instead of 4. The Urdu font (about 111 KB) loads only when the store policy comes near.
- Cache rules for Cloudflare are ready in `site/_headers`. They take effect on the next approved deploy.
- Base files today (gzip): HTML 19 KB, CSS 16 KB, JS 8 KB.

### Sections, top to bottom

The HTML comment in `site/index.html` is shown in brackets.

| Section | Content |
|---|---|
| Top bar + header (`Top bar`, `Header`) | Midnight masthead: address, phones, socials (top bar on desktop only); white logo; 7-link menu (hamburger at ≤1180 px) |
| Hero (`Hero`) | "Excellence in Every Tile", since 2000, WhatsApp + Visit buttons, both numbers, the K-Gold catalogue scene |
| Proof band (`Proof band`) | since 2000, 25+ years, imported, retail & wholesale; address + directions; socials |
| Tile styles (`Tile styles`) | 18 in-stock designs in Luxury / Classic / Simple; filters for the 3 looks and floor, wall, bathroom, kitchen, living & office, outdoor; "Send us a photo" |
| What we offer (`Products`) | Tiles (catalogue room scene) / Sanitary ware / Bathroom fittings cards |
| Sanitary ware & fittings (`Sanitary ware & fittings`) | 2 real showroom photos; 8 product photos from the makers (Master one-piece commodes, basins and vanity basins; Dell wall-hung commodes); 2 faucet sets |
| Inside our outlet (`Inside the outlet`) | 3 showroom photos and the fittings-display video (plays on tap) |
| Tile bond & grout (`Tile bond & grout`) | Glory Tile Bond, Oriel Tile Bond, Ornate Tile Grout, each with a WhatsApp "Ask for price" link |
| Tile calculator (`Tile calculator`) | floor/walls, ft/m, tiles + boxes, sends the estimate on WhatsApp |
| Why choose us + store policy (`Why us + policy`) | 6 reasons; English + Urdu return policy from the invoice |
| About (`About`) | profile overview, vision, mission, values, who we serve, MD & CEO |
| Visit us (`Visit / contact`) | address, map (loads on tap), socials, enquiry form → WhatsApp |
| CTA band (`CTA band`) | "Planning a new floor or bathroom?" with WhatsApp + Call buttons |
| Footer (`Footer`, `Mobile action bar`) | logo, links, contacts, socials; round WhatsApp button (desktop); WhatsApp / Call / Directions bar (≤960 px) |

Run the checks in **How to test** before the redesign goes live.

## Decisions to keep

- **Brand:** follow the navy kit at `~/Downloads/MTZ LOGO/FINAL-BRAND-KIT/`. Never type "MUMTAZ" as a big heading;
  use the logo files. The magenta style in `~/mtz assets/00 BRAND/Brand-Style-Guide.md` is for social carousels only.
- **Honesty:** product facts come only from the company profile (`docs/company-profile.txt`) and what is printed on
  the packs or catalogue pages. No invented stats, prices, reviews or services.
- **Catalogue images stay labelled:** "· Catalogue image" in the hero caption and the note under the tile grid.
  Never say "our showroom" about a catalogue image.
- **Do not promote Ornate Tile Bond** (owner's instruction). Ornate Tile Grout is fine.
- **AI images** stay labelled "Illustration" if they are ever used again (none are on the page now).
- **Only in-stock tiles get a card.** The owner's stock photos are in `~/Downloads/Pics/`.
- **Map pin** uses "Khaki Shah Pull, Station Road, Khairpur Mirs". Searching "Soneri Bank Khairpur" finds the wrong branch.

## Owner decisions (15 Oct 2026)

1. **Catalogue images on the website:** the owner asked for them ("use the picture in website"), so the
   supplier-permission question is closed.
2. **Outlet photos:** keep exactly 3: tile displays (the two men behind the far counter were painted out), the
   fittings wall, and decor & wall tiles. The storefront photo is off the page; its file is kept.
3. **A range for every customer:** the owner asked for "simple, luxury, decent" designs, so every tile card is
   Luxury, Classic or Simple, with a filter for each.
4. **Fonts, Option B:** no font files are downloaded (not approved yet). Poppins 400/500/600 come from Google Fonts;
   the Urdu font loads only near the store policy.
5. **Hero:** the Time Ceramics K-Gold scene.
6. **Built with the defaults:** the mobile action bar, the map and video that load on tap, and the cache rules in
   `site/_headers` (used only on an approved deploy).

## Owner decisions (16 Oct 2026)

1. **Footer marquee:** the owner added it; keep it.
2. **Only in-stock tiles:** the owner sent the stock photos (`~/Downloads/Pics/`). The cards keep KJ66006,
   KJ008B (K-Gold series), L4201 and 612GG510M, and the hero stays KJ006B; the other 14 cards were replaced with
   in-stock designs. Where the same page is in a catalogue PDF, the sharper PDF picture is used.
3. **Sanitary photos:** commodes, wash basins and vanities from Master (mastersanitaryware.com); only the wall-hung
   commodes from Dell (dellsanitary.com); no Indian toilet. The pictures were downloaded with the owner's OK into
   `~/Downloads/Sanitary sources/`.
4. **Speed first:** small files, lazy loading, no picture ever enlarged.
5. **Brand names on sanitary ware:** the owner said to name Master and Dell, so each card reads e.g.
   "Master · model OP-4", and the alt text and WhatsApp message name the brand too.

## Questions for the owner

1. **Sharper pictures for 3 designs:** TC48GG032P ("Calm white bathroom"), 612GY046 ("White marble, gold crackle")
   and 612QS041H ("Jet black & gold") come from the stock screenshots, because their room-scene pages are not in the
   catalogue PDFs in `~/Downloads` (the Glory and Qiangsheng 600 × 1200 PDFs we have show only the slabs). Two of
   them are only 430 px wide and have no tile-face swatch. Could you send the PDFs they came from (e.g. the Gaoge
   "40-80 … 3D" file)?
2. **May we download the font files?** Poppins and Noto Naskh are free (OFL licence). Hosting them on the site
   (Option A) removes the Google Fonts request and makes the first screen faster.
3. **Unused files:** the storefront photo (`site/assets/img/showroom/storefront-sign-clean.jpg`), the 12 old tile
   photos (`site/assets/img/products/tile-*.jpg`) and the 4 AI illustrations (`site/assets/img/sanitary/ai-*`) are
   no longer on the page. Delete them from `site/` (they stay in
   git history) or keep them? `tools/crop-images.sh` still rebuilds them. A sharp daytime storefront photo would be
   welcome.
4. **Mobile action bar:** do you like the WhatsApp / Call / Directions bar at the bottom of phones and tablets,
   instead of the round button? It can be removed quickly (see `AGENTS.md`, "Floating button and action bar").
5. **120 × 600 mm in inches:** the K-Gold border tiles (hero caption and the "Black & gold borders" card) show only
   "120 × 600 mm". Every other card also gives the size in inches, the way the shop names it (e.g. 24 × 24″). What
   does the shop call this size in inches?
6. **Still missing:**
   - opening hours;
   - exact Google Maps pin;
   - permanent Facebook page address (the share link works for visitors, but search engines prefer the permanent one).

## Canva status

- Uploaded to the owner's Canva account: the **old** bag photos with backgrounds removed (Glory `MAHX4POAT9o`,
  Oriel `MAHX4Fiu7gA`), from the uploads `MAHX4Aa4C6s` (Glory) and `MAHX4Cy2eQc` (Oriel), plus the white logo
  `MAHX4KOEuXY`.
- The 4 AI illustrations were generated in Canva: `MAHX4HMaApY` one-piece commode, `MAHX4MUIeCA` wall-hung,
  `MAHX4HLV1f0` vessel basin, `MAHX4AOsbsc` vanity set. They are no longer on the site (replaced by the makers'
  product photos on 16 Oct); the 600 px previews are still in `site/assets/img/sanitary/ai-*`.
- Design `DAHX4BDxL54` ("Facebook Cover – Premium Tiles"): an AI draft whose banner edits were **never saved**
  (the owner paused the work). Its saved version still has placeholder text. Reuse it or delete it.
- **No tile bond banner exists yet.** The website section works without it. Its slot is a commented-out `<img>` just
  below the "Tile bond & grout" intro (see `README.md` → Changing content).

## Next steps (owner to choose)

1. **Check the new tile cards and sanitary photos** (16 Oct), then answer the questions above.
2. **Go live:**
   - run the checks in **How to test**;
   - with the owner's go-ahead, commit and push. Hosting is the Cloudflare Worker `mumtaztilezone`, built from
     GitHub; domain **mumtaztilezone.com** is set up in the code (canonical, og tags, JSON-LD, `wrangler.jsonc`).
     Any static host also works: upload the contents of `site/` (`docs/` and `tools/` are not part of the website);
   - after the deploy, check the cache headers with `curl -I` and run Lighthouse on mobile (targets: Performance
     ≥ 90, LCP ≤ 2.5 s, CLS ≤ 0.05);
   - set up a Google Business Profile that links to the site.
3. **Canva banner for Tile bond & grout** (2400 × 888 px), using the new mockups in `~/Downloads/bond moke up/`
   (Glory, Oriel, Ornate *grout* only; not `ornate-tile-bond-20kg.jpg`). Show a preview and get approval before
   saving in Canva.
4. **Sanitary photos:** done with the makers' pictures (16 Oct). Your own photos of the models in stock can replace
   them later (steps are in `README.md`).
5. **Calculator sizes come from the shop's stock list** (Nenosofts, 14 Oct 2026): 23 sizes in inches, each with
   the system's own m² per tile and tiles per carton. The test entry "16004" was left out.
   - In `site/index.html` each is an `<option data-m2="…" data-ppb="…" data-label="…">` in `#calc-size`.
   - The "Box covers" hint under *Tiles per box* equals the stock list's *Ctn Meter*.
   - **When the stock list changes** (new size, new carton qty), update the same option. If the 24×24″ default changes,
     also update `value="4"` on `<input id="calc-ppb">` and the test table below.
   - "Other size…" takes the tile size in inches and defaults to 4 per box.
6. **Optional polish:** `fittings-grey.jpg` shows thin red frame lines from the catalogue table.

## Where every photo came from

### Catalogue images

`tools/catalogue-images.sh` rebuilds all of these with the exact crops: from the supplier PDFs in `~/Downloads`, or
(three cards) from the owner's stock photos in `~/Downloads/Pics/`. The PDFs are in three folders: `Time ceramics /`,
`Oriel/` and `Qiang sheng /` (two of the names end in a space, and so does `Pics `; the exact paths are in `pdf_for()`
in the script). *Page* is the page number in the PDF; *Article* is the code printed on that page. *Stock photo* is the
owner's picture in `Pics/` that shows the design is in stock. The tile-face swatch comes from the same page unless
noted.

| Slot (in `site/assets/img/`) | Look | Source | Page | Article | Size (mm) | Stock photo (`Pics/`) |
|---|---|---|---|---|---|---|
| Hero: `hero/hero-wide-*`, `hero/hero-tall-*` | | Time ceramics `TIME KJ-GOLD 120X600 30-11-24.pdf` | 18 | KJ006B (K-Gold series border tiles) | 120 × 600 | kept (owner) |
| Tiles lead card: `products/tiles-lead-*` | | Time ceramics `TIME-600600MM-FLOORTILES2026.1.10.pdf` | 57 | L62112 | 600 × 600 | `PHOTO-2026-09-27-17-06-07.jpg` |
| CTA band texture: `band/cta-640.*` | | Time ceramics `TIME-600600MM-FLOORTILES2026.1.10.pdf` | 58 | L62113 (tile face) | 600 × 600 | `PHOTO-2026-10-03-12-32-58.jpg` |
| Card 1 `living-blue-gold` (wide) | Luxury | Qiang sheng `16x32/Tc 16x32 full display .pdf` (Gaoge) | 28 | TC48GG029P | 400 × 800 | `IMG_3648.PNG` |
| Card 2 `white-marble` | Classic | Time ceramics `TIME-600600MM-FLOORTILES2026.1.10.pdf` | 23 | L62043 | 600 × 600 | `IMG_3679.PNG` |
| Card 3 `plain-beige` | Simple | Time ceramics `TIME-600600MM-FLOORTILES2026.1.10.pdf` | 15 | L62031 | 600 × 600 | `PHOTO-2026-10-03-12-37-41.jpg` |
| Card 4 `white-gold` | Luxury | Time ceramics `bf844c1d0ff51f79df43e08a04d063b4.pdf` | 5 | KJ66006 | 600 × 600 | kept (owner) |
| Card 5 `calacatta` | Classic | Time ceramics `TIME600x1200mm-FloorTiles2025.10.3.pdf` | 37 | L12065 | 600 × 1200 | `PHOTO-2026-10-12-16-18-12.jpg` |
| Card 6 `light-grey-matt` | Simple | Oriel `24x24 matt.pdf` | 6 | ORM66002 | 600 × 600 | `PHOTO-2026-09-27-17-06-05.jpg` |
| Card 7 `kitchen-white-gold` (wide) | Luxury | Qiang sheng `16x32/Tc 16x32 full display .pdf` (Gaoge) | 4 | TC48GG002P | 400 × 800 | `IMG_3642.PNG` |
| Card 8 `bath-white` | Classic | stock screenshot `IMG_3650.PNG` (page 31 of a Gaoge "40-80 … 3D" PDF we don't have) | | TC48GG032P | 400 × 800 | `IMG_3650.PNG` |
| Card 9 `bath-black-gold` | Luxury | Qiang sheng `16x32/Tc 16x32 full display .pdf` (Gaoge) | 17 | TC48GG017HP | 400 × 800 | `IMG_3645.PNG` |
| Card 10 `white-glossy` (no face) | Simple | Time ceramics `GLOSSY 400X400 26-05-09.pdf` | 6 | L4201 | 400 × 400 | kept (owner) |
| Card 11 `split-brick` (wide) | Simple | Time ceramics `Time Ceramic Candy Glazed 300600(26.03.01).pdf` | 12 | TM36020 | 300 × 600 | `PHOTO-2026-08-16-16-50-18 6.jpg` |
| Card 12 `walnut-plank` | Classic | Time ceramics `TIME-200X1200mm (8X48）-2025.9.23.pdf` | 14 (face: 15) | L21208 | 200 × 1200 | `PHOTO-2026-08-30-17-50-47 4.jpg` |
| Card 13 `navy-gold` | Luxury | Time ceramics `TIME-600600MM-FLOORTILES2026.1.10.pdf` | 58 | L62113 | 600 × 600 | `PHOTO-2026-10-03-12-32-58.jpg` |
| Card 14 `kitchen-gold-crackle` (no face) | Classic | stock photo `PHOTO-2026-09-15-11-30-25.jpg` (Glory) | | 612GY046 | 600 × 1200 | the same |
| Card 15 `matt-concrete` | Simple | Qiang sheng `2x4 matt/2x4 goage velvet matt.pdf` | 8 | 612GG510M | 600 × 1200 | kept (owner) |
| Card 16 `black-crackle` (no face) | Luxury | stock photo `PHOTO-2026-10-12-16-18-16 2.jpg` (Qiangsheng) | | 612QS041H | 600 × 1200 | the same |
| Card 17 `ledge-stone` | Simple | Time ceramics `Time Ceramic Candy Glazed 300600(26.03.01).pdf` | 15 | TM36023 | 300 × 600 | `PHOTO-2026-08-16-16-50-18 7.jpg` |
| Card 18 `gold-borders` (no face) | Luxury | Time ceramics `TIME KJ-GOLD 120X600 30-11-24.pdf` | 22 | KJ008B | 120 × 600 | kept (owner) |

Card files: `looks/<slug>-*` (wide cards also `looks/<slug>-m-*` for phones) and `faces/<slug>-128.*`. Cards are
listed in page order. The 14 cards replaced on 16 Oct (blue-gold, classic-white, ivory, matt-beige, kitchen,
black-gold, light-grey, wood, outdoor, bathroom, bath-walls, office, medallion, elevation) were never live; their files
were moved out of `site/`.

### Other photos and files

`tools/crop-images.sh` makes the JPEG crops of the owner's own photos; then `tools/build-images.sh` makes their AVIF
versions (and the 4:5 `real-*-640.jpg`). Run them in that order. Each script takes an optional output folder, so you
can compare before overwriting.

| Site file(s) | Source | How it was made |
|---|---|---|
| `assets/img/products/tile-*.jpg` (no longer on the page) | `~/Downloads/mtz product picture/` (catalogue screenshots, the blue-slab showroom photo) and `~/mtz assets/04 PHOTOS/_stills-from-footage/still-patterned-floor-tile.jpg` | `crop-images.sh` |
| `assets/img/sanitary/real-*` | `~/mtz assets/04 PHOTOS/_stills-from-footage/` (gold basin, chrome tap stills) | `crop-images.sh` (1080 squares); `build-images.sh` (4:5 crops: `-640.jpg`, `-480/-864.avif`). The squares are not on the page, but they are the source of the 4:5 files: keep them |
| `assets/img/sanitary/fittings-*` | `~/Downloads/mtz product picture/PHOTO-2026-03-05-10-54-58.jpg` (tap catalogue) | `crop-images.sh`; AVIF by `build-images.sh` |
| `assets/img/sanitary/{commode,wall-hung,basin,vanity}-*` | the makers' product pictures, downloaded 16 Oct 2026 with the owner's OK into `~/Downloads/Sanitary sources/`: `master/` (mastersanitaryware.com: OP-4, OP-13, BP-28, Grace BP-10, Pearl V-24, Delta V-13) and `dell/` (dellsanitary.com: wall-hung 005 and 07) | `tools/sanitary-images.sh` (crops away the printed names, drawings and spec tables; paints out the model names on OP-13 and V-13; JPEG + AVIF, never enlarged) |
| `assets/img/sanitary/ai-*` (no longer on the page) | Canva AI (see Canva status) | 600 px previews downloaded from Canva; AVIF by `build-images.sh` |
| `assets/img/showroom/*` | `~/mtz assets/04 PHOTOS/_stills-from-footage/still-*.jpg` | `crop-images.sh` (cropped below the burned-in caption; the two men painted out of `showroom-aisle-depth` with `imagetool rowfill`); AVIF by `build-images.sh`. `storefront-sign-clean.jpg` is no longer on the page |
| `assets/img/promo/*` | `~/Downloads/bond moke up/` studio mockups | `crop-images.sh` (resized to 1000 px tall); AVIF by `build-images.sh` |
| `assets/video/outlet-fittings.mp4` | `~/Downloads/mtz product picture/VIDEO-2026-07-28-12-08-43.mp4` | copied unchanged |
| `assets/video/outlet-poster.jpg` | first frame of that video (480 × 848) | `qlmanage -t -s 900 <video>`, then `sips -s format jpeg`; AVIF by `build-images.sh` |
| `assets/img/og-image.png` | brand kit `previews/1-business-card-front.png` | `sips --resampleWidth 1200`, then `--cropToHeightWidth 630 1200` |
| `favicon.ico`, `assets/img/favicon-32.png`, `favicon-64.png` | brand kit `logo/social/mumtaz-profile-picture-navy.png` | `sips -z 32 32` / `-z 64 64`; `.ico` via `sips -s format ico` |
| `assets/img/apple-touch-icon.png` | the same navy profile picture | `sips -z 180 180` |
| `assets/logo/*` | `~/Downloads/MTZ LOGO/FINAL-BRAND-KIT/logo/print-vector/` | copied unchanged (do not edit) |

## How to test (repeat after changes)

- Paste `tools/layout-audit.js` into the browser console at widths 320, 375, 768, 1024, 1181, 1366 and 1920, plus
  412 and landscape 800 × 360. Every list should be empty, `overflowX` false, and the logo clear space at or above
  what's needed.
- No console errors, `window.MTZ_READY === true`, and every local asset returns HTTP 200.
- **Tile filters:** each chip shows the right number of cards: Luxury 7, Classic 5, Simple 6, Floor 15, Wall 8,
  Bathroom 3, Kitchen 3, Living & office 11, Outdoor 2. A filtered grid has no holes. On a phone the rail jumps back
  to the first card and "Swipe to see all N styles" shows the new number.
- **WhatsApp:** every button and link (the action bar too) opens 0305-9252437 with a message that names the product.
- **Phones and tablets (≤960 px):** the action bar is hidden while the hero buttons or a full-width WhatsApp button
  are on screen, while the menu is open and while typing in the form. The round button shows only on desktop.
- **Video:** "Play video" swaps in the video and plays it. Without JavaScript the link opens the mp4.
- **Map:** no request to Google until "Show map here" is tapped; then the map appears. "Open in Google Maps" always works.
- **Urdu policy:** shows in Noto Naskh once you scroll near it, and in print preview.
- **Without JavaScript:** all content is visible and the hero, cards and links work.
- **Print preview:** the logo shows on the navy header, text is black, photo layers are hidden.
- **Calculator spot-checks** (default size 24×24″, 4 per box, 10% extra), verified against hand calculations
  (unchanged by the redesign):

  | Input | Expected |
  |---|---|
  | Floor 12 × 10 ft | 120.0 sq ft, 35 tiles, 9 boxes (covers 12.96 m²) |
  | Same in metres | 11.15 m², still 35 / 9; switching back gives 12 × 10 exactly |
  | Walls 8 × 6 ft room, 8 ft high, minus 21 sq ft, 12×24″ · 8/box | 203.0 sq ft, 116 tiles, 15 boxes |
  | Floor 15.5 × 13.25 ft, 16×32″ · 7/box, 5% | 205.4 sq ft, 63 tiles, 9 boxes (box covers 2.24 m²) |
  | Floor 10 × 12 ft, 9×17″ · 15/box | 129 tiles, 9 boxes (box covers 1.43 m²) |
  | Floor 12 × 10 ft, 24×24″ Forte · 4/box | 32 tiles, 8 boxes (box covers 1.58 m²) |
  | Floor 20 × 15 ft, 17×17″ · 9/box, 15% | 181 tiles, 21 boxes (box covers 1.60 m²) |
