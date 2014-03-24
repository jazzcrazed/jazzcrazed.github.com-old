---
title: CSS Transparency and Overlapping Glyphs
date: 2010-08-23 18:46
tags: css, design, development, type, webfonts
image: "/images/a17d19ac55f1f16b3029cf026823e47d-300x134.png"
---

![Example of overlapping glyphs using CSS rgba()](/images/a17d19ac55f1f16b3029cf026823e47d-300x134.png)

<code>rgba()</code> is a supremely useful CSS value. But I noticed, while
working on the footer of this site down below, that operating systems render
typography using this value in interesting ways.

<h2>About CSS transparency</h2>

<p>
  To start, a quick overview. <code>rgba()</code> is a CSS property value
  specified in the <a href="http://www.w3.org/TR/css3-color/#rgba-color">CSS3
  color module</a> that allows one to set in single value the traditional
  red/green/blue color sub-values, as well as a fourth sub-value for
  <a href="http://en.wikipedia.org/wiki/Alpha_compositing">alpha transparency</a>.
  The syntax is pretty straightforward: <code>rgba(red,green,blue,alpha)</code>,
  where red, green, and blue are specified either as a percentage (0 to 100%) or
  as a number from 0 to 255, and alpha is specified as a decimal value -- "1"
  translating to 100% opaque, ".5" is 50% transparent, "0" is completely
  transparent, etc.
</p>

<p>
  The awesomeness of this idea is that with <code>rgba()</code> as a value, it
  can be applied on any CSS property where color values are accepted, such as
  <code>color</code>, <code>background-color</code>, <code>text-shadow</code>,
  what-have-you. The end result is the ability to apply individual levels of
  transparency to a single CSS selector for different properties -- for instance,
  you can set your background to one transparency, and your text to another.
  Contrast this with the older <code>opacity</code> CSS property, which applies
  an alpha transparency value (in the same 0 to 1 decimal scale) to the entire
  selector -- meaning, the selected element and any of its children would all
  get the same opacity, background, text, and all.
</p>

<h2>Rendering issues with overlapping glyphs</h2>

<p>
  While tooling around with my footer down below, I noticed <code>rgba()</code>
  being even more granular than I wanted it to be with regards to typefaces that
  naturally had overlapping glyphs. I had my footer set to something like this:
</p>

<p>
  <pre>
  .myFooter {
    font-family: DeftoneStylusRegular;
    color: rgba(255,255,255,.2);
  }
  </pre>
</p>

<p>
  Via <code>@font-face</code>, I'm using <a href="http://www.larabiefonts.com">
  Ray Larabie's</a> <a href="http://www.fontsquirrel.com/fonts/Deftone-Stylus">
  Deftone Stylus</a>, which is a retro styled script font that's intentionally
  kerned so that there's overlap for the glyph connectors, as are most script
  fonts. The above CSS would set the text's color to be white with 20% opacity.
  And the result looked like this:
</p>

<figure class="fullWidth">
  <div class="curledShadow">
    <img src="/images/a17d19ac55f1f16b3029cf026823e47d-300x134.png"
      alt="Example of overlapping glyphs using CSS rgba()" />
  </div>
  <figcaption>Example of overlapping glyphs using CSS rgba()</figcaption>
</figure>

<p>
  Where the glyphs' serifs overlap to act as connectors, the opacity is multiplied.
  I created a simple little test to try to isolate what the issue was:
</p>

<p>
  <pre>
    &lt;style&gt;
    .test{
      font: bold 5em sans-serif;
      color:(0,0,0,.25);
      letter-spacing: -.2em;
    }
    &lt;/style&gt;

    &lt;p class="test"&gt;This is a test using rgba.&lt;/p&gt;
  </pre>
</p>

<p>
  This uses the browser's standard sans-serif typeface, sets it to black at 25%
  opacity via <code>rgba()</code>, and condenses the glyphs via negative <code>
  letter-spacing</code> to get overlap. It looks like this in Firefox 3.6 and
  Chrome 5 in OS X:
</p>

<p>
  <img src="http://files.droplr.com.s3.amazonaws.com/files/24522365/1Az9cg.Screen%20shot%202010-08-23%20at%2013:37:52.png"
    alt="OS X screengrab of standard sans-serif font condensed via negative
    letter-spacing and set at 20% opacity via rgba()" />
</p>

