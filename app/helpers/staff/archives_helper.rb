module Staff::ArchivesHelper

  #only render the archive partial if it exists
  #(this is to prevent tests using blueprinted archives from breaking)
  def render_archive_partial(archive)
    if File.exists?("app/views/staff/archives/_#{archive.slug}.html.erb")
      render :partial => "#{@archive.slug}"
    end
  end
end