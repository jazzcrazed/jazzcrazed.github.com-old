cheerio = require 'cheerio'

module.exports = (env, callback) ->

  if !env.helpers.figurifyImages
    env.helpers.figurifyImages = (html) ->

      $ = cheerio.load(html)

      figurify = (el) ->
        src = $(el).attr("src")
        alignment = src.split("?align=")[1] || "fullWidth"
        url = $(el).attr("title")
        caption = $(el).attr("alt")

        template = "<figure class='#{alignment}'>
          <div class='curledShadow'>
            <a href='#{url}'>
              <img src='#{src}' alt='#{el.alt}' />
            </a>
          </div>
          <figcaption>#{caption}</figcaption>
        </figure>"

        return template

      $("p img").map (i, el) ->
        $(@).closest('p').replaceWith(figurify @)

      return $.html()

  callback()
