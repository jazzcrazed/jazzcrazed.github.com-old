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
        alt = if caption? then $(caption).text() else null

        template = "<figure class='#{if alignment? then alignment else ""}'>
          <div class='curledShadow'>"
        template += "<a href=\"#{url}\">" if url?
        template += "<img src=\"#{src}\" alt=\"#{alt}\" />"
        template += "</a>" if url?
        template += "</div>"
        template += "<figcaption>#{caption}</figcaption>" if caption?
        template += "</figure>"

        return template

      $("p img").map (i, el) ->
        $(@).closest('p').replaceWith(figurify @)

      return $.html()

  callback()
