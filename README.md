# Mumtaz Tile Zone & Sanitary Ware: website project

A one-page website built with plain HTML, CSS and JavaScript. It needs no build step and no framework.

> **Using an AI assistant?** Point it at `AGENTS.md` (Claude reads it through `CLAUDE.md`). It explains the project,
> the business and brand rules, how the code works and how to test. Status and next steps are in `docs/HANDOFF.md`.

```
site/                    THE WEBSITE: upload this folder's contents to go live
  index.html             the whole page (all text lives here)
  css/style.css          styles; brand colours are the variables at the top
  js/main.js             menu, tile filters, tile calculator, WhatsApp enquiry form
  favicon.ico            browser-tab icon
  404.html               "page not found" page (Cloudflare shows it for any address that does not exist)
  robots.txt, sitemap.xml  for Google: update <lastmod> in sitemap.xml when the page changes a lot
  _headers               Cloudflare cache rules (used on deploy)
  assets/logo/           official logo files from the brand kit (do not edit)
  assets/img/hero/       the big photo at the top (tall crop for phones, wide crop for larger screens)
  assets/img/looks/      tile-style card photos (in-stock designs, catalogue room scenes)
  assets/img/faces/      small tile-face swatches shown on the cards
  assets/img/products/   tiles-lead-* photo for the "Tiles" card (the old tile-*.jpg are no longer used)
  assets/img/sanitary/   real-* showroom photos, commode / basin / vanity product photos, fittings-* faucet sets
                         (the ai-* Canva illustrations are no longer used)
  assets/img/showroom/   the 3 photos in "Inside our outlet" (the storefront photo is no longer used)
  assets/img/promo/      Glory / Oriel tile bond and Ornate tile grout product photos
  assets/img/band/       the marble texture behind "Planning a new floor or bathroom?"
  assets/video/          outlet video and its poster image
  assets/img/            app icon, PNG favicon, 1200×630 social-share image
docs/
  HANDOFF.md             status, decisions, Canva state, photo sources, questions, next steps: start here
  company-profile.txt    text of the company profile (source for About / products)
tools/
  serve.sh               preview locally at http://127.0.0.1:8737
  imagetool.swift        the image tool the scripts below use (crops, AVIF + JPEG, PDF pages)
  catalogue-images.sh    rebuilds the catalogue photos (hero, tile cards, faces, Tiles card, CTA texture)
  sanitary-images.sh     rebuilds the commode, basin and vanity photos from the makers' pictures
  build-images.sh        makes the AVIF versions of the other photos
  crop-images.sh         rebuilds the JPEG crops of the owner's own photos
  layout-audit.js        paste into the browser console to check the layout at any width
```

## Preview

In Terminal run `"$HOME/Downloads/mtz website/tools/serve.sh"` (the quotes are needed because of the space in the
folder name), then open http://127.0.0.1:8737. Or simply double-click `site/index.html`.

## Changing content

- **Text:** edit `site/index.html`. Each section is marked with a comment such as `<!-- Tile styles -->`.
- **Photos:** see *Swapping a photo* below.
- **Tile-style cards:** the photo, name, size line, alt text and WhatsApp message must all describe the same design.
  Each card's `data-tags` is its look (`luxury`, `classic` or `simple`) plus its rooms; the visible list under the
  card shows only the rooms and must match. Details are in `AGENTS.md`.
- **Commodes, basins and vanities:** 8 product photos from the makers (Master; Dell for the wall-hung commodes).
  Each card names the model and has an "Ask for price" WhatsApp link. To change one, edit its line in
  `tools/sanitary-images.sh`, run it, and update the card in the "Sanitary ware & fittings" section (photo, name,
  model, alt text and WhatsApp message together). Your own photo of a model in stock can replace a maker's picture.
- **Tile bond banner (optional):** export it at 2400 × 888 px as `site/assets/img/promo/tile-bond-banner.jpg`.
  In the "Tile bond & grout" section, just below the intro, find the line `<!-- <img class="bond-banner" … -->` and
  delete only its `<!--` and `-->`. If the export is a different size, update its `width`/`height`.
- **Video:** add the new video (H.264 MP4, ideally under 10 MB) and its first-frame poster to `site/assets/video/`,
  then run `tools/build-images.sh` for the poster's AVIF versions. Use new file names (the 30-day cache again) and
  change them in the "Inside our outlet" section of `site/index.html` and in `tools/build-images.sh`. Also update the
  "33 s · 5.6 MB" label on the play button, the length in the `#outlet-video-desc` text, and the poster `<img>`
  `width`/`height`. The video only loads when a visitor taps "Play video"; its `width`/`height` are set in
  `site/js/main.js` ('video').

### Swapping a photo

Every photo on the page is a `<picture>`: one or more AVIF files (small and sharp, for modern browsers) and one
JPEG fallback (for older browsers). It looks like this:

```html
<picture>
  <source type="image/avif" sizes="(min-width: 1281px) 384px, (min-width: 700px) 31vw, 78vw"
          srcset="assets/img/looks/walnut-plank-360.avif 360w, assets/img/looks/walnut-plank-540.avif 540w, assets/img/looks/walnut-plank-720.avif 720w">
  <img src="assets/img/looks/walnut-plank-540.jpg" width="540" height="675" alt="…" loading="lazy" decoding="async">
</picture>
```

