module ApplicationHelper
  def count(key, options = {})
    @keys       ||= {}
    @keys[key]  ||= (options[:start_at] || 1) - 1
    @keys[key]   += 1
  end

 def avatar(avatarable = current_user)
   image_tag(avatarable.avatar, class: "avatar", height: 40, width: 40)
 end

  def body_class
    kls = []
    kls << "theme-default"
    kls << "no-main-menu" unless content_for?(:menu)
    kls << content_for(:body_class) if content_for?(:body_class)

    kls.join(" ")
  end
end
