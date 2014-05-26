module ApplicationHelper
  def count(key, options = {})
    @keys       ||= {}
    @keys[key]  ||= (options[:start_at] || 1) - 1
    @keys[key]   += 1
  end
end
