cheerio = require 'cheerio'

module.exports = (env, callback) ->

  if !env.helpers.figurifyImages
    env.helpers.figurifyImages = (html) ->

      $ = cheerio.load(html)

      figurify = (el) ->
        src = $(el).attr("src")
        alignment = src.split("?align=")[1]
        url = $(el).attr("title")
        caption = $(el).attr("alt")

        template = "<figure class='#{if alignment? then alignment else ""}'>
          <div class='curledShadow'>"
        template += "<a href='#{url}'>" if url?
        template += "<img src='#{src}' alt='#{caption}' />"
        template += "</a>" if url?
        template += "</div>"
        template += "<figcaption>#{caption}</figcaption>" if caption?
        template += "</figure>"

        return template

      $("p img").map (i, el) ->
        $(@).closest('p').replaceWith(figurify @)

      return $.html()

  callback()
