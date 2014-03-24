---
title: "Futzing Around with Icon Fonts and SVG"
tags: development, design
date: 2012-06-12 17:50
image: "/images/inkscape-minefold-logo.png"
---

![Minefold logo being created in Inkscape](/images/inkscape-minefold-logo.png?align=fullWidth)

Vector graphics are great. They deserve more of a place on websites than they get &mdash; certainly compared to their rasterized cousins. Nowhere is this more true than with icon UI. I decided to dip my toes into two leading solutions to bringing vectors to webpages: icon fonts, and SVG.

<span class="more"></span>

<p>
  I won’t go too much into detail on either icon fonts or SVG, the former of
  which has seen terrific coverage by the likes of
  <a href="http://css-tricks.com/html-for-icon-font-usage/">CSS-Tricks</a> and
  <a href="http://www.webdesignerdepot.com/2012/01/how-to-make-your-own-icon-webfont/">
  Web Designer Depot</a>, and the latter of which <a href="http://www.w3.org/Graphics/SVG/">
  has been a web standard since 2001</a>. I’ll summarize with the normal wins of
  <a href="http://en.wikipedia.org/wiki/Vector_graphics">vector graphics</a>:
  they are scalable and styleable, unlike raster graphics which need to be
  duplicated for every situation whether it’s a color or size change or both.
</p>

<h2>Using Icon Fonts</h2>

<p>
  I’m using icon fonts for some UI in my footer &mdash; the links to my RSS feed,
  my Twitter page, and my Github repository for this blog. There were certain use
  cases that made icon fonts a good fit: specifically, I wanted to handle them
  with CSS-driven <code>text-shadows</code> and <code>transitions</code>, just
  like my plain-text links. CSS is a terrifically convenient layer at which to
  style font icons.
</p>

<p>
The custom font I&rsquo;m using comes courtesy of the awesome
<a href="http://keyamoon.com/icomoon/#toHome">Keyamoon’s IcoMoon</a>, which
provides 300 free icons, and 622+ icons at the bargain price of $35. You can
also import custom SVG icons, if none of the free ones are usable, and you can
explicitly map your icons to Unicode characters. I let IcoMoon decide the
mappings for me, and soon enough had a perfectly usable stack of web fonts and
some nice CSS style definitions for using them, similar to the output of
<a href="http://www.fontsquirrel.com/fontface/generator">Font Squirrel’s
Font-Face Generator</a>. For the most part, I used IcoMoon’s generated CSS with
few customizations. It creates some nice classes leveraging <code>:before</code>
pseudo-elements:
</p>

<p>
<pre>
/* Add the following classes to your stylesheet if you
   want to use data attributes for inserting your icons */
.iconb:before, .icona:after {
  font-family: 'IcoMoon';
  content: attr(data-icon);
}

/* Add the following CSS properties to your stylesheet
   if you want to have a class per icon */
[class^="icon-"]:before, [class*=" icon-"]:before {
  font-family: 'IcoMoon';
  font-style: normal;
}
.icon-feed:before {
  content: "\0061";
}
</pre>
</p>

<h2>Some Gotchas</h2>

<p>
  If you&rsquo;re super anal about pixel perfection, then you probably should
  leave vectors behind right now and go back to your Photoshops. But if
  you&rsquo;re still curious, a few things to note.
</p>

<p>
  Firstly, icon fonts are text. And, as we all know, that means cross-browser,
  cross-operating-system rendering differences:
</p>

<figure class="fullWidth">
  <div class="curledShadow">
    <img src="/images/octocat-font-icon-comparison.png"
      alt="Comparison of Github's Octocat font icon in Chrome and Firefox" />
  </div>
  <figcaption>
    The <a href="http://www.github.com">Github</a> Octocat font icon as rendered
    (and zoomed in, rasterized) in (from left to right)<br />Chrome OS X,
    Firefox OS X, Chrome Windows, and Chrome Ubuntu 12. Bottom row zoomed 200%.
  </figcaption>
</figure>

<p>
  Pixel peepers will note the extra definition of edges of the tentacles in the
  non-OS X operating systems, and differently sized eyes, amongst other tiny
  differences. As a user of icons, you shouldn&rsquo;t get worked up about this
  (though, if I had to pick a favorite, it&rsquo;s the Ubuntu version, which
  lacks jaggies but retains nice detail).
