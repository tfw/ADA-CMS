module ApplicationHelper
  def archive_css(page)
    page.archive.nil? ? 'default' : page.archive.name
  end
end
