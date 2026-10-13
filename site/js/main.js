/* Mumtaz Tile Zone & Sanitary Ware — site behaviour (no dependencies) */
(function () {
  'use strict';

  var WA_NUMBER = '923059252437'; // 0305-9252437 in international format
  var M_PER_FT = 0.3048;
  var M2_PER_SQFT = M_PER_FT * M_PER_FT;
  var NBSP = ' ';

  function waLink(message) {
    return 'https://wa.me/' + WA_NUMBER + (message ? '?text=' + encodeURIComponent(message) : '');
  }

  function $(sel, root) { return (root || document).querySelector(sel); }
  function $all(sel, root) { return Array.prototype.slice.call((root || document).querySelectorAll(sel)); }

  // Fixed decimals, e.g. fmt(120, 1) -> "120.0"
  function fmt(n, digits) {
    return n.toLocaleString('en-US', { minimumFractionDigits: digits, maximumFractionDigits: digits });
  }
  // Measurements as typed, up to 2 decimals, e.g. 12 -> "12", 3.6576 -> "3.66"
  function fmtDim(n) {
    return n.toLocaleString('en-US', { maximumFractionDigits: 2 });
  }
  function plural(n, one, many) {
    return fmt(n, 0) + ' ' + (n === 1 ? one : (many || one + 's'));
  }

  function onMediaChange(mq, fn) {
    if (mq.addEventListener) mq.addEventListener('change', fn);
    else if (mq.addListener) mq.addListener(fn);
  }

  // Each feature runs on its own so one failure can't disable the others.
  function safely(name, fn) {
    try { fn(); return true; } catch (err) {
      if (window.console) console.error('[mtz] ' + name + ' failed:', err);
      return false;
    }
  }

  var header = $('.site-header');
  var navIsOpen = function () { return false; };

  /* ---------- WhatsApp links with ready-made messages ---------- */
  safely('whatsapp links', function () {
    $all('[data-wa]').forEach(function (el) {
      el.href = waLink(el.getAttribute('data-wa'));
    });
  });

  /* ---------- Tell screen-reader users which links open a new tab ---------- */
  safely('new-tab hints', function () {
    $all('a[target="_blank"]').forEach(function (a) {
      var label = a.getAttribute('aria-label');
      if (label) a.setAttribute('aria-label', label + ' (opens in a new tab)');
      else a.insertAdjacentHTML('beforeend', '<span class="visually-hidden"> (opens in a new tab)</span>');
    });
  });

  /* ---------- Footer year ---------- */
  safely('year', function () {
    $all('[data-year]').forEach(function (el) {
      el.textContent = String(new Date().getFullYear());
    });
  });

  /* ---------- Mobile navigation ---------- */
  safely('navigation', function () {
    var toggle = $('.nav-toggle');
    var nav = $('#site-nav');
    if (!toggle || !nav || !header) return;

    navIsOpen = function () { return toggle.getAttribute('aria-expanded') === 'true'; };

    function setOpen(open) {
      if (open) syncNavTop();
      toggle.setAttribute('aria-expanded', String(open));
      document.body.classList.toggle('nav-open', open);
    }

    toggle.addEventListener('click', function () { setOpen(!navIsOpen()); });

    // Close after choosing a link, tapping the backdrop, the logo or anywhere else
    document.addEventListener('click', function (e) {
      if (!navIsOpen()) return;
      if (e.target.closest('#site-nav a') || !e.target.closest('#site-nav, .nav-toggle')) setOpen(false);
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && navIsOpen()) {
        setOpen(false);
        toggle.focus();
      }
    });

    // Keyboard users tabbing out of the menu shouldn't leave it open over the page
    header.addEventListener('focusout', function (e) {
      if (navIsOpen() && e.relatedTarget && !header.contains(e.relatedTarget)) setOpen(false);
    });

    onMediaChange(window.matchMedia('(max-width: 1180px)'), function (e) {
      if (!e.matches) setOpen(false);
    });
  });

  // The open menu and its backdrop start where the header ends (the top bar may still be in view)
  function syncNavTop() {
    if (header) {
      document.documentElement.style.setProperty('--nav-top', Math.max(0, header.getBoundingClientRect().bottom) + 'px');
    }
  }

  /* ---------- Sticky header state ---------- */
  safely('header state', function () {
    if (!header) return;
    function onScroll() {
      header.classList.toggle('is-scrolled', window.scrollY > 8);
      if (navIsOpen()) syncNavTop();
    }
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  });

  /* ---------- Keep keyboard focus out from under the sticky header ---------- */
  safely('focus visibility', function () {
    if (!header) return;
    document.addEventListener('focusin', function (e) {
      var t = e.target;
      if (!t || !t.getBoundingClientRect || header.contains(t)) return;
      var keyboard = true;
      try { keyboard = t.matches(':focus-visible'); } catch (err) { /* older browsers: assume keyboard */ }
      if (!keyboard) return;
      var headerBottom = header.getBoundingClientRect().bottom;
      var r = t.getBoundingClientRect();
      if (r.top < headerBottom + 8) window.scrollBy(0, r.top - headerBottom - 16);
    });
  });

  /* ---------- Highlight the nav link for the section in view ---------- */
  safely('active link', function () {
    var navLinks = $all('.nav__list a[href^="#"]');
    if (!('IntersectionObserver' in window) || !navLinks.length) return;
    var linkFor = {};
    navLinks.forEach(function (a) { linkFor[a.getAttribute('href').slice(1)] = a; });
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        navLinks.forEach(function (a) {
          a.classList.remove('is-active');
          a.removeAttribute('aria-current');
        });
        var link = linkFor[entry.target.id];
        if (link) {
          link.classList.add('is-active');
          link.setAttribute('aria-current', 'location');
        }
      });
    }, { rootMargin: '-45% 0px -50% 0px' });
    $all('main section[id]').forEach(function (s) { observer.observe(s); });
  });

  /* ---------- Tile style filters ---------- */
  safely('filters', function () {
    var chips = $all('.chip[data-filter]');
    var cards = $all('.swatch-card');
    var status = $('#filter-status');

    chips.forEach(function (chip) {
      chip.addEventListener('click', function () {
        var filter = chip.getAttribute('data-filter');
        var shown = 0;
        chips.forEach(function (c) { c.setAttribute('aria-pressed', String(c === chip)); });
        cards.forEach(function (card) {
          var tags = (card.getAttribute('data-tags') || '').split(/\s+/);
          var match = filter === 'all' || tags.indexOf(filter) !== -1;
          card.hidden = !match;
          if (match) {
            shown++;
            card.classList.add('is-visible'); // never leave a filtered-in card mid-reveal
          }
        });
        if (status) status.textContent = plural(shown, 'tile style') + ' shown';
      });
    });
  });

  /* ---------- Tile calculator ---------- */
  safely('tile calculator', function () {
    var calc = $('#tile-calc');
    if (!calc) return;

    var el = {
      length: $('#calc-length'),
      width: $('#calc-width'),
      height: $('#calc-height'),
      openings: $('#calc-openings'),
      size: $('#calc-size'),
      ppb: $('#calc-ppb'),
      tw: $('#calc-tw'),
      th: $('#calc-th'),
      waste: $('#calc-waste'),
      custom: $('#calc-custom'),
      area: $('#r-area'),
      areaAlt: $('#r-area-alt'),
      tiles: $('#r-tiles'),
      tilesSub: $('#r-tiles-sub'),
      boxes: $('#r-boxes'),
      boxesSub: $('#r-boxes-sub'),
      message: $('#calc-message'),
      status: $('#calc-status'),
      send: $('#calc-send')
    };
    // Same physical limits in both units, so a room never becomes "too big" just by switching
    var LIMITS = { ft: { dim: 500, height: 50 }, m: { dim: 500 * M_PER_FT, height: 50 * M_PER_FT } };
    var measured = $all('[data-dim], [data-area]', calc);

    function num(input) {
      var v = parseFloat(input.value);
      return isFinite(v) ? v : NaN;
    }
    function checked(name) {
      var r = calc.querySelector('input[name="' + name + '"]:checked');
      return r ? r.value : '';
    }
    function factorFor(input) {
      return input.hasAttribute('data-area') ? M2_PER_SQFT : M_PER_FT;
    }

    // Remember each measurement in metres exactly as typed, so switching
    // feet <-> metres never drifts (12 ft -> 3.66 m -> 12 ft).
    function rememberBase(input) {
      var v = num(input);
      if (v >= 0) input.setAttribute('data-base', String(checked('unit') === 'm' ? v : v * factorFor(input)));
      else input.removeAttribute('data-base');
    }
    measured.forEach(function (input) {
      rememberBase(input);
      input.addEventListener('input', function () { rememberBase(input); });
    });

    // A value shown after a unit switch is rounded for display (3.66); calculate with the
    // exact remembered measurement (3.6576) unless the customer has since edited it.
    function measure(input) {
      var shown = num(input);
      var base = parseFloat(input.getAttribute('data-base'));
      if (base >= 0) {
        var exact = checked('unit') === 'm' ? base : base / factorFor(input);
        if (Math.abs(Math.round(exact * 100) / 100 - shown) < 1e-9) return exact;
      }
      return shown;
    }

    // Screen readers hear one short summary after typing pauses, not every keystroke
    var quiet = true;
    var lastAnnounced = '';
    var announceTimer;
    function announce(text) {
      if (quiet) { lastAnnounced = text; return; }
      clearTimeout(announceTimer);
      announceTimer = setTimeout(function () {
        if (text !== lastAnnounced) {
          el.status.textContent = text;
          lastAnnounced = text;
        }
      }, 700);
    }

    function invalid(message) {
      el.area.textContent = '–';
      el.areaAlt.innerHTML = '&nbsp;';
      el.tiles.textContent = '–';
      el.tilesSub.innerHTML = '&nbsp;';
      el.boxes.textContent = '–';
      el.boxesSub.innerHTML = '&nbsp;';
      el.message.textContent = message;
      el.message.hidden = false;
      el.send.href = waLink('Assalam o Alaikum! I need help working out how many tiles I need.');
      announce(message);
    }

    function update() {
      var walls = checked('surface') === 'walls';
      var unit = checked('unit') === 'm' ? 'm' : 'ft';
      var opt = el.size.options[el.size.selectedIndex];
      var isCustom = opt.value === 'custom';

      // Show / hide wall-only and custom-size fields, and keep unit labels current
      $all('[data-walls-only]', calc).forEach(function (f) { f.hidden = !walls; });
      el.custom.hidden = !isCustom;
      $all('[data-unit-suffix]', calc).forEach(function (s) { s.textContent = unit; });
      $all('[data-area-suffix]', calc).forEach(function (s) { s.textContent = unit === 'm' ? 'm²' : 'sq ft'; });

      var lim = LIMITS[unit];
      var L = measure(el.length);
      var W = measure(el.width);
      var H = walls ? measure(el.height) : 0;
      var openings = walls ? (el.openings.value.trim() === '' ? 0 : measure(el.openings)) : 0;
      var tileW = isCustom ? num(el.tw) : parseFloat(opt.getAttribute('data-w'));
      var tileH = isCustom ? num(el.th) : parseFloat(opt.getAttribute('data-h'));
      var perBox = num(el.ppb);
      var waste = parseFloat(el.waste.value) / 100;
      var unitWord = unit === 'm' ? 'metres' : 'feet';

      if (!(L > 0 && W > 0) || (walls && !(H > 0))) {
        return invalid(walls ? 'Enter the room length, width and wall height.' : 'Enter the room length and width.');
      }
      if (L > lim.dim || W > lim.dim || (walls && H > lim.height)) {
        return invalid('Those sizes look too big. Please check them (in ' + unitWord + ').');
      }
      if (isCustom && !(tileW >= 1 && tileW <= 300 && tileH >= 1 && tileH <= 300)) {
        return invalid('Enter the tile size in centimetres (1 to 300 cm).');
      }
      if (!(perBox >= 1 && perBox <= 100 && Math.floor(perBox) === perBox)) {
        return invalid('Enter a whole number of tiles per box (check the box label).');
      }
      if (!(openings >= 0)) {
        return invalid('Doors & windows can’t be a negative area.');
      }

      var area = walls ? 2 * (L + W) * H - openings : L * W; // in the chosen unit
      if (!(area > 0)) {
        return invalid('Doors & windows are larger than the wall area. Please check them.');
      }
      var areaM2 = unit === 'm' ? area : area * M2_PER_SQFT;
      var areaSqft = unit === 'm' ? area / M2_PER_SQFT : area;
      if (areaSqft < 1) {
        return invalid('Those sizes look too small. Please check them (in ' + unitWord + ').');
      }
      el.message.hidden = true;

      var tileM2 = (tileW / 100) * (tileH / 100);
      var tiles = Math.ceil((areaM2 * (1 + waste)) / tileM2 - 1e-9);
      var boxes = Math.ceil(tiles / perBox);
      var coverM2 = boxes * perBox * tileM2;
      var pct = Math.round(waste * 100);
      var M2 = NBSP + 'm²';
      var SQFT = NBSP + 'sq' + NBSP + 'ft';

      // The unit sits in its own span so a long number never splits "sq / ft" across lines
      var unitSpan = function (u) { return ' <span class="stat__unit">' + u + '</span>'; };
      if (unit === 'm') {
        el.area.innerHTML = fmt(areaM2, 2) + unitSpan('m²');
        el.areaAlt.textContent = fmt(areaSqft, 1) + SQFT;
      } else {
        el.area.innerHTML = fmt(areaSqft, 1) + unitSpan('sq&nbsp;ft');
        el.areaAlt.textContent = fmt(areaM2, 2) + M2;
      }
      el.tiles.textContent = fmt(tiles, 0);
      el.tilesSub.textContent = 'incl. ' + pct + '% extra';
      el.boxes.textContent = fmt(boxes, 0);
      el.boxesSub.textContent = 'Covers ' + fmt(coverM2, 2) + M2 + ' (' + fmt(coverM2 / M2_PER_SQFT, 0) + SQFT + ')';

      var surfaceLine = walls
        ? 'Walls: ' + fmtDim(L) + ' × ' + fmtDim(W) + ' ' + unit + ' room, ' + fmtDim(H) + ' ' + unit + ' high' +
          (openings > 0 ? ' (minus ' + fmtDim(openings) + (unit === 'm' ? ' m²' : ' sq ft') + ' doors/windows)' : '')
        : 'Floor: ' + fmtDim(L) + ' × ' + fmtDim(W) + ' ' + unit;
      var sizeLabel = isCustom ? fmtDim(tileW) + ' × ' + fmtDim(tileH) + ' cm' : opt.textContent.trim();

      el.send.href = waLink([
        'Assalam o Alaikum! I used the tile calculator on your website.',
        '',
        surfaceLine,
        'Area: ' + fmt(areaSqft, 1) + ' sq ft (' + fmt(areaM2, 2) + ' m²)',
        'Tile size: ' + sizeLabel,
        'Estimate: ' + plural(tiles, 'tile') + ' = ' + plural(boxes, 'box', 'boxes') + ' of ' + perBox +
          ' (incl. ' + pct + '% extra)',
        '',
        'Please share designs and prices.'
      ].join('\n'));

      announce('Estimate: ' + plural(tiles, 'tile') + ', ' + plural(boxes, 'box', 'boxes') + '.');
    }

    // Changing the tile size resets "tiles per box" to the typical value for that size
    el.size.addEventListener('change', function () {
      var opt = el.size.options[el.size.selectedIndex];
      el.ppb.value = opt.getAttribute('data-ppb') || el.ppb.value;
    });

    // Switching units redraws the remembered measurements in the new unit
    $all('input[name="unit"]', calc).forEach(function (radio) {
      radio.addEventListener('change', function () {
        var toMetres = radio.value === 'm';
        measured.forEach(function (input) {
          var base = parseFloat(input.getAttribute('data-base'));
          if (!(base > 0)) return;
          var v = toMetres ? base : base / factorFor(input);
          input.value = String(Math.round(v * 100) / 100);
        });
        var lim = LIMITS[toMetres ? 'm' : 'ft'];
        el.length.max = el.width.max = String(Math.round(lim.dim * 10) / 10);
        el.height.max = String(Math.round(lim.height * 10) / 10);
      });
    });

    // Radios and selects have their own change handlers (unit conversion, tiles per box)
    // that must run first, so they only trigger update() through 'change'.
    calc.addEventListener('input', function (e) {
      if (e.target.type !== 'radio' && e.target.tagName !== 'SELECT') update();
    });
    calc.addEventListener('change', update);
    calc.addEventListener('submit', function (e) { e.preventDefault(); });
    update();
    quiet = false;
  });

  /* ---------- Enquiry form → WhatsApp ---------- */
  safely('enquiry form', function () {
    var form = $('#enquiry-form');
    if (!form) return;
    var fields = [
      { input: $('#f-name'), error: $('#f-name-error') },
      { input: $('#f-message'), error: $('#f-message-error') }
    ];

    // Errors are only linked to their field while they're showing
    function validate(field) {
      var ok = field.input.value.trim().length > 0;
      field.input.setAttribute('aria-invalid', String(!ok));
      field.error.hidden = ok;
      if (ok) field.input.removeAttribute('aria-describedby');
      else field.input.setAttribute('aria-describedby', field.error.id);
      return ok;
    }

    fields.forEach(function (f) {
      f.input.addEventListener('input', function () {
        if (f.input.getAttribute('aria-invalid') === 'true') validate(f);
      });
    });

    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var firstInvalid = null;
      fields.forEach(function (f) {
        if (!validate(f) && !firstInvalid) firstInvalid = f.input;
      });
      if (firstInvalid) {
        firstInvalid.focus();
        return;
      }

      var area = $('#f-area').value.trim();
      var lines = ['Assalam o Alaikum! I have an enquiry from your website.', '', 'Name: ' + $('#f-name').value.trim()];
      if (area) lines.push('Area: ' + area);
      lines.push('Interested in: ' + $('#f-interest').value, '', $('#f-message').value.trim());

      var url = waLink(lines.join('\n'));
      // 'noopener' as a feature makes window.open() return null, so detach the opener manually
      var win = window.open(url, '_blank');
      if (win) win.opener = null;
      else window.location.href = url; // pop-up blocked: open in this tab instead
    });
  });

  /* ---------- Floating WhatsApp button: step aside for full-width WhatsApp buttons ---------- */
  safely('floating button', function () {
    var fab = $('.wa-float');
    var targets = $all('[data-hide-fab]');
    if (!fab || !targets.length || !('IntersectionObserver' in window)) return;
    var inView = targets.map(function () { return false; });
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        inView[targets.indexOf(entry.target)] = entry.isIntersecting;
      });
      fab.classList.toggle('is-hidden', inView.some(Boolean));
    });
    targets.forEach(function (t) { observer.observe(t); });
  });

  /* ---------- Reveal on scroll ---------- */
  var revealOk = safely('reveal', function () {
    var reveals = $all('.reveal');
    var showAll = function () { reveals.forEach(function (r) { r.classList.add('is-visible'); }); };
    window.addEventListener('beforeprint', showAll);
    var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (!('IntersectionObserver' in window) || reduceMotion) {
      showAll();
      return;
    }
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });
    reveals.forEach(function (r) { observer.observe(r); });
  });

  // If reveal failed, the fallback in <head> removes the .js class so all content shows
  window.MTZ_READY = revealOk;
})();
