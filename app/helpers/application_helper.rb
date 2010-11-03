module ApplicationHelper
  def archive_css(page)
    page.archive.nil? ? 'default' : page.archive.name.gsub(" ", "").underscore
  end
end
