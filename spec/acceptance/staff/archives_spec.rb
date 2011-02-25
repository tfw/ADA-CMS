require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Archives management:" do

  background do
    @roles = Inkling::Role.all
  end  
  
  describe "staffer accesses" do
    scenario "ADA" do
      users_for_roles_visit_archive_tab(@roles, "ada", "ADA")
    end
    
    scenario "Social Science" do
      users_for_roles_visit_archive_tab(@roles, "social-science", "Social Science")
    end
    
    scenario "Historical" do
      users_for_roles_visit_archive_tab(@roles, "historical", "Historical")
    end
    
    scenario "Indigenous" do
      users_for_roles_visit_archive_tab(@roles, "indigenous", "Indigenous")
    end
    
    scenario "Longitudinal" do
      users_for_roles_visit_archive_tab(@roles, "longitudinal", "Longitudinal")
    end
    
    scenario "Qualitative" do
      users_for_roles_visit_archive_tab(@roles, "qualitative", "Qualitative")
    end
    
    scenario "International" do
      users_for_roles_visit_archive_tab(@roles, "international", "International")
    end
  end
    
  describe "managing archive pages" do  
    scenario "create a page then follow link to its public location" do
      admin = make_user(:administrator)
      sign_in(admin)
      create_page(Archive.historical, "test page", "sample content")
      
      within(:xpath, "//li[@id='page-options-/historical/test-page']") do
        click_link("Public View")
      end
            
      page.should have_content("sample content")
      sign_out
    end
    
    scenario "edit a page" do
      admin = make_user(:administrator)
      sign_in(admin)
      create_page(Archive.historical, "test page", "sample content")
      click_link("Edit")
      page.should have_content("Edit")
      sign_out
    end
    
    scenario "delete a page" do
      admin = make_user(:administrator)
      sign_in(admin)
      create_page(Archive.historical, "test page", "sample content")
      click_link("Delete")
      page.should have_content("successfully destroyed")
      sign_out
    end    
  end
  
  def users_for_roles_visit_archive_tab(roles, archive, breadcrumb)
    for role in roles
      user = make_user(role.name)
      sign_in(user)
      
      visit_archive(archive)
      confirm_text_in_breadcrumb(breadcrumb)
      sign_out
    end
  end
  
  def confirm_text_in_breadcrumb(crumb)
    page.should have_content("Archives: #{crumb}")    
  end
end
