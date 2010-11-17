require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out CMS pages" do
  
  scenario "requesting / should map to /ada_home" do
    cms_page = Page.make(:title => "ADA Home", :archive => nil)
    visit "/"
    page.should have_content('ADA Home')
  end
end
