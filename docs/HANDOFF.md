# Mumtaz Tile Zone website: where we left off (13 Oct 2026)

## Start here tomorrow

1. Preview the site. In Terminal, run:

   ```
   "$HOME/Downloads/mtz website/tools/serve.sh"
   ```

   (the quotes are needed because of the space in the folder name), then open http://127.0.0.1:8737.
   Or simply double-click `site/index.html`.
   In the Claude desktop app, `.claude/launch.json` only *attaches* to this running server. Its own preview server
   can't read `~/Downloads` (macOS privacy), so start `serve.sh` first.
2. Everything is saved in git (first commit, 13 Oct 2026). `git log` and `git diff` show what changes from here.
3. Read **Next steps** below and pick what to do first. AI assistants should also read `AGENTS.md`.

## What's done

`site/index.html` is a single-page site in the navy brand-kit style (Poppins, Midnight / Deep / Royal Navy).
Every WhatsApp button opens **0305-9252437** with a ready-made message. Sections, top to bottom
(the HTML comment in `site/index.html` is shown in brackets):

| Section | Content |
|---|---|
| Top bar + header (`Top bar`, `Header`) | address, phones, socials; logo; 7-link menu (hamburger at ≤1180 px) |
| Hero (`Hero`) | "Excellence in Every Tile", since 2000, a board of real product photos |
| Info strip (`Quick info`) | showroom address + directions, phones, socials |
| What we offer (`Products`) | trust strip (since 2000, 25+ years, imported, retail & wholesale) and Tiles / Sanitary ware / Bathroom fittings cards |
| Tile styles (`Tile styles`) | 12 real-photo cards with sizes from the catalogues; filters for floor, wall, bathroom, kitchen, living & office, outdoor |
| Sanitary ware & fittings (`Sanitary ware & fittings`) | 2 real showroom photos, 4 Canva AI illustrations (labelled "Illustration"), 2 faucet sets |
| Tile bond & grout (`Tile bond & grout`) | Glory Tile Bond, Oriel Tile Bond, Ornate Tile Grout, each with a WhatsApp "Ask for price" button |
| Tile calculator (`Tile calculator`) | floor/walls, ft/m, tiles + boxes, sends the estimate on WhatsApp |
| Inside our outlet (`Inside the outlet`) | the fittings-display video plus 4 showroom photos |
| Why choose us + store policy (`Why us + policy`) | 6 reasons; English + Urdu return policy from the invoice |
| About (`About`) | profile overview, vision, mission, values, who we serve, MD & CEO |
| Visit us (`Visit / contact`) | address, map (Khaki Shah Pull), socials, enquiry form → WhatsApp |
| CTA band (`CTA band`) | "Planning a new floor or bathroom?" with WhatsApp + Call buttons |
| Footer (`Footer`) | logo, links, contacts, socials; floating WhatsApp button |

It has been checked at screen widths from 320 to 1920 px: no sideways scrolling, no clipped buttons, all images load,
and there are no script errors. Several rounds of multi-agent review were run and their findings fixed.

## Decisions to keep

- **Brand:** follow the navy kit at `~/Downloads/MTZ LOGO/FINAL-BRAND-KIT/`. Never type "MUMTAZ" as a big heading;
  use the logo files. The magenta style in `~/mtz assets/00 BRAND/Brand-Style-Guide.md` is for social carousels only.
- **Honesty:** product facts come only from the company profile (`docs/company-profile.txt`) and what is printed on
  the packs or catalogue pages. No invented stats, prices, reviews or services.
- **Do not promote Ornate Tile Bond** (owner's instruction). Ornate Tile Grout is fine.
- **AI images** stay labelled "Illustration" until real photos replace them.
- **Map pin** uses "Khaki Shah Pull, Station Road, Khairpur Mirs". Searching "Soneri Bank Khairpur" finds the wrong branch.

## Canva status

- Uploaded to the owner's Canva account: the **old** bag photos with backgrounds removed (Glory `MAHX4POAT9o`,
  Oriel `MAHX4Fiu7gA`), from the uploads `MAHX4Aa4C6s` (Glory) and `MAHX4Cy2eQc` (Oriel), plus the white logo
  `MAHX4KOEuXY`.
- The 4 AI illustrations were generated in Canva: `MAHX4HMaApY` one-piece commode, `MAHX4MUIeCA` wall-hung,
  `MAHX4HLV1f0` vessel basin, `MAHX4AOsbsc` vanity set. The site uses 600 px previews. Export them from Canva if
  sharper versions are wanted.
- Design `DAHX4BDxL54` ("Facebook Cover – Premium Tiles"): an AI draft whose banner edits were **never saved**
  (the owner paused the work). Its saved version still has placeholder text. Reuse it or delete it.
- **No tile bond banner exists yet.** The website section works without it. Its slot is a commented-out `<img>` just
  below the "Tile bond & grout" intro (see `README.md` → Changing content).

## Next steps (owner to choose)

