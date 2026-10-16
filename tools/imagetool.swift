import Foundation
import CoreGraphics
import ImageIO
import CoreText

// Image tool for the website photos (macOS only: CoreGraphics + ImageIO, no other dependencies).
// Build:  swiftc -O tools/imagetool.swift -o <somewhere>/imagetool      (tools/crop-images.sh does this for you)
//
// imagetool sheets <pdf> <outprefix> <cols> <rows> <cell>     contact sheets of a PDF, pages labelled pN
// imagetool page <pdf> <page> <maxpx> <out.jpg>               render one PDF page
// imagetool images <pdf> <page> [outprefix]                   list a page's embedded images; save JPEG ones as-is
// imagetool export <in> <x> <y> <w> <h> <maxpx> <out.jpg> <out.avif> [jpgQ avifQ]
//                                                             crop (pixels, top-left origin), resize, save JPEG + AVIF
// imagetool exportf ...                                       the same with x/y/w/h as fractions (0-1) of the image
// imagetool rowfill <in> <out.jpg> <x,y,w,h[,ax,ay,bx,by][:raw|:flat]>...   paint out an area row by row (see the function)
// imagetool imgsheet <out.jpg> <cols> <cell> <label=path>...  labelled grid of images, for reviewing picks

let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!

func write(_ img: CGImage, _ path: String, _ type: String, _ q: Double) {
  guard let d = CGImageDestinationCreateWithURL(URL(fileURLWithPath: path) as CFURL, type as CFString, 1, nil) else { fputs("no dest \(path)\n", stderr); return }
  CGImageDestinationAddImage(d, img, [kCGImageDestinationLossyCompressionQuality: q] as CFDictionary)
  if !CGImageDestinationFinalize(d) { fputs("finalize failed \(path)\n", stderr) }
}

func ctx(_ w: Int, _ h: Int) -> CGContext {
  let c = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB,
                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
  c.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1)); c.fill(CGRect(x: 0, y: 0, width: w, height: h))
  c.interpolationQuality = .high
  return c
}

func pageSize(_ p: CGPDFPage) -> (CGRect, Int, CGFloat, CGFloat) {
  let box = p.getBoxRect(.cropBox)
  let rot = ((Int(p.rotationAngle) % 360) + 360) % 360
  let side = rot == 90 || rot == 270
  return (box, rot, side ? box.height : box.width, side ? box.width : box.height)
}

// Draw a page so that it fills `rect` (aspect kept, centred)
func draw(_ p: CGPDFPage, _ c: CGContext, _ rect: CGRect) {
  let (box, rot, w0, h0) = pageSize(p)
  let s = min(rect.width / w0, rect.height / h0)
  c.saveGState()
  c.translateBy(x: rect.minX + (rect.width - w0 * s) / 2, y: rect.minY + (rect.height - h0 * s) / 2)
  c.scaleBy(x: s, y: s)
  c.clip(to: CGRect(x: 0, y: 0, width: w0, height: h0))
  switch rot {
  case 90: c.translateBy(x: 0, y: h0); c.rotate(by: -.pi / 2)
  case 180: c.translateBy(x: w0, y: h0); c.rotate(by: .pi)
  case 270: c.translateBy(x: w0, y: 0); c.rotate(by: .pi / 2)
  default: break
  }
  c.translateBy(x: -box.minX, y: -box.minY)
  c.drawPDFPage(p)
  c.restoreGState()
}

func label(_ c: CGContext, _ s: String, _ x: CGFloat, _ y: CGFloat) {
  let font = CTFontCreateWithName("Helvetica-Bold" as CFString, 26, nil)
  let attrs = [NSAttributedString.Key(kCTFontAttributeName as String): font,
               NSAttributedString.Key(kCTForegroundColorAttributeName as String): CGColor(red: 1, green: 1, blue: 1, alpha: 1)] as [NSAttributedString.Key: Any]
  let line = CTLineCreateWithAttributedString(NSAttributedString(string: s, attributes: attrs))
  let b = CTLineGetBoundsWithOptions(line, [])
  c.setFillColor(CGColor(red: 0.8, green: 0, blue: 0, alpha: 1))
  c.fill(CGRect(x: x, y: y, width: b.width + 14, height: 34))
  c.textPosition = CGPoint(x: x + 7, y: y + 8)
  CTLineDraw(line, c)
}

