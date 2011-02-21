require File.dirname(__FILE__) + '/../../acceptance_helper'

feature "Managing archive study blocks" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
    @archive = Archive.make
  end
  
  after(:each) do
    sign_out
  end

  scenario "I can create a new archive study block for an archive"  do
    create_block(@archive, "test123")
  end

  scenario "I can edit an archive study block for an archive"  do
    create_block(@archive, "test123")
    block = ArchiveStudyBlock.find_by_ddi_id("test123")
    visit edit_staff_archive_archive_study_block_path(@archive, block)
    fill_in("archive_study_block_ddi_id", :with => "456passed")
    click_button("Update Archive study block")
    page.should have_content("456passed")    
  end
  
  #capybara can't http delete - rack-test can, look into this later.
  
  
  def create_block(archive, study)
    visit new_staff_archive_archive_study_block_path(archive)
    page.should have_content("Return to Integrations")
    fill_in("archive_study_block_ddi_id", :with => study)
    click_button("Create Archive study block")
    page.should have_content(study)
  end
end
