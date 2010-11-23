require File.dirname(__FILE__) + '/../acceptance_helper'

feature "The Archives" do

  background do
    @roles = [:administrator, :manager, :approver, :archivist]
  end
  
  describe "serving archives from controller via slug" do
    scenario "visit ADA dashboard" do
      users_for_roles_visit_archive_tab(@roles, "ada", "ADA")
    end
    
    scenario "visit Social Science dashboard" do
      users_for_roles_visit_archive_tab(@roles, "social-science", "Social Science")
    end
    
    scenario "visit Historical dashboard" do
      users_for_roles_visit_archive_tab(@roles, "historical", "Historical")
    end
    
    scenario "visit Indigenous dashboard" do
      users_for_roles_visit_archive_tab(@roles, "indigenous", "Indigenous")
    end
    
    scenario "visit Longitudinal dashboard" do
      users_for_roles_visit_archive_tab(@roles, "longitudinal", "Longitudinal")
    end
    
    scenario "visit Qualitative dashboard" do
      users_for_roles_visit_archive_tab(@roles, "qualitative", "Qualitative")
    end
    
    scenario "visit International dashboard" do
      users_for_roles_visit_archive_tab(@roles, "international", "International")
    end
  end
  
  def users_for_roles_visit_archive_tab(roles, archive, breadcrumb)
    for role in roles
      user = make_user(role)
      sign_in(user)
      
      visit_sub_archive(archive)
      confirm_text_in_breadcrumb(breadcrumb)
      sign_out
    end
  end
  
  def visit_sub_archive(name)
    visit "/staff/archives/#{name}"    
  end

  def confirm_text_in_breadcrumb(crumb)
    page.should have_content("Archives: #{crumb}")    
  end
end