1. **Canva banner for Tile bond & grout** (2400 × 888 px), using the new mockups in `~/Downloads/bond moke up/`
   (Glory, Oriel, Ornate *grout* only; not `ornate-tile-bond-20kg.jpg`). Show a preview and get approval before
   saving in Canva.
2. **Real commode / basin / vanity photos** to replace the 4 illustrations (steps are in `README.md`).
3. **Confirm the calculator's "tiles per box" defaults** with real boxes in stock. They are typical values:
   - 60×60 → 4
   - 60×120 → 2
   - 80×80 → 3
   - 40×40 → 6
   - 40×80 → 4
   - 30×60 → 8
   - 30×30 → 11
   - 25×40 → 10
   - 20×30 → 17
   - 20×120 → 6
   - "Other size…" → 4

   These are the `data-ppb` values on the `<option>`s in `site/index.html`. If you change the 60×60 value, also change
   `value="4"` on `<input id="calc-ppb">` (the default shown on page load) and the test table below.
4. **Missing info from the owner:**
   - opening hours;
   - exact Google Maps pin;
   - permanent Facebook page address (the share link works for visitors, but search engines prefer the permanent one).
5. **Go live:**
   - upload the contents of `site/` (Netlify Drop is easiest; `docs/` and `tools/` are not part of the website);
   - domain **mumtaztilezone.com** is set up in the code (canonical, og tags, JSON-LD, `wrangler.jsonc`); hosting is the Cloudflare Worker `mumtaztilezone` built from GitHub;
   - set up a Google Business Profile that links to the site.
6. **Optional polish:**
   - The Oreal matt, office and outdoor photos come from small (720 px) WhatsApp images, so they're slightly soft on
     retina screens. The original catalogue files would be sharper.
   - `fittings-grey.jpg` shows thin red frame lines from the catalogue table.

## Where every photo came from

`tools/crop-images.sh` rebuilds the **23 cropped photos** (products, sanitary `real-*`/`fittings-*`, showroom,
promo) from the originals, with the exact crops. It was verified to reproduce them byte for byte. The rest are
listed below.

| Site file(s) | Source | How it was made |
|---|---|---|
| `assets/img/products/*` | `~/Downloads/mtz product picture/` (Time Ceramics, Oreal and Gaoge catalogue screenshots, the blue-slab showroom photo) and `~/mtz assets/04 PHOTOS/_stills-from-footage/still-patterned-floor-tile.jpg` | `crop-images.sh` |
| `assets/img/sanitary/real-*` | `~/mtz assets/04 PHOTOS/_stills-from-footage/` (gold basin, chrome tap stills) | `crop-images.sh` |
| `assets/img/sanitary/fittings-*` | `~/Downloads/mtz product picture/PHOTO-2026-03-05-10-54-58.jpg` (tap catalogue) | `crop-images.sh` |
| `assets/img/sanitary/ai-*` | Canva AI (see Canva status) | 600 px previews downloaded from Canva |
| `assets/img/showroom/*` | `~/mtz assets/04 PHOTOS/_stills-from-footage/still-*.jpg` | `crop-images.sh` (cropped below the burned-in caption) |
| `assets/img/promo/*` | `~/Downloads/bond moke up/` studio mockups | `crop-images.sh` (resized to 1000 px tall) |
| `assets/video/outlet-fittings.mp4` | `~/Downloads/mtz product picture/VIDEO-2026-07-28-12-08-43.mp4` | copied unchanged |
| `assets/video/outlet-poster.jpg` | first frame of that video (480 × 848) | `qlmanage -t -s 900 <video>`, then `sips -s format jpeg` |
| `assets/img/og-image.png` | brand kit `previews/1-business-card-front.png` | `sips --resampleWidth 1200`, then `--cropToHeightWidth 630 1200` |
| `favicon.ico`, `assets/img/favicon-32.png`, `favicon-64.png` | brand kit `logo/social/mumtaz-profile-picture-navy.png` | `sips -z 32 32` / `-z 64 64`; `.ico` via `sips -s format ico` |
| `assets/img/apple-touch-icon.png` | the same navy profile picture | `sips -z 180 180` |
| `assets/logo/*` | `~/Downloads/MTZ LOGO/FINAL-BRAND-KIT/logo/print-vector/` | copied unchanged (do not edit) |

## How it was tested (repeat after changes)

- Paste `tools/layout-audit.js` into the browser console at widths 320, 375, 768, 1024, 1181, 1366 and 1920.
  Every list should be empty, `overflowX` false, and the logo clear space at or above what's needed.
- Calculator spot-checks (defaults: 60×60, 4 per box, 10% extra):

  | Input | Expected |
  |---|---|
  | Floor 12 × 10 ft | 120.0 sq ft, 35 tiles, 9 boxes |
  | Same in metres | 11.15 m², still 35 / 9; switching back gives 12 × 10 exactly |
  | Walls 8 × 6 ft room, 8 ft high, minus 21 sq ft, 30×60 at 8/box | 203.0 sq ft, 116 tiles, 15 boxes |
  | Floor 15.5 × 13.25 ft, 80×80 at 3/box, 5% | 205.4 sq ft, 32 tiles, 11 boxes |
