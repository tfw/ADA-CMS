module ApplicationHelper
  def archive_css(page)
    page.archive.nil? ? 'default' : page.archive.name.gsub(" ", "").underscore
  end
  
  def placeholder_icon
    icon = rand(3) + 1
    image_tag("placeholders/#{icon}.png", :size => "20x20", :class => "placeholder-icon")
  end
end
