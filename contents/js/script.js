(function() {
  $(function() {
    var figurify;
    figurify = function(el) {
      var $template, alignment, caption, url;
      alignment = el.src.split("?align=")[1] || "fullWidth";
      url = el.title;
      caption = el.alt;
      $template = $("<figure class='" + alignment + "'> <div class='curledShadow'> <a href='" + url + "'> </a> </div> <figcaption>" + caption + "</figcaption> </figure>");
      $template.find("a").append(el);
      return $template[0];
    };
    return $(".postCopy p img").each(function() {
      return $(this).closest("p").replaceWith(figurify(this));
    });
  });

}).call(this);