</p>

<figure class="right">
  <div class="curledShadow">
    <img src="/images/gridded-icon-design.png" alt="Designing with a pixel grid in Inkscape" />
  </div>
  <figcaption>
    Make sure to use a grid for the smallest pixel size you want to use, and
    don&rsquo;t veer from it.
  </figcaption>
</figure>
<p>
  If you&rsquo;re <em>creating</em> these icons, then be aware of how browsers
  can smudge things away before you go to town on details. Pick a minimum pixel
  size you&rsquo;re willing to accommodate, and make sure your details are
  chunky enough at that resolution; eg, hairlines should be thick enough to fill
  a single pixel at your minimum size; below that, they&rsquo;ll get fuzzed away.
</p>

<p>
  Next, be ready to tweak <code>font-size</code> and <code>vertical-align</code>
  to get your icons to orient properly &mdash; especially when next to each
  other or next to text. Just like normal letterforms, font icons deserve some
  careful treatment so that their visual relationships (mostly size
  related) to each other work well. But barring that, you&rsquo;ll spend some
  time tweaking specific alignment and sizes for each use case (note that the
  below is <a href="http://sass-lang.com/">SCSS</a>):
</p>

<p>
<pre>
.icon-feed {
  vertical-align: middle;

  .special-module > & {
    font-size: 1.7em;
    vertical-align: -.3em;
  }
}
</pre>
</p>

<figure class="right">
  <div class="curledShadow">
    <img src="/images/treated-icons.png"
      alt="Font icons untreated, and treated with vertical-align and font-size" />
  </div>
  <figcaption style="width: 437px;">
    Some font icons at the same <code>font-size</code> (white) and with tweaked
    <code>vertical-align</code> and <code>font-size</code> to achieve better
    proportions (red).
  </figcaption>
</figure>

<p>
  Thanks to CSS, this isn&rsquo;t a big deal. Naturally, this is more pronounced
  of an issue if your icons are inline with plain text, where most certainly
  you’ll need to shift <code>vertical-align</code> explicitly for each icon
  depending on the situation; however, in fairness, all of this needs to happen
  with raster image icons, as well.
</p>

<p>
  All of these gripes, in my opinion, are solidly overruled by the benefits of
  being able to <code>scale()</code>, change <code>color</code> and
  <code>opacity</code>, <code>animate</code>, and <code>transition</code> using
  CSS &mdash; none of which you can do with a single raster image icon (well,
  unless you don&rsquo;t care about pixellation).
</p>

<h2>SVG</h2>

<p>
  SVG, or <a href="http://www.w3.org/Graphics/SVG/">Scalable Vector Graphics</a>,
  is a really mature graphics standard that I have little experience with in a
  web context (though I have a lot of experience with vector drawing programs
  that happen to save as SVG). Because of the breadth of the standard, it’s well
  equipped for many things a vector in an icon font isn’t &mdash; namely,
  full-blown vector illustrations with many colors, gradients, opacities,
  strokes, what-have-you. Most of those things don’t apply to icons. But if ever
  you need more than one color in your icon, fonts won’t cut it, and you’ll have
  to use something like SVG.
</p>

<div class="row">
  <figure class="halfColumn">
    <div class="curledShadow">
      <img src="/images/rainbow-svg.png"
        alt="Rainbow in SVG" />
    </div>
    <figcaption>
      A rainbow in SVG.
    </figcaption>
  </figure>
  <figure class="halfColumn">
    <div class="curledShadow">
      <img src="/images/rainbow-font-icon.png"
        alt="Rainbow as a font icon" />
    </div>
    <figcaption>
      A rainbow in an icon font.
    </figcaption>
  </figure>
</div>

<p>
  That was the case with the
  <a href="https://minefold.com/marcocarag/jazzcrazedom">Minefold</a> logo that
  I wanted to add to my bottom links. There’s a second color that is fairly
  necessary for the identity. Perfect opportunity to try out SVG. So I cracked
  open Inkscape for the first time in years, traced out the logo, and saved it
  as “Plain SVG.”
</p>

