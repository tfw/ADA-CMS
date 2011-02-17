module HelperMethods
  def visit_archive(slug)
    visit "/staff/archives/#{slug}"    
  end
  
  def visit_integrations(archive)
    visit_archive(archive.slug)
    click_link("Integrations")
    page.should have_content("Integrations")      
  end
  
end

RSpec.configuration.include HelperMethods, :type => :acceptance