<p>
  As you can see, it appears as if each character is being targeted for
  transparency, and when they overlap they are treated as independent layers&hellip;
  in OS X, that is. Take a look at the same in Windows Firefox and Chrome:
</p>

<p>
  <img src="http://gyazo.com/8e193b94ebb9668356b341ab64892f0d.png"
    alt="Windows screengrab of standard sans-serif font condensed via negative
    letter-spacing and set at 20% opacity via rgba()" />
</p>

<p>
  In Windows, in either browser, it looks like it renders all the glyphs as a
  single vector object before then applying the transparency uniformly on the
  whole shebang. So my best guess is that browsers use OS-level compositing here,
  and there are discrepencies between operating systems. Most unfortunate, if
  you're aiming for semi-transparent typography that has intentional glyph
  overlap. However, there's a way out via opacity:
</p>

<p>
  <pre>
    &lt;style&gt;
    .test{
      font: bold 5em sans-serif;
      color: #000;
      letter-spacing: -.2em;
      opacity: .25;
    }
    &lt;/style&gt;

    &lt;p class="test"&gt;This is a test using opacity.&lt;/p&gt;
  </pre>
</p>

<p>
  This should actually look exactly the same as the first example -- and that
  much is true in Windows. However, in OS X:
</p>

<p>
  <img src="http://files.droplr.com.s3.amazonaws.com/files/24522365/1AAw76.Screen%20shot%202010-08-23%20at%2014%3A34%3A44.png"
    alt="OS X screengrab of standard sans-serif font condensed via negative
    letter-spacing and set at 20% opacity via opacity" />
</p>

<p>
  It looks just like Windows does -- and actually, it looks the way I had
  originally intended. And this makes sense, since according to
  <a href="http://www.w3.org/TR/css3-color/#transparency">the spec regarding CSS
  transparency</a>, "<em>...after the element (including its descendants) is
  rendered into an RGBA offscreen image, the opacity setting specifies how to
  blend the offscreen rendering into the current composite rendering.</em>" In
  otherwords, render the elements at full opacity, and then crank the opacity
  down post-rendering based on the <code>opacity</code> property value before
  finally rendering on screen. Conceivably, <code>rgba()</code> is the same
  thing, only with multiple layers nested across multiple properties -- but
  turns out OS X takes it a step further with text by isolating each glyph.
</p>

<p>
  Check out <a href="/demos/alphafonts/index.html">this test page</a> for the
  above examples (make sure to view in both Windows and OS X).
</p>

<h2>Conclusion</h2>

<p>
  Honestly, this shouldn't make a big difference in the vast majority of
  situations where traditional sans-serif or serif fonts are in use, as their
  glyphs don't usually overlap. But think twice about it if you're thinking
  about applying transparency to text set using a font with intentional character
  overlap -- which includes just about all script fonts. Here's an example of
  just a few, including Deftone Stylus which I used in my footer -- these are
  at their default kerning, with no forced condensing via <code>letter-spacing</code>:
</p>

</p>
  <a href="/demos/alphafonts/naturally-overlapping-type.html">
    Demo of fonts with intentional glyph overlap.
  </a>
</p>

</p>
  If I wanted to apply transparency to text using any of the fonts in the above
  demo, I'd have to forego <code>rgba()</code> in favor of wrapping the text in
  its own element, and then targeting that element with <code>opacity</code>,
  instead. That's exactly what I ended up doing for my footer, by the way. It
  means extra DOM elements, but at least it works!
</p>

<h2>Note about Opera in Windows</h2>

<p>
  In OS X, Opera 10.61 looks much the same as Firefox and Chrome. But in Windows,
  it has some issues with certain typefaces when transparency is used in any form:
</p>

</p>
  <img src="http://gyazo.com/28451d7da372597d7b1aedb4599a3a81.png"
    alt="Screengrab of Opera 10.61 in Windows cutting off glyphs on certain fonts
    when transparency is applied" />
</p>

<p>
  As you can see, it's cutting off certain glyphs along the vertical. Not sure
  what the issue is, but I haven't hunted around much for answers, either, so
  I'll update this if I find anything.
</p>

<h2>Credits</h2>

<p>
  Thanks to the wonderful <a href="http://www.fontsquirrel.com">Font Squirrel</a>
  and all of its participating typographers, for their wonderful collection of
  type, and handy @font-face kits!
</p>