let a = CommandLine.arguments
guard a.count > 1 else { exit(1) }
switch a[1] {
case "sheets":
  guard let doc = CGPDFDocument(URL(fileURLWithPath: a[2]) as CFURL) else { fputs("ERR open \(a[2])\n", stderr); exit(2) }
  let cols = Int(a[4])!, rows = Int(a[5])!, cell = CGFloat(Int(a[6])!), gap: CGFloat = 8
  let n = doc.numberOfPages, per = cols * rows
  var start = 1
  while start <= n {
    let end = min(n, start + per - 1)
    let W = Int(CGFloat(cols) * (cell + gap) + gap), H = Int(CGFloat(rows) * (cell + gap) + gap)
    let c = ctx(W, H)
    c.setFillColor(CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)); c.fill(CGRect(x: 0, y: 0, width: W, height: H))
    for i in start...end {
      let k = i - start, col = k % cols, row = k / cols
      let x = gap + CGFloat(col) * (cell + gap)
      let y = CGFloat(H) - (gap + CGFloat(row + 1) * (cell + gap)) + gap
      let r = CGRect(x: x, y: y, width: cell, height: cell)
      c.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1)); c.fill(r)
      if let p = doc.page(at: i) { draw(p, c, r) }
      label(c, "p\(i)", x, y + cell - 34)
    }
    write(c.makeImage()!, String(format: "%@-p%03d-%03d.jpg", a[3], start, end), "public.jpeg", 0.72)
    start = end + 1
  }
case "page":
  guard let doc = CGPDFDocument(URL(fileURLWithPath: a[2]) as CFURL), let p = doc.page(at: Int(a[3])!) else { exit(2) }
  let maxPx = CGFloat(Int(a[4])!)
  let (_, _, w0, h0) = pageSize(p)
  let s = maxPx / max(w0, h0)
  let W = Int((w0 * s).rounded()), H = Int((h0 * s).rounded())
  let c = ctx(W, H)
  draw(p, c, CGRect(x: 0, y: 0, width: W, height: H))
  write(c.makeImage()!, a[5], "public.jpeg", 0.92)
  print("\(W)x\(H)")
case "export", "exportf":
  guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: a[2]) as CFURL, nil),
        let img = CGImageSourceCreateImageAtIndex(src, 0, nil) else { exit(2) }
  // export takes pixels; exportf takes fractions of the image (0-1), top-left origin
  let iw = Double(img.width), ih = Double(img.height)
  let f = a[1] == "exportf"
  let x = f ? Int((Double(a[3])! * iw).rounded()) : Int(a[3])!
  let y = f ? Int((Double(a[4])! * ih).rounded()) : Int(a[4])!
  let w = f ? Int((Double(a[5])! * iw).rounded()) : Int(a[5])!
  let h = f ? Int((Double(a[6])! * ih).rounded()) : Int(a[6])!
  let maxPx = CGFloat(Int(a[7])!)
  guard let crop = img.cropping(to: CGRect(x: x, y: y, width: w, height: h)) else { fputs("bad crop\n", stderr); exit(3) }
  let s = min(1, maxPx / CGFloat(max(w, h)))   // never upscale
  let W = Int((CGFloat(w) * s).rounded()), H = Int((CGFloat(h) * s).rounded())
  let c = ctx(W, H)
  c.draw(crop, in: CGRect(x: 0, y: 0, width: W, height: H))
  let out = c.makeImage()!
  let jq = a.count > 10 ? Double(a[10])! : 0.78, aq = a.count > 11 ? Double(a[11])! : 0.6
  write(out, a[8], "public.jpeg", jq)
  write(out, a[9], "public.avif", aq)
  print("\(W)x\(H)")
