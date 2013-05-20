class CurvedShadowImage < Liquid::Tag
  def initialize(tag_name, src, tokens)
    super

    tokens = src.split '|'
    @src = tokens[0]
    @url = tokens[1]
    @position = tokens[2] == '' ? 'fullWidth' : tokens[2]
    @alt = tokens[3]
    @caption = tokens[4]
  end

  def render(context)
    caption_template = @caption ?
      "<figcaption>#{@caption}</figcaption>" : ""

    "<figure class=\"#{@position}\">
        <div class=\"curledShadow\">
          <a href=\"#{@url}\">
            <img src=\"#{@src}\"
              alt=\"#{@alt}\" />
          </a>
        </div>
        #{caption_template}
    </figure>"
  end

  Liquid::Template.register_tag('curved_shadow_image', self)
end
