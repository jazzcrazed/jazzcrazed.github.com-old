$ ->
  figurify = (el) ->
    alignment = el.src.split("?align=")[1] || "fullWidth"
    url = el.title
    caption = el.alt

    $template = $("<figure class='#{alignment}'>
      <div class='curledShadow'>
        <a href='#{url}'>
        </a>
      </div>
      <figcaption>#{caption}</figcaption>
    </figure>")

    $template.find("a").append(el)
    $template[0]

  $(".postCopy p img").each ->
    $(@).closest("p").replaceWith(figurify @)
