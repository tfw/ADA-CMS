require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Creating media" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
  end

  after(:each) do
    sign_out
  end

  scenario "I can access the site resources page"  do
    click_link("Site Resources")
    page.should have_content("Shared Resources")
  end

  scenario "I can upload images, save, view and re-edit it" do
    media_id = upload_image('clear cross', "#{RAILS_ROOT}/public/images/clear_cross.png")
    page.should have_content("was successfully created")
    page.should have_content("image/png")
    page.should have_content("384 Bytes")
    click_link("Back to Resources index")
    page.should have_content("clear cross")
    click_link("Edit")
  end

end
