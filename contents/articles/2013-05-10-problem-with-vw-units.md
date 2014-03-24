---
title: "Problem with CSS viewport units for width?"
tags: css, development
date: 2013-05-10 09:07
---
<p>
  Getting some unexpected behavior when using viewport units (<code>vw</code>,
  <code>vh</code>, <code>vmin</code>, and <code>vmax</code>) to size width in
  Webkit browsers:
</p>

<blockquote class="big quotation">
  When elements have a fixed width set in a viewport unit, their parents no
  longer contain them properly in Webkit browsers.
</blockquote>

<p>
  Open the following in Chrome (tried version 26 stable, and 29 Canary) or
  Safari 6, and compare to Firefox (tried in version 20):
</p>

<pre class="codepen" data-height="300" data-type="result" data-href="oABEh" data-user="jazzcrazed" data-safe="true"><code></code><a href="http://codepen.io/jazzcrazed/pen/oABEh">Check out this Pen!</a></pre>
<script async src="http://codepen.io/assets/embed/ei.js"></script>

<p>Here&rsquo;s a screenshot of what that looks like in Chrome 26:</p>

<figure class="fullWidth">
  <div class="curledShadow">
    <img src="/images/css-viewport-unit-width-chrome.png"
      alt="Elements not containing their children properly when children have widths set in viewport units in Chrome" />
  </div>
</figure>

<p>Here&rsquo;s the same thing in Firefox 20:</p>

<figure class="fullWidth">
  <div class="curledShadow">
    <img src="/images/css-viewport-unit-width-ff.png"
      alt="Elements containing their children properly when children have widths set in viewport units in Firefox" />
  </div>
</figure>

<p>
  What I&rsquo;d expect is the Firefox case, where the dark green parent element
  properly stretches to fit the width of its content (in this case, the child
  elements with fixed viewport-unit widths).
</p>

<p>
  What do you think? A real bug? Certainly, one of them is wrong, and I&rsquo;m
  pretty sure it&rsquo;s Webkit, since the behavior with other types of units
  (<code>px</code>, <code>em</code>, <code>rem</code>, etc.) is like the Firefox
  screenshot. I&rsquo;ll have to check it out in IE10, which supports viewport
  units as well, <a href="http://caniuse.com/viewport-units">according to
    Can I Use</a>.
</p>

<p>
  Additionally, it looks like there&rsquo;s weirdness in the height, considering
  the lime green box in the Firefox screenshot is so much taller. Probably a
  difference in what each browser is considering the viewport. I&rsquo;ll
  investigate that further.
</p>
