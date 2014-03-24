---
title: "Jekyll Plugins in Github Pages"
date: 2013-05-22 22:08
tags: development
---
I thought it was high time I made some effort in cleaning up and 
streamlining my post composition workflow, while riding the wave of my
[small redesign](/2013/05/09/redesigned-ish)).

<span class="more"></span>

The first thought I had was that I should damn well try to use
[Markdown](http://daringfireball.net/projects/markdown/),
as that's what most sane people who use Jekyll (and
[Middleman](http://www.middlemanapp.com) and other blog-friendly
generators) use. Along those lines, [Jekyll
Bootstrap](http://www.jekyllbootstrap.com) comes with a handy [Rake](http://rake.rubyforge.org/)
task: `rake post title=""`, which will generate a Markdown file in
`_posts` with the appropriate filename and YAML frontmatter. I made a
minor tweak to include the time, as I use that in my post layout.

Next, I wanted to stop the copy pasta involved in rendering my silly 3D
shadow effect with images. So, I made a quick and dirty (I mean
*really* dirty) [Jekyll
plugin](https://github.com/jazzcrazed/jazzcrazed.github.com/blob/source/_plugins/curved_shadow_image.rb)
that acts like a view partial, taking in the necessary parameters to
spit out my precious markup without me having to repeatedly type/paste said
markup. Works well enough, but I'm sure there's refactoring
to come (like, I hate that I'm not passing my parameters as an
object).

In order to use my plugin -- and any plugin, for that matter
-- I would have to adjust my workflow with [Github Pages](http://pages.github.com/),
since it runs Jekyll in "safe mode" and doesn't
execute plugins (basically, arbitrary [Ruby](http://www.ruby-lang.org/en/]), so
that seems reasonable of them). This basically means I need to compile
the posts and pages on my local machine, rather than let Github Pages do
it. [ixti has a good post](http://ixti.net/software/2013/01/28/using-jekyll-plugins-on-github-pages.html)
on how to go about this in a way that isn't too painful;
basically, I moved [my repo's](https://github.com/jazzcrazed/jazzcrazed.github.com)
master branch to a new branch called "source", made that my
default branch in Github, and used the `rake publish` task ixti outlined to do a
Jekyll compilation, move the resulting `_site` output to master, and
`force push` it up, all in one command.

Felt a little nervous doing a `force push`, especially to master, but
that was just my conditioning after years of avoiding *exactly that.*
Besides, my source branch is effectively the new master. And now I can
use [Jekyll plugins](http://jekyllrb.com/docs/plugins/) on my Github
Pages site!

Some things I have to be careful about: it doesn't matter
what's pushed up to origin/source -- the Jekyll compilation
that happens as a result of `rake publish` will compile anything and
everything. So, I need to make sure I'm clean locally before
publishing; I basically ensure that `git status` returns `nothing to
commit` before I dare `rake publish`. I could surely adjust the Rake
task to smooth this over -- a Github WebHook feels like
the right place. That'll be for a future iteration&hellip;

Hell, I'm just happy to be using Markdown!
