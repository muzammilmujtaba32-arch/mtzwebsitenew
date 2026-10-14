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
  assets/logo/           official logo files from the brand kit (do not edit)
  assets/img/products/   tile photos (cropped from supplier catalogues and showroom footage)
  assets/img/sanitary/   real-*.jpg showroom photos, ai-*.jpg Canva illustrations, fittings-*.jpg faucet sets
  assets/img/showroom/   photos for the "Inside our outlet" gallery
  assets/img/promo/      Glory / Oriel tile bond and Ornate tile grout product photos
  assets/video/          outlet video and its poster image
  assets/img/            app icon, PNG favicon, 1200×630 social-share image
docs/
  HANDOFF.md             status, decisions, Canva state, next steps: start here
  company-profile.txt    text of the company profile (source for About / products)
tools/
  serve.sh               preview locally at http://127.0.0.1:8737
  crop-images.sh         rebuilds the 23 cropped site photos from the original files
  layout-audit.js        paste into the browser console to check the layout at any width
```

## Preview

In Terminal run `"$HOME/Downloads/mtz website/tools/serve.sh"` (the quotes are needed because of the space in the
folder name), then open http://127.0.0.1:8737. Or simply double-click `site/index.html`.

## Changing content

- **Text:** edit `site/index.html`. Each section is marked with a comment such as `<!-- Tile styles -->`.
- **Tile photos:** replace the file in `site/assets/img/products/`. Keep photos landscape (about 4:3), around
  1000 px wide and under about 200 KB, and update the `<img>` `width`/`height` if the size changes.
- **Real commode / basin photos:** the four `site/assets/img/sanitary/ai-*.jpg` files are Canva illustrations.
  To swap in real photos:
  - change each `src` and its `width`/`height`;
  - remove `Illustration: ` from the `alt` text and the `<span class="badge">Illustration</span>`;
  - delete the "Illustrations show the styles we offer…" note.
- **Tile bond banner (optional):** export it at 2400 × 888 px as `site/assets/img/promo/tile-bond-banner.jpg`.
  In the "Tile bond & grout" section, just below the intro, find the line `<!-- <img class="bond-banner" … -->` and
  delete only its `<!--` and `-->`. If the export is a different size, update its `width`/`height`.
- **Video:** replace `site/assets/video/outlet-fittings.mp4` (H.264 MP4, ideally under 10 MB) and its poster
  `outlet-poster.jpg`. Then update the `<video>` `width`/`height` and the length in the `#outlet-video-desc` text.

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
   in the "Visit us" section. Also update the two "Get directions" links and `"hasMap"` in the JSON-LD.
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