1. **Make the new files** with the scripts (see *Image scripts*), not by hand: add or change the photo's line in the
   right script and run it. You get the AVIF at each width plus the JPEG fallback, in sRGB, never enlarged.
2. **Give a new picture a new file name** (for example `walnut-plank2` instead of `walnut-plank` in the script line). Once the cache
   rules in `site/_headers` are live, browsers keep images for 30 days, so a file replaced under the same name can
   keep showing the old picture to returning visitors. Re-making the same picture (a better crop of the same photo)
   can keep its name; then only `width`/`height` change if the JPEG's pixel size changed.
3. **Edit the `<picture>`** in `site/index.html` when the names or widths change:
   - in `srcset`, list every AVIF file that exists, each followed by its pixel width and `w` (e.g. `540w`);
   - set the `<img>` `src` to the JPEG, and its `width`/`height` to that JPEG's exact pixel size;
   - the hero and the 3 wide tile cards have extra `<source media="(max-width: 699px)">` lines for phones. Each of
     those has its own `width`/`height`: update them too.
4. **Update the alt text** so it describes the new photo (the room, the tile and the size). If an AI image is ever used,
   start its alt text with "Illustration:" and show the "Illustration" badge.
5. **Check:** the longest side is at most 1000 px (the desktop hero up to 1920, the sanitary photos up to 1080).
   To read a file's size: `sips -g pixelWidth -g pixelHeight <file>`. Then preview the page and run the layout audit.

### Image scripts

All need only macOS with the Xcode Command Line Tools (`xcode-select --install`). They compile
`tools/imagetool.swift` themselves. Each takes an optional output folder, so you can try a change in a spare folder
before overwriting the site's files.

| Script | What it rebuilds | From |
|---|---|---|
| `tools/catalogue-images.sh` | hero, tile-style cards, tile faces, the Tiles card photo, the CTA texture (AVIF + JPEG) | the supplier catalogue PDFs in `~/Downloads` and three stock photos in `~/Downloads/Pics/` (one line per crop, with the printed design code) |
| `tools/sanitary-images.sh` | the 8 commode, basin and vanity photos (AVIF + JPEG) | the makers' pictures in `~/Downloads/Sanitary sources/master/` and `dell/` |
| `tools/crop-images.sh` | the JPEG crops of the owner's own photos: sanitary, showroom, tile bond packs, the old tile photos | `~/Downloads/mtz product picture/`, `~/mtz assets/04 PHOTOS/_stills-from-footage/`, `~/Downloads/bond moke up/` |
| `tools/build-images.sh` | the AVIF versions of those JPEGs, the 640 px `real-*` JPEGs and the video poster AVIFs | the JPEGs already in `site/assets/` (so run `crop-images.sh` first if you rebuilt them) |

`docs/HANDOFF.md` lists which catalogue PDF, page and design code each photo comes from.

## WhatsApp

All WhatsApp buttons go to **0305-9252437**. To change the number, edit `WA_NUMBER` at the top of
`site/js/main.js`, and the `https://wa.me/923059252437` links and form `action` in `site/index.html`
(use the 92 country code with no leading 0). The number also appears as visible text, in `tel:` links, in the
meta/og descriptions and in the JSON-LD, so search `site/index.html` for `0305-9252437`, `923059252437` and
`305-9252437` and replace every match.

The enquiry form and calculator don't store anything. They open WhatsApp with a ready-made message that the
customer sends themselves.

## Before going live

1. **Map pin:** for an exact pin, use Google Maps → **Share → Embed a map** and paste the `src` into the `<iframe>`
   inside `<template id="map-template">` in the "Visit us" section. Also update every directions link (the proof band
   under the hero, "Visit us", "Open in Google Maps", the phone action bar) and `"hasMap"` in the JSON-LD: search
   `site/index.html` for `Khaki+Shah+Pull`.
2. **Opening hours:** add them to the "Visit us" contact list.
3. **Facebook:** put the page's permanent address (e.g. `facebook.com/your-page-name`) in the JSON-LD `"sameAs"`.
4. **Domain:** the site is set up for **mumtaztilezone.com** (canonical, og:url, og:image and JSON-LD use it). If the domain changes, update those and `wrangler.jsonc`.

## Putting it online

**Live hosting: Cloudflare Workers.** `wrangler.jsonc` publishes only `site/` as the Worker `mumtaztilezone`
on mumtaztilezone.com and www.mumtaztilezone.com. Connect the Worker to this GitHub repo (Settings → Build) and every
push to `main` deploys automatically.

Any other static web host also works. Upload the **contents of `site/`** so `index.html` is at the top level.

- **Netlify Drop** (free): drag the `site` folder onto https://app.netlify.com/drop
- **GitHub Pages** (free): push the contents of `site/` to the root of a separate repository, or use a GitHub Actions
  Pages workflow with `path: site`. Don't choose the "/docs" option; that folder holds the project notes, not the site.
- **cPanel hosting**: upload the contents of `site/` into `public_html`