case "images":
  // images <pdf> <page> [outprefix]  list image XObjects (w x h, filter); with outprefix, save JPEG streams as-is
  guard let doc = CGPDFDocument(URL(fileURLWithPath: a[2]) as CFURL), let p = doc.page(at: Int(a[3])!),
        let pd = p.dictionary else { exit(2) }
  var res: CGPDFDictionaryRef?
  guard CGPDFDictionaryGetDictionary(pd, "Resources", &res), let r = res else { print("no resources"); exit(0) }
  var xo: CGPDFDictionaryRef?
  guard CGPDFDictionaryGetDictionary(r, "XObject", &xo), let x = xo else { print("no xobjects"); exit(0) }
  let prefix: String? = a.count > 4 ? a[4] : nil
  final class Box { var items: [(String, CGPDFStreamRef)] = [] }
  let box = Box()
  CGPDFDictionaryApplyFunction(x, { key, obj, info in
    var st: CGPDFStreamRef?
    if CGPDFObjectGetValue(obj, .stream, &st), let st = st {
      Unmanaged<Box>.fromOpaque(info!).takeUnretainedValue().items.append((String(cString: key), st))
    }
  }, Unmanaged.passUnretained(box).toOpaque())
  for (name, st) in box.items {
    guard let sd = CGPDFStreamGetDictionary(st) else { continue }
    var sub: UnsafePointer<Int8>?
    CGPDFDictionaryGetName(sd, "Subtype", &sub)
    let subtype = sub.map { String(cString: $0) } ?? "?"
    var w: CGPDFInteger = 0, h: CGPDFInteger = 0
    CGPDFDictionaryGetInteger(sd, "Width", &w); CGPDFDictionaryGetInteger(sd, "Height", &h)
    var fmt = CGPDFDataFormat.raw
    let data = CGPDFStreamCopyData(st, &fmt)
    let f = fmt == .jpegEncoded ? "jpeg" : (fmt == .JPEG2000 ? "jpx" : "raw")
    print("\(name)\t\(subtype)\t\(w)x\(h)\t\(f)\t\(data.map { CFDataGetLength($0) } ?? 0)")
    if let pre = prefix, subtype == "Image", fmt == .jpegEncoded, let d = data {
      try? (d as Data).write(to: URL(fileURLWithPath: "\(pre)-\(name)-\(w)x\(h).jpg"))
    }
  }
