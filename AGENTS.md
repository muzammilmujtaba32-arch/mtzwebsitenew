# AGENTS.md: guide for AI assistants working on this project

Read this file first, then `docs/HANDOFF.md` (current status, decisions and next steps).
`README.md` is the human-facing guide. This file explains how the project works and the rules to follow.

## What this is

The website of **Mumtaz Tile Zone & Sanitary Ware**, a tile and sanitary ware showroom on Station Road,
Khairpur Mirs, Sindh, Pakistan (established 2 January 2000). The owner, Muzammil Mujtaba (Managing Director),
is not a developer, so explain changes in plain language.

The site's job is to get local customers to **message the shop on WhatsApp** or visit the showroom.
There is no backend, no database, no build step and no framework: plain HTML, CSS and vanilla JavaScript.

## Layout

```
site/            the deployable website (upload the CONTENTS of this folder)
  index.html     the whole one-page site, including all copy, the JSON-LD and an inline SVG icon sprite
  css/style.css  all styles; design tokens are on :root at the top
  js/main.js     all behaviour, no dependencies
  _headers       Cloudflare cache rules (they only take effect on a deploy the owner approves)
  assets/        logo/ (brand kit SVGs), img/{hero,looks,faces,products,sanitary,showroom,promo,band}/, video/
docs/HANDOFF.md  status, decisions, Canva state, photo sources, owner questions, test values
docs/company-profile.txt   the owner's company profile (source of truth for business facts)
tools/serve.sh   local preview at http://127.0.0.1:8737
tools/imagetool.swift      macOS image tool (PDF pages, crops, AVIF + JPEG export, painting out); the scripts compile it
tools/catalogue-images.sh  rebuilds the catalogue images (hero, tile cards, tile faces, Tiles lead, CTA) from the supplier PDFs
                           and the owner's stock photos
tools/sanitary-images.sh   rebuilds the sanitary product photos (commodes, basins, vanities) from the makers' pictures
tools/build-images.sh      builds the AVIF versions of the other photos from their JPEGs
tools/crop-images.sh       rebuilds the JPEG crops of the owner's own photos (sanitary, showroom, promo, old products)
tools/layout-audit.js      console snippet: overflow / clipping / broken images / logo clear space
```

## Sources of truth (never invent facts)

| Topic | Source |
|---|---|
| Business facts, products, vision, mission, values, customers | `docs/company-profile.txt` |
| Brand (logo, colours, font, logo rules) | `~/Downloads/MTZ LOGO/FINAL-BRAND-KIT/mumtaz-brand-guide.png` and `logo/` |
| Product specs (sizes, uses, pack weights) | only what is printed on the pack or catalogue image |
| Store policy (English + Urdu) | the brand-kit invoice preview |
| "1,000,000+ customers served since 2000" | the owner (16 Oct 2026; see `docs/HANDOFF.md`) |
| Status and owner decisions | `docs/HANDOFF.md` |

Do not add stats, prices, reviews, testimonials, brands, delivery or installation services, or any other claim these
sources don't support. If something is unknown (opening hours, exact map pin, a permanent Facebook URL), leave it
out and list it as a question for the owner.

## Business rules from the owner

- **Do not promote Ornate Tile Bond** anywhere (site, Canva, social). Glory Tile Bond, Oriel Tile Bond and
  Ornate Tile Grout are fine.
- WhatsApp / phone: **0305-9252437** (primary, `wa.me/923059252437`) and 0301-8310850.
- Address: Station Road, Opposite Soneri Bank, Near Khaki Shah Pull, Khairpur Mirs. For maps, use the query
  "Khaki Shah Pull, Station Road, Khairpur Mirs"; "Soneri Bank Khairpur" resolves to the wrong branch.
- Socials:
  - Instagram @mumtaztilezone
  - TikTok @mumtaztilezones (with an s)
  - Facebook share link https://www.facebook.com/share/1DME8Le11h/
