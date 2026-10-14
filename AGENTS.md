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
  assets/        logo/ (brand kit SVGs), img/{products,sanitary,showroom,promo}/, video/
docs/HANDOFF.md  status, decisions, Canva state, the prioritised to-do list, test values
docs/company-profile.txt   the owner's company profile (source of truth for business facts)
tools/serve.sh   local preview at http://127.0.0.1:8737
tools/crop-images.sh       rebuilds every site photo from the owner's originals (exact crops)
tools/layout-audit.js      console snippet: overflow / clipping / broken images / logo clear space
```

## Sources of truth (never invent facts)

| Topic | Source |
|---|---|
| Business facts, products, vision, mission, values, customers | `docs/company-profile.txt` |
| Brand (logo, colours, font, logo rules) | `~/Downloads/MTZ LOGO/FINAL-BRAND-KIT/mumtaz-brand-guide.png` and `logo/` |
| Product specs (sizes, uses, pack weights) | only what is printed on the pack or catalogue image |
| Store policy (English + Urdu) | the brand-kit invoice preview |
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
  until real photos replace them.

## Brand rules

- Colours:
  - Midnight Navy `#010736`
  - Deep Navy `#0D1C42`
  - Royal Navy `#22396F`
  - White
  - neutral greys (`--mist`, `--line`)
- WhatsApp green `--wa: #15803D` is used only on WhatsApp buttons. It was darkened for contrast; don't lighten it.
- Font: **Poppins**. Urdu text uses Noto Naskh Arabic, with `lang="ur" dir="rtl"`.
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
| top bar | |
| header + nav | collapses to a hamburger at ≤1180 px |
| hero | |
| info strip | |
| `#products` | trust strip and 3 product cards |
| `#collections` | 12 tile-style cards + filters |
| `#sanitary` | |
| `#tile-bond` | |
| `#calculator` | |
| `#outlet` | video + gallery |
| `#why` | features + `#policy` |
| `#about` | |
| `#visit` | contacts, map, enquiry form |
| CTA band | |
| footer | |
| floating WhatsApp button | |

Key mechanisms:

- **WhatsApp links:** any element with `data-wa="message"` gets its `href` rebuilt by `main.js` as
  `https://wa.me/923059252437?text=…`. The plain `href` is the no-JS fallback. Messages start with
  "Assalam o Alaikum!" and name the product/size.
- **Tile filters:** buttons `.chip[data-filter]` show or hide `.swatch-card[data-tags]`. Keep each card's visible
  `.tags` list in sync with its `data-tags` (Living & office maps to `living`). Every filter should match at least 2 cards.
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
- **Floating WhatsApp button** hides while any `[data-hide-fab]` element (full-width WhatsApp buttons) is on screen.
- **Robustness:** each JS feature runs inside `safely(name, fn)` so one failure can't break the rest.
  `.reveal` scroll animations only apply when `<html class="js">` is set. A 3 s fallback in `<head>` removes it if
  `main.js` never finishes.
- **Accessibility:**
  - The skip link, `aria-expanded` on the menu toggle and the focus ring token `--focus` are deliberate; keep them.
  - Contrast was checked to WCAG AA.
  - External links get a hidden "(opens in a new tab)" added by JS.

## Conventions

- Copy: sentence case for headings, buttons and nav; plain, short English; no exclamation marks in headings.
- Keep sizes together with non-breaking spaces: `600&nbsp;×&nbsp;1200&nbsp;mm`.
- Images: JPEG, longest side ≤ 1000 px (sanitary features up to 1080), never upscaled. Every `<img>` has
  `width`/`height` matching the file's pixel size, plus meaningful alt text (empty alt for decorative images).
  Below-the-fold images use `loading="lazy"`.
- To crop on macOS, use `sips -c HEIGHT WIDTH --cropOffset Y X in --out out` (offset is **Y first**). There is no
  Node, ffmpeg or Python PIL on this Mac. Add new crops to `tools/crop-images.sh` so they're reproducible.
- CSS: use the tokens on `:root`. Single-column grids must be `minmax(0, 1fr)` (plain `1fr` caused mobile
  overflow). Breakpoints in use: 1180 (nav), 1080, 960, 700–960, 640, 480, 400, 360.
- Keep the JS breakpoint `matchMedia('(max-width: 1180px)')` in sync with the CSS one.

## Running and testing

1. Preview with `tools/serve.sh`, then open http://127.0.0.1:8737. In the Claude desktop app, its own preview server
   can't read `~/Downloads` (macOS privacy): run `serve.sh` from a shell and attach `.claude/launch.json` by URL.
2. After changes, paste `tools/layout-audit.js` into the browser console at widths 320, 375, 768, 1024, 1181,
   1366 and 1920. Every list should be empty and `overflowX` false.
3. Calculator expected values are in `docs/HANDOFF.md`. Re-check them if `main.js` changes.
4. Also check: no console errors, `window.MTZ_READY === true`, and every local asset returns HTTP 200.

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
