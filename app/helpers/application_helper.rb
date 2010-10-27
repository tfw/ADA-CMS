module ApplicationHelper
  def archive_css
    current_archive.nil? ? 'default' : current_archive.name
  end
end