case "rowfill":
  // rowfill <in> <out.jpg> <x,y,w,h[,ax,ay,bx,by]>...  fill each row of a rectangle by blending the clean pixels
  // just left and right of it (keeps horizontal lines straight). With a line a-b, only pixels above it are filled.
  guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: a[2]) as CFURL, nil),
        let img = CGImageSourceCreateImageAtIndex(src, 0, nil) else { exit(2) }
  let W = img.width, H = img.height
  let c0 = ctx(W, H); c0.draw(img, in: CGRect(x: 0, y: 0, width: W, height: H))
  let px = c0.data!.bindMemory(to: UInt8.self, capacity: c0.bytesPerRow * H), bpr = c0.bytesPerRow
  var seed: UInt32 = 12345
  func noise() -> Float { seed = seed &* 1664525 &+ 1013904223; return Float(seed >> 8) / Float(1 << 24) - 0.5 }
  for spec0 in a.dropFirst(4) {
    // ":raw" = no vertical softening (thin lines such as frame bars); ":flat" = no grain either (plain white backgrounds)
    let flat = spec0.hasSuffix(":flat")
    let raw = flat || spec0.hasSuffix(":raw")
    let spec = flat ? String(spec0.dropLast(5)) : (raw ? String(spec0.dropLast(4)) : spec0)
    let v = spec.split(separator: ",").map { Double($0)! }
    let x0 = Int(v[0]), y0 = Int(v[1]), x1 = x0 + Int(v[2]), y1 = y0 + Int(v[3])
    var filled: [(Int, Int)] = []
    for y in y0..<y1 {
      var L = [Float](repeating: 0, count: 3), Rr = L
      for ch in 0..<3 {
        L[ch] = (Float(px[y * bpr + (x0 - 2) * 4 + ch]) + Float(px[y * bpr + (x0 - 3) * 4 + ch])) / 2
        Rr[ch] = (Float(px[y * bpr + (x1 + 1) * 4 + ch]) + Float(px[y * bpr + (x1 + 2) * 4 + ch])) / 2
      }
      for x in x0..<x1 {
        if v.count >= 8 {   // only above the line from (ax, ay) to (bx, by)
          let t = (Double(x) - v[4]) / (v[6] - v[4]); let ly = v[5] + t * (v[7] - v[5])
          if Double(y) >= ly { continue }
        }
        let t = Float(x - x0 + 1) / Float(x1 - x0 + 1), n = flat ? 0 : noise() * (raw ? 3 : 6)
        for ch in 0..<3 { px[y * bpr + x * 4 + ch] = UInt8(max(0, min(255, L[ch] + (Rr[ch] - L[ch]) * t + n))) }
        filled.append((x, y))
      }
    }
    // soften vertical banding: two passes of a 3-tap vertical average over the filled pixels
    for _ in 0..<(raw ? 0 : 2) {
      var out: [(Int, Int, [UInt8])] = []
      for (x, y) in filled where y > 0 && y < H - 1 {
        var c3 = [UInt8](repeating: 0, count: 3)
        for ch in 0..<3 { c3[ch] = UInt8((Int(px[(y - 1) * bpr + x * 4 + ch]) + 2 * Int(px[y * bpr + x * 4 + ch]) + Int(px[(y + 1) * bpr + x * 4 + ch])) / 4) }
        out.append((x, y, c3))
      }
      for (x, y, c3) in out { for ch in 0..<3 { px[y * bpr + x * 4 + ch] = c3[ch] } }
    }
  }
  write(c0.makeImage()!, a[3], "public.jpeg", 0.95)
case "imgsheet":
  // imgsheet <out.jpg> <cols> <cell> <label=path>...  grid of images with labels
  let out = a[2], cols = Int(a[3])!, cell = CGFloat(Int(a[4])!), gap: CGFloat = 8
  let items = Array(a.dropFirst(5))
  let rows = (items.count + cols - 1) / cols
  let W = Int(CGFloat(cols) * (cell + gap) + gap), H = Int(CGFloat(rows) * (cell + gap) + gap)
  let c = ctx(W, H)
  c.setFillColor(CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)); c.fill(CGRect(x: 0, y: 0, width: W, height: H))
  for (k, it) in items.enumerated() {
    let parts = it.split(separator: "=", maxSplits: 1).map(String.init)
    let col = k % cols, row = k / cols
    let x = gap + CGFloat(col) * (cell + gap)
    let y = CGFloat(H) - (gap + CGFloat(row + 1) * (cell + gap)) + gap
    guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: parts[1]) as CFURL, nil),
          let img = CGImageSourceCreateImageAtIndex(src, 0, nil) else { continue }
    let s = min(cell / CGFloat(img.width), cell / CGFloat(img.height))
    let w = CGFloat(img.width) * s, h = CGFloat(img.height) * s
    c.draw(img, in: CGRect(x: x + (cell - w) / 2, y: y + (cell - h) / 2, width: w, height: h))
    label(c, parts[0], x, y + cell - 34)
  }
  write(c.makeImage()!, out, "public.jpeg", 0.8)
default: exit(1)
}
