module StreamsHelper
  def markdown(description)
   @html_renderer  ||= Redcarpet::Render::HTML.new(filter_html: true,
                                                   hard_wrap: true,
                                                   link_attributes: { target: "_blank" })

   @renderer       ||= Redcarpet::Markdown.new(@html_renderer,
                                               no_intra_emphasis: true,
                                               autolink: true,
                                               tables: true,
                                               strikethrough: true,
                                               superscript: true,
                                               underline: true,
                                               prettify: true,
                                               highlight: true)

   @renderer.render(description).html_safe
  end
end
