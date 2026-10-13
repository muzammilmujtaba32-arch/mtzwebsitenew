// Layout check for the Mumtaz website. Paste into the browser console (or run with a browser tool)
// at any window width. Returns a JSON summary; every list should be empty and overflowX false.
(function () {
  document.querySelectorAll('.reveal').forEach(function (e) { e.classList.add('is-visible'); });
  var vw = document.documentElement.clientWidth;
  var res = { width: vw, overflowX: document.documentElement.scrollWidth > vw };

  // Buttons and links whose text doesn't fit (the filter chip row scrolls on purpose, so it's skipped)
  res.clipped = Array.prototype.filter.call(document.querySelectorAll('.btn, .chip, .seg label, .link-arrow, .nav__list a'), function (b) {
    return b.offsetParent && b.scrollWidth > b.clientWidth + 1 && !b.closest('.filters');
  }).map(function (b) { return b.textContent.trim().slice(0, 30); });

  // Anything poking out of the right edge of its card
  var bad = [];
  document.querySelectorAll('form, .product-card, .swatch-card, .feature, .policy, .person, .infocard, .stat, .collections__note, .brand-panel, .photo-card, .bond-card, .trust, .vm__item').forEach(function (card) {
    if (!card.offsetParent) return;
    var cr = card.getBoundingClientRect();
    card.querySelectorAll('*').forEach(function (k) {
      var r = k.getBoundingClientRect();
      if (r.width > 0 && k.offsetParent !== null && r.right > cr.right + 0.5 && getComputedStyle(k).position !== 'absolute') {
        bad.push(card.className.split(' ')[0] + ' > ' + k.tagName.toLowerCase());
      }
    });
  });
  res.overflowInCards = bad.filter(function (v, i) { return bad.indexOf(v) === i; });

  // Images that failed to load
  res.brokenImages = Array.prototype.filter.call(document.images, function (i) { return i.complete && i.naturalWidth === 0; })
    .map(function (i) { return i.getAttribute('src'); });

  // Logo clear space (brand rule: a quarter of the icon height above and below)
  var img = document.querySelector('.brand img'), hdr = document.querySelector('.site-header').getBoundingClientRect(), ir = img.getBoundingClientRect();
  var pad = ir.height * 58.9 / 1295.1, art = ir.height - 2 * pad;
  res.logoClearSpace = 'need ' + (art / 4).toFixed(1) + 'px, have ' + (ir.top + pad - hdr.top).toFixed(1) + ' / ' + (hdr.bottom - (ir.bottom - pad)).toFixed(1);

  res.menu = getComputedStyle(document.querySelector('.nav-toggle')).display === 'none' ? 'desktop links' : 'hamburger';
  return JSON.stringify(res, null, 1);
})();
