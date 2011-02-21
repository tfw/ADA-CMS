module HelperMethods
  def visit_archive(slug)
    archive = Archive.find_by_slug(slug)
    visit staff_archive_path(archive)
    # visit "/staff/archives/#{slug}"    
  end
  
  def visit_integrations(archive)
    visit_archive(archive.slug)
    click_link("Integrations")
    page.should have_content("Integrations")      
  end
  
end

RSpec.configuration.include HelperMethods, :type => :acceptance