<p>
  The resulting SVG file is basically markup that I copied and pasted straight
  into my HTML. I shaved out a few assorted meta tags that Inkscape adds that
  aren’t necessary, but for the most part, it worked well:
</p>

<p>
<pre class="limitHeight">
&lt;svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   version="1.1" width="71.25" height="60.375" id="svg3087"&gt;
  &lt;defs id="defs3091"&gt;
    &lt;filter x="-0.25" y="-0.25" width="1.5" height="1.5"
       color-interpolation-filters="sRGB" id="filter4802"&gt;
      &lt;feGaussianBlur result="blur" stdDeviation="2.5" in="SourceAlpha"
         id="feGaussianBlur4804" /&gt;
      &lt;feColorMatrix
         values="1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 "
         type="matrix" result="bluralpha" id="feColorMatrix4806" /&gt;
      &lt;feOffset result="offsetBlur" dy="3" dx="0" in="bluralpha"
         id="feOffset4808" /&gt;
      &lt;feMerge id="feMerge4810"&gt;
        &lt;feMergeNode in="offsetBlur" id="feMergeNode4812" /&gt;
        &lt;feMergeNode in="SourceGraphic" id="feMergeNode4814" /&gt;
      &lt;/feMerge&gt;
    &lt;/filter&gt;
  &lt;/defs&gt;
  &lt;path
     d="m 22.5,10.0625 -10.625,6.046875 0,34.203125 10.625,0 0,-21.609375 7.515625,8.890625 0.09375,0 11.03125,0 0.09375,0 7.53125,-8.9375 0,21.65625 10.609375,0 0,-34.203125 L 48.765625,10.0625 35.625,29.453125 22.5,10.0625 z"
     id="path3969" class="logo-face-shadow"
     style="fill:#074676;fill-opacity:1;stroke:none;filter:url(#filter4802)" /&gt;
  &lt;path
     d="m 48.758258,47.406249 10.617442,0 0,-34.198033 -10.617442,-6.049471 z"
     id="path3867" class="logo-face-dark"
     style="fill-opacity:1;stroke:none" /&gt;
  &lt;path
     d="m 22.501432,7.158745 18.642249,27.531268 -11.111274,0 L 11.91486,13.208216 z"
     id="path4881" class="logo-face-dark"
     style="fill-opacity:1;stroke:none" /&gt;
  &lt;path
     d="m 48.758258,7.158745 -18.642249,27.531268 11.111274,0 18.117547,-21.481797 z"
     id="path3921" class="logo-face-light"
     style="fill-opacity:1;stroke:none" /&gt;
  &lt;path
     d="m 22.492439,47.406249 -10.617439,0 0,-34.198033 10.617439,-6.049471 z"
     id="path3915" class="logo-face-light"
     style="fill-opacity:1;stroke:none" /&gt;
&lt;/svg&gt;
</pre>
</p>

<h2>Challenges and Benefits of SVG</h2>

<p>
  First thing about SVG is that if you care about pre-IE9, then either forget
  about it, or learn an abstraction library of some kind. (I recommend
  <a href="http://www.raphaeljs.com">Raphael JS</a>.) Barring that&hellip;
</p>

<p>
  SVG, as its name suggests, scales fairly well. However, it faces the same
  reduction issues as icon fonts. The solution is the same, though; don&rsquo;t
  scale down an icon below its intended minimum size.
</p>

<p>
  SVG does render much more consistently across browsers, at least so far as I
  can tell. Definitely a plus for the pixel OCD amongst us.
</p>

<p>
  The main challenge is styling. CSS can’t be used in the same way that it is
  for icon fonts (which are just text). In my case, the shadows and the bevel
  effect, for instance, which are CSS <code>text-shadow</code>s in the icon
  fonts, actually need to be baked right into the SVG itself. Fortunately,
  Inkscape has a pretty great “Drop Shadow” filter that makes creating the same
  shadow effect in SVG quite simple. And the bevel is simply another
  <code>&lt;path&gt;</code>.
</p>

<figure>
  <div class="curledShadow">
    <img src="/images/inkscape-drop-shadow.jpg" alt="Drop shadow tool in Inkscape." />
  </div>
  <figcaption>
    Shadows can&rsquo;t be applied with CSS, and need to be in your SVG. Still,
    in some cases, it&rsquo;s nice to have this much control.
  </figcaption>
