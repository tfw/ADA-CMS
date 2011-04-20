require File.dirname(__FILE__) + '/../acceptance_helper'

feature "DDI Mappings" do

  background do
    @admin = make_user(:administrator)
  end
  
  scenario "dashboard should link to ddi_mappings" do
    sign_in(@admin)
    click_link("ADA")  
    click_link("DDI Mappings")
    page.should have_content("Map a friendly name to a DDI Element");
    sign_out
  end
  
  scenario "creating a ddi_mapping" do
    sign_in(@admin)
    mapping = DdiMapping.make #DDI Mappings are created by the integration, the idea is you add the human readable term later
    visit '/staff/ddi_mappings'
    # puts page.body
    select(mapping.ddi, :from => 'DDI')
    fill_in('Human readable', :with => "test")
    click_button("Create Mapping")
    sign_out
  end
  
end