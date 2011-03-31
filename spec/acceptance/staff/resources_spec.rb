require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Managing site resources" do

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
    image_id = upload_image('clear cross', "#{::Rails.root.to_s}/public/images/clear_cross.png")
    page.should have_content("was successfully created")
    page.should have_content("image/png")
    page.should have_content("384 Bytes")
    click_link("Back to Resources index")
    page.should have_content("clear cross")
    click_link("Edit")
    visit("/images/clear_cross.png")
    page.status_code.should == 200
    page.response_headers["Content-Type"].should == "image/png"
  end

  scenario "I can upload documents, save, view and re-edit it" do
    document_id = upload_document('ten commandments', "#{::Rails.root.to_s}/spec/acceptance/staff/Commandments.doc")
    page.should have_content("was successfully created")
    page.should have_content("application/msword")
    page.should have_content("25 KB")
    click_link("Back to Resources index")
    page.should have_content("ten commandments")
    click_link("Edit")
  end

end