</figure>

<p>
  If you are new to SVG drawing, though, this process isn’t very convenient.
  That’s one of the nice things about icon fonts &mdash; that they’re text, and
  can be styled that way, and you don’t necessarily need any special skills in
  vector drawing to accomplish certain effects.
</p>

<p>
Still, from a designer&rsquo;s perspective, it&rsquo;s great to have this level of explicit control. And obviously you can go much <a href="http://www.croczilla.com/bits_and_pieces/svg/samples/butterfly/butterfly.svg">further</a> <a href="http://www.croczilla.com/bits_and_pieces/svg/samples/invaders/invaders.svg">than</a> <a href="http://emacsformacosx.com/">just icons</a>.
</p>

<p>
That said, SVG is markup, and can be styled with CSS. Just note that the properties are different. For instance, SVG uses a different property for color: <code>fill</code> (versus text’s kinda’ misleading-in-comparison <code>color</code> property).
</p>

<p>
In the case of my icon, I wanted a hover interaction, which is slightly complicated as my icon is actually four separate <code>&lt;path&gt;</code> elements; since I want the entire icon to change color, I need to target all of these nodes explicitly. To do so, I added some classes to the <code>&lt;path&gt;</code>s to be able to hit them in CSS:
</p>

<p>
<pre>
&lt;!-- Markup --&gt;
&lt;path
   d="m 48.758258,47.406249 10.617442,0 0,-34.198033 -10.617442,-6.049471 z"
   <u>class="logo-face-dark"</u>
   style="fill-opacity:1;stroke:none" /&gt;
&lt;path
   d="m 22.501432,7.158745 18.642249,27.531268 -11.111274,0 L 11.91486,13.208216 z"
   <u>class="logo-face-dark"</u>
   style="fill-opacity:1;stroke:none" /&gt;
&lt;path
   d="m 48.758258,7.158745 -18.642249,27.531268 11.111274,0 18.117547,-21.481797 z"
   <u>class="logo-face-light"</u>
   style="fill-opacity:1;stroke:none" /&gt;
&lt;path
   d="m 22.492439,47.406249 -10.617439,0 0,-34.198033 10.617439,-6.049471 z"
   <u>class="logo-face-light"</u>
   style="fill-opacity:1;stroke:none" /&gt;

/* CSS */
.logo-face-dark { fill: #0a66ae; }
.logo-face-light { fill: #1087e1; }
</pre>
</p>

<p>
And since I want all four elements to change color when any of them are hovered, I actually need to target a parent; conveniently, the <code>&lt;svg&gt;</code> element serves that purpose well (pardon the SCSS again):
</p>

<p>
<pre>
svg:hover {
  .logo-face-dark { fill: #0a66ae + 100; }
  .logo-face-light { fill: #1087e1 + 100; }
}
</pre>
</p>

<p>
One hiccup: I lose <code>transition</code> when in Chrome. Not sure why. But also not a huge deal (<code>transition</code> is one of those CSS3 properties that we should all be okay with degrading away). Though, this is probably a good reason to use script instead of CSS for interaction purposes in SVG.
</p>

<h2>Conclusion</h2>

<p>
To start with the obvious, while I was happy to pursue the combination as an experiment in my footer, I don’t suggest that anyone mix and match SVG and fonts for icons; for the sake of consistency, do one or the other.
</p>

<p>
I can see myself using SVG entirely at some point. I like the extra visual control and rendering consistency, and other simple things like, say, supporting more than one color at a time in a single drawing. I’ll need to spend some time digging into animating and transitioning interactions before I completely make the dive.
</p>

<p>
But for the vast majority of simple icon UI, it’s hard to argue against icon fonts. It’s pretty huge that they take on the very same style properties as text. <code>@font-face</code> is supported pretty widely at this point. There’s no question that they’re more convenient than rasterized icons and sprites, especially now that there’s great tools for creating them, like <a href="http://keyamoon.com/icomoon/#toHome">IcoMoon</a>. For cross-browser, scalable, easily styled icons, they’re the way to go for now.
</p>