- Taglines: "Excellence in Every Tile" (brand kit) and "Giving your home a new & luxurious style" (profile).
- AI-generated images must stay visibly labelled "Illustration" (badge, plus an alt text starting "Illustration:")
  until real photos replace them. (None are on the page now: the sanitary section uses the makers' product photos.)
- The tile cards show only designs the shop has in stock (the owner's stock photos are in `~/Downloads/Pics/`).
  Sanitary product photos: commodes, wash basins and vanities from Master (mastersanitaryware.com), and only the
  wall-hung commodes from Dell (dellsanitary.com). No Indian (squat) toilets. The owner approved naming both brands
  on the cards ("Master · model OP-4").

## Brand rules

- Colours:
  - Midnight Navy `#010736`
  - Deep Navy `#0D1C42`
  - Royal Navy `#22396F`
  - White
  - neutral greys (`--mist`, `--line`)
- WhatsApp green `--wa: #15803D` is used only on WhatsApp buttons. It was darkened for contrast; don't lighten it.
- Font: **Poppins** (400/500/600; headings are 600, there is no 700). Urdu text uses Noto Naskh Arabic, with
  `lang="ur" dir="rtl"`. How they load: see *Fonts* below.
- No gold in the UI (gold appears only inside photos), no logo on a photo, no card shadows, lifts or image zooms.
- Logo:
  - Never retype "MUMTAZ" as styled text, and never put it in all-caps display text (including via
    `text-transform`). Use the logo SVGs.
  - No shadows, gradients, filters or recolouring on the logo.
  - Keep a quarter of the house-icon height clear around it.
  - Minimum 140 px wide. The header uses 172 px with an 84 px header; on mobile, 148 px with 72 px.
- The magenta palette in `~/mtz assets/00 BRAND/Brand-Style-Guide.md` is for social carousels only. Don't use it on the site.

## How the page is built

Sections in `site/index.html`, in order (each marked by an HTML comment):

| Section | Notes |
|---|---|
| top bar | Midnight; desktop only (hidden at ≤960) |
| header + nav | Midnight, with the reversed white logo; collapses to a hamburger at ≤1180 px |
| hero | full-bleed catalogue room scene (K-Gold); the only eager photo; no caption (owner, 16 Oct); its last row is the facts bar `.hero__facts` (Since 2000, 25+ years, 1,000,000+ customers, Imported, Retail & wholesale) |
| proof band (`.proof`) | address + directions, socials (the facts moved into the hero on 16 Oct) |
| `#collections` | 18 in-stock tile designs in three looks + filters; a swipe rail at ≤699 |
| `#products` | Tiles lead card + Sanitary ware and Bathroom fittings side cards |
| `#sanitary` | 2 real showroom photos, 8 maker product photos (commodes, wall-hung commodes, basins, vanities), 2 faucet sets |
| `#outlet` | Midnight; 3 showroom photos + video facade |
| `#tile-bond` | Glory, Oriel, Ornate grout; a swipe rail at ≤699 |
| `#calculator` | Deep Navy band with a white card |
| `#why` | features + `#policy` |
| `#about` | |
| `#visit` | contacts, map facade, enquiry form |
| CTA band | catalogue tile texture under a Midnight scrim |
| footer | |
| floating WhatsApp button | desktop only (≥961) |
| mobile action bar | ≤960 only: WhatsApp / Call / Directions |

Nav order (7 links, so the 1180 breakpoint still fits): Tile styles, Products, Sanitary ware, Tile bond, Calculator,
About us, Visit us. The footer "Explore" list follows the page order.

The proof band is a `div`, not a `section`, so the active-nav observer ignores it.

Key mechanisms:

- **WhatsApp links:** any element with `data-wa="message"` gets its `href` rebuilt by `main.js` as
  `https://wa.me/923059252437?text=…`. The plain `href` is the no-JS fallback. Messages start with
  "Assalam o Alaikum!" and name the product/size. Every button with `data-wa` is `.btn--wa` (green);
  link-arrows with `data-wa` stay navy.
- **Tile cards and filters:**
  - Each card belongs to one look: **Luxury**, **Classic** or **Simple** (the owner wants a range for every kind of
    customer). The look shows as `<p class="swatch-card__look">`, the first line of `.swatch-card__body`.
  - `data-tags` = the look + the rooms, e.g. `data-tags="luxury floor living"`. The visible `.tags` list shows only
    the rooms and must equal the room part of `data-tags` (Living & office maps to `living`).
  - Buttons `.chip[data-filter]` are one single-select group: All styles, then the look chips (Luxury, Classic,
    Simple), a decorative divider (`.filters__divider`), then the room chips. They show or hide
    `.swatch-card[data-tags]`.
  - Every filter should match at least 2 cards. Today: luxury 7, classic 5, simple 6; floor 15, wall 8, bathroom 3,
    kitchen 3, living 11, outdoor 2.
  - Card names, descriptions, size lines, alts, codes and WhatsApp messages come from what the catalogue page prints
    (see the photo-source table in `docs/HANDOFF.md`). The image, name, size, alt and message always describe the
    same article.
- **Wide cards:** `.swatch-card--wide` (living-blue-gold, kitchen-white-gold, split-brick) spans 2 of the 3 columns. DOM order equals
  visual order (no CSS `order`): at 3 columns the rows go wide+1 / 3 / 1+wide / 3 / wide+1 / 3 / 3, so 3 wide and
  15 normal cards fill 7 rows exactly. If you add or remove a card, re-plan the order so the rows still fill.
  When a filter other than "All styles" is on, JS adds `.is-filtered` to `.swatch-grid`: wide cards then take one
  column at 4:5, so a filtered grid has no holes. The same handler resets the rail to the first card and updates
  the count in the rail hint (`[data-rail-count]`).
- **`.rail` utility (≤699 only):** turns a grid (`.swatch-grid`, `.bond-grid`) into a native scroll-snap swipe
  rail, with no library. Its negative margin cancels the container padding exactly, so the page never scrolls
  sideways. Put `.reveal` on the rail itself, never on the cards inside it, or cards to the side could stay
  invisible. Above 699 the grid layout applies.
- **Calculator** (`#tile-calc`):
  - Tile sizes are `<option data-m2 data-ppb data-label>`. They hold m² per tile and tiles per box, copied from the
    shop's stock list (Nenosofts), sizes in inches. Don't recompute m² from the inch size: the shop's figures are
    nominal (e.g. 24×24″ = 0.36 m²), and the estimate must match what the shop bills.
  - Use `data-m2`, never `data-area`, on options: `data-area` marks the openings input for unit conversion.
  - "Other size…" is entered in inches (1–120) and converted at 0.00064516 m² per square inch.
  - The *Tiles per box* hint shows the box coverage (`#calc-ppb-hint`).
  - Measurements store an exact metric value in `data-base`, so feet↔metres switches never drift.
  - `measure()` uses that exact value until the user edits the field.
  - Results go to `#r-*`, errors to `#calc-message`, and screen readers get a debounced summary in `#calc-status`.
  - Units are rendered in `<span class="stat__unit">`.
- **Floating button and action bar:**
  - The round floating WhatsApp button is desktop-only (≥961). At ≤960 the action bar (`.action-bar`:
    WhatsApp / Call / Directions) replaces it.
  - Both share one observer: they hide while any `[data-hide-fab]` element (the hero actions and the full-width
    WhatsApp buttons) is on screen, so two WhatsApp buttons never show at once.
  - The bar also hides while the menu is open and while a text field has focus (`html.is-typing`; selects don't count).
  - Its columns use `minmax(0, …fr)`. To remove it (kill switch), delete its markup and the ≤960 CSS block marked
    in `style.css`; the floating button then works everywhere as before.
- **Video facade (`#outlet`):** `.video-facade` is a link to the mp4 with a poster image. Nothing else downloads
  until a tap; then the 'video' feature swaps in a `<video>`. Without JS the link opens the mp4. The label
  "33 s · 5.6 MB" must match the file (5,589,276 bytes); update it if the video changes.
- **Facts bar and count-up (hero):** `.hero__facts` is the hero's last row, so it is on the first screen; at ≥961
  the copy is centred in the space above it. The heading is capped at `8.5svh` and one height query
  (`min-width: 961px and max-height: 820px`) hides the lead's second sentence, so the bar still fits at 1366 × 768.
  Numbers in `[data-count-to]` (optional `data-count-from`, and `data-count-plain` for the year) count up once
  when half in view ('count up' in `main.js`, 1.8 s ease-out). The HTML holds the final values, which show as they
  are without JS or with reduced motion; screen readers get a visually-hidden copy of the final number.
- **Map facade (`#visit`):** `.map__facade` shows the place and "Open in Google Maps". The 'map' feature reveals
  "Show map here" (`#map-load`) and its note, which insert the iframe from `<template id="map-template">`. There is
  no Google request, script or cookie until that tap.
- **Outlet gallery:** exactly 3 real showroom photos (owner's choice): tile displays (full width, with the two men
  painted out), fittings wall, decor & wall tiles. The storefront photo is off the page; its file is kept.
- **Fonts (Option B, until the owner OKs downloading font files):**
  - `<head>` loads Poppins 400/500/600 from Google Fonts, with both preconnects. Noto Naskh is not in that link.
  - The 'urdu font' feature appends the Noto Naskh Arabic stylesheet and sets `html.ur-font` when `#policy` comes
    within 800 px, and on `beforeprint`. `.policy__ur` uses `--font-ur` only under `html.ur-font` (or without JS,
    where a `<noscript>` link loads the font).
  - Option A (self-hosted files in `site/assets/fonts/`, one origin) needs the owner's OK first.
- **Robustness:** each JS feature runs inside `safely(name, fn)` so one failure can't break the rest.
  `.reveal` scroll animations only apply when `<html class="js">` is set. A 3 s fallback in `<head>` removes it if
  `main.js` never finishes.
- **Accessibility:**
  - The skip link, `aria-expanded` on the menu toggle and the focus ring token `--focus` are deliberate; keep them.
  - Contrast was checked to WCAG AA.
  - External links get a hidden "(opens in a new tab)" added by JS.
  - The 'focus visibility' feature keeps keyboard focus clear of the sticky header and the action bar.

## Conventions

- Copy: sentence case for headings, buttons and nav; plain, short English; no exclamation marks in headings.
- Keep sizes together with non-breaking spaces: `600&nbsp;×&nbsp;1200&nbsp;mm`.
- **Images:**
  - Every photo is a `<picture>`: AVIF `<source>`(s) with `srcset` + exact `sizes`, and one JPEG fallback in the
    `<img>`.
  - Longest side ≤ 1000 px, except the desktop hero (up to 1920) and the sanitary photos (1080). Never upscale:
    drop any width the crop can't fill.
  - Every `<img>` has `width`/`height` equal to its own `src` file. Every art-directed `<source>` (one with
    `media`: the hero and the wide cards) carries its own `width`/`height` too.
  - Meaningful alt text; empty alt for the tile faces, the CTA texture and the video poster.
  - Only the hero photo is eager (`fetchpriority="high"`, no preload). Every other photo is
    `loading="lazy" decoding="async"`.
  - Once `site/_headers` is live, images and the video are cached for 30 days. Give a changed image a new file name
    (and update the `<picture>`), or returning visitors may keep seeing the old one.
  - Catalogue room scenes are supplier images: a note under the tile grid says so (the hero caption was removed at
    the owner's request on 16 Oct 2026). Never write "our showroom" about a catalogue image.
  - Widths per slot (use only files that exist; list the folder first: a crop narrower than 720 px has no 720 file):

    | Slot | AVIF widths | JPEG fallback (px) |
    |---|---|---|
    | hero, phones (`media="(max-width: 699px)"`) | `hero/hero-tall-{600,750}` | `hero-tall-750.jpg` 750×1000 |
    | hero, ≥700 | `hero/hero-wide-{1280,1600,1920}` | `hero-wide-1280.jpg` 1280×720 |
    | tile card (4:5) | `looks/<slug>-{360,540,720}` | `<slug>-540.jpg` 540×675 (the two stock-photo cards: 430 / 432 wide) |
    | wide tile card, ≥700 (5:3) | `looks/<slug>-{640,1000}` | `<slug>-1000.jpg` 1000×600 |
    | wide tile card, phones (4:5) | `looks/<slug>-m-{360,540,720}` | `<slug>-m-540.jpg` 540×675 |
    | tile face (not every card has one) | `faces/<slug>-128` | `<slug>-128.jpg` 128×128 |
    | Tiles lead card | `products/tiles-lead-{640,1000}` | `tiles-lead-800.jpg` 800×600 |
    | real sanitary photos (4:5) | `sanitary/real-*-{480,864}` | `real-*-640.jpg` 640×800 |
    | sanitary products (shown contained in a white square) | `sanitary/<product>` (one size, ≤600) | `<product>.jpg`, the same size |
    | faucet sets | `sanitary/fittings-*-885` | `fittings-*.jpg` 885 wide |
    | bond and grout packs | `promo/<pack>-{480,807}` | `<pack>.jpg` 807×1000 |
    | outlet photos | `showroom/<name>-{480,855}` | `<name>.jpg` 855×481 |
    | CTA band texture | `band/cta-640` | `cta-640.jpg` 640×427 |
    | video poster | `video/outlet-poster-{360,480}` | `outlet-poster.jpg` 480×848 |

- **Making images:** never by hand; add every new image to a script so it can be rebuilt.
  - `tools/imagetool.swift` does the work (CoreGraphics/ImageIO, no other dependencies). The scripts compile it
    with `swiftc`. `imagetool export <in> <x> <y> <w> <h> <maxpx> <out.jpg> <out.avif> [jpgQ avifQ]` crops
    (pixels, top-left origin), shrinks so the longest side is at most `maxpx` (never upscales) and writes sRGB
    JPEG + AVIF.
  - `tools/catalogue-images.sh`: the hero, tile cards, faces, Tiles lead and CTA texture, from the catalogue PDFs
    in `~/Downloads` (three cards come from the owner's stock photos in `~/Downloads/Pics/`). One line per crop.
    The source, page and printed article code of every slot are in the photo-source table in `docs/HANDOFF.md`;
    give each new crop a comment with its article code too.
  - `tools/sanitary-images.sh`: the 8 sanitary product photos, from the makers' pictures saved in
    `~/Downloads/Sanitary sources/{master,dell}/` (paints two printed model names out first).
  - `tools/build-images.sh`: the AVIF versions of the photos that keep their JPEGs (sanitary, packs, outlet photos,
    video poster), plus the 640 px `real-*` JPEGs.
  - `tools/crop-images.sh`: the JPEG crops of the owner's own photos, with `sips` (paints the two men out of the
    aisle still). Run it before `build-images.sh` if you rebuild those.
  - With plain `sips`, the crop offset is **Y first**: `sips -c HEIGHT WIDTH --cropOffset Y X in --out out`. There
    is no Node, ffmpeg or Python PIL on this Mac.
- CSS: use the tokens on `:root`. Single-column grids must be `minmax(0, 1fr)` (plain `1fr` caused mobile
  overflow); so must the action bar's columns.
- Breakpoints in use: 1180/1181 (nav), 1080, 960/961, 700–960, 640/641, 480, 400. 699 (rails, phone hero crop)
  and 1181 (desktop nav) are the edges of existing ranges, not new breakpoints. Don't add others. The one height
  query (`max-height: 820px`, hero only) is described under *Facts bar and count-up*.
- Keep the JS breakpoint `matchMedia('(max-width: 1180px)')` in sync with the CSS one.
- `index.html` loads `css/style.css?v=N` and `js/main.js?v=N`; bump N when you change either file.

## Running and testing

1. Preview with `tools/serve.sh`, then open http://127.0.0.1:8737. In the Claude desktop app, its own preview server
   can't read `~/Downloads` (macOS privacy): run `serve.sh` from a shell and attach `.claude/launch.json` by URL.
2. After changes, paste `tools/layout-audit.js` into the browser console at widths 320, 375, 768, 1024, 1181,
   1366 and 1920 (also 412, and landscape 800×360). Every list should be empty and `overflowX` false. It checks
   the proof band, the video and map facades and the action bar too. The Tiles lead photo is full-bleed on purpose
   at ≤640, so the audit skips it.
3. Calculator expected values are in `docs/HANDOFF.md`. Re-check them if `main.js` changes.
4. Also check: no console errors, `window.MTZ_READY === true`, and every local asset returns HTTP 200.
5. Network (DevTools, phone width, cache off): the hero is the only eager photo; there is no request to Google Maps
   before "Show map here", no video before "Play video" (the poster is a lazy image), and no Naskh font until the
   policy comes near.

## Canva (owner's account, connected via MCP)

Canva holds:
- uploads: the old bag photos with backgrounds removed, and the logo;
- the 4 AI sanitary illustrations;
- an **unsaved** banner draft (design `DAHX4BDxL54`).

IDs are in `docs/HANDOFF.md`. Always show the owner a preview and get explicit approval before saving (committing)
any Canva edit.

## Don'ts

- Don't add a build system, framework, tracking scripts or cookies without the owner asking.
- Don't put the owner's personal email or other private data on the site.
- Don't commit, push, deploy or publish anything without the owner's go-ahead.
- Don't edit the files in `site/assets/logo/` (they are the official brand kit).
