require File.dirname(__FILE__) + '/acceptance_helper'

feature "The Archives" do

  background do
    @admin = make_admin #creates an admin to login with
    login(@admin)
  end
  
  describe "serving archives from controller via slug" do
    scenario "visit ADA dashboard" do
      visit '/staff/archives/ada'
      page.should have_content("Archives: ADA")
    end

    scenario "visit Social Science dashboard" do
      visit '/staff/archives/social-science'
      page.should have_content("Archives: Social Science")
    end

    scenario "visit Historical dashboard" do
      visit '/staff/archives/historical'
      page.should have_content("Archives: Historical")
    end

    scenario "visit Indigenous dashboard" do
      visit '/staff/archives/indigenous'
      page.should have_content("Archives: Indigenous")
    end

    scenario "visit Longitudinal dashboard" do
      visit '/staff/archives/longitudinal'
      page.should have_content("Archives: Longitudinal")
    end

    scenario "visit Qualitative dashboard" do
      visit '/staff/archives/qualitative'
      page.should have_content("Archives: Qualitative")
    end

    scenario "visit International dashboard" do
      visit '/staff/archives/international'
      page.should have_content("Archives: International")
    end
  end
  
end
